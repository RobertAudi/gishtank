require "fileutils"

class Gish::Commands::Hooks < Gish::Commands::BasicCommand
  define_method Gish::Commands::COMMAND_EXECUTION_METHOD do
    if subcommands.empty?
      puts red(message: "gish: The hooks command require a subcommand\n")
      Gish::Documentation::Hooks.new.show.usage
      self.status_code = 1
    else
      unless File.file?(ENV["GISHTANK_GIT_REPOS_HOOKED"]) || File.file?(ENV["GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED"])
        puts yellow(message: "No repos hooked or blacklisted")
        return
      end

      hooked_count = File.foreach(ENV["GISHTANK_GIT_REPOS_HOOKED"]).inject(0) {|c, line| c + 1}
      blacklisted_count = File.foreach(ENV["GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED"]).inject(0) {|c, line| c+1}

      if hooked_count == 0 && blacklisted_count == 0
        puts yellow(message: "No repos hooked or blacklisted")
        return
      end

      send subcommands.shift
    end
  end

  def add
    if arguments.empty?
      repo = Dir.getwd
    else
      repo = File.expand_path(arguments.shift)

      unless File.directory?(repo)
        raise Gish::Exceptions::DirectoryNotFoundError.new directory: repo
      end
    end

    hooks_dir = File.join(repo, ".git", "hooks")
    unless File.directory?(hooks_dir)
      raise Gish::Exceptions::NotAGitRepositoryError.new directory: repo
    end

    hooks_to_add = Dir[File.join(ENV["GISHTANK_HOOKS_DIR"], "*")]

    unless options.empty?
      raise Gish::Exceptions::InvalidOptionsError

      # TODO: Implement options handlings
      #
      # Right now there is only one hook
      # so it's not important if this
      # functionality is not here yet
      #
      # Valid options:
      #
      # -a, --all: Add all hooks
    end

    hooks_to_add.each do |hook|
      new_hook = File.join(hooks_dir, File.basename(hook))

      hook_addition = -> {
        hook_contents = File.open(hook, "rb").read

        File.open(new_hook, "w") do |f|
          f.puts hook_contents
        end

        FileUtils.chmod "a+x", new_hook

        unless File.readlines(ENV["GISHTANK_GIT_REPOS_HOOKED"]).grep(/#{repo}/).count > 0
          File.open(ENV["GISHTANK_GIT_REPOS_HOOKED"], "ab") { |f| f.puts repo }
        end

        puts green(message: "Added the #{File.basename(hook)} hook to the repo: #{repo}")
      }

      if File.file?(new_hook)
        message = "This git repo already has a #{File.basename(hook)} hook\n"
        message << "Do you want to replace it? [YynN]"

        prompt message: message, &hook_addition
      else
        hook_addition.call
      end
    end
  end

  def clean
    if arguments.empty?
      notice = "You are about to remove all the repos\n"
      notice << "from the hooked and blacklisted list!\n"
      notice << "Are you sure you want to proceed? [YynN]"

      query = -> {
        File.unlink ENV["GISHTANK_GIT_REPOS_HOOKED"] if File.file?(ENV["GISHTANK_GIT_REPOS_HOOKED"])
        puts red(message: "Removed list of hooked repos")

        File.unlink ENV["GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED"] if File.file?(ENV["GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED"])
        puts red(message: "Removed list of blacklisted repos")
      }
    else
      if options.empty?
        notice = "You are about to remove some of the repos\n"
        notice << "from the hooked and blacklisted list!\n"
        notice << "Are you sure you want to proceed? [YynN]"

        files = {
          hooked: ENV["GISHTANK_GIT_REPOS_HOOKED"],
          blacklisted: ENV["GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED"]
        }
      else
        if options =~ /-d|--r/
          notice = "You are about to remove duplicates\n"

          if options =~ /-{1,2}h/
            notice << "from the hooked repos list!\n"
            files = {
              hooked: ENV["GISHTANK_GIT_REPOS_HOOKED"]
            }
          elsif options =~ /-{1,2}b/
            notice << "from the blacklisted repos list!\n"
            files = {
              blacklisted: ENV["GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED"]
            }
          else
            notice << "from the hooked and blacklisted repos lists!\n"
            files = {
              hooked: ENV["GISHTANK_GIT_REPOS_HOOKED"],
              blacklisted: ENV["GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED"]
            }
          end

          notice << "Are you sure you want to proceed? [YynN]"

          hooked_repos_removed = []
          blacklisted_repos_removed = []
          skipped_repos = []

          query = -> {
            changed = []
            contents = { hooked: IO.readlines(files[:hooked]), blacklisted: IO.readlines(files[:blacklisted]) }

            blacklisted_repos_to_remove = []

            files.each do |type, f|
              if arguments.empty?
                contents_of_other_type = contents.reject { |k, v| k == type }

                if contents[type].uniq == contents[type] && contents[type].uniq == contents_of_other_type
                  changed << false
                else
                  updated_lines = []
                  contents[type].each do |line|
                    if updated_lines.include?(line)
                      to_add = false
                    else
                      if type == :hooked && hooked_repos_removed.include?(line)
                        to_add = false
                      else
                        to_add = true
                      end
                    end

                    if contents_of_other_type.values.flatten.include?(line)
                      if type == :blacklisted
                        to_add = false if blacklisted_repos_to_remove.include?(line)
                      else
                        message = "\nThis repo is in both hooked and blacklisted lists: #{blue(message: line)}"
                        message << yellow(message: "Which entry do you want to keep? [hHbBsSnN?]")

                        # Options:
                        # --------
                        # h or H - Keep the hooked repo
                        # b or B - Keep the blacklisted repo
                        # s or S - Do not do anything for now
                        # n or N - Remove both repos

                        answers = {
                          h: -> {
                            blacklisted_repos_to_remove << line
                            blacklisted_repos_removed << line
                          },

                          b: -> {
                            to_add = false
                            hooked_repos_removed << line
                          },

                          s: -> {
                            skipped_repos << line
                          },

                          n: -> {
                            to_add = false
                            blacklisted_repos_to_remove << line
                            hooked_repos_removed << line
                            blacklisted_repos_removed << line
                          },

                          :"?" => -> {
                            message = "\nh or H - Keep the hooked repo\n"
                            message << "b or B - Keep the blacklisted repo\n"
                            message << "s or S - Do not do anything for now\n"
                            message << "n or N - Remove both repos\n"
                            message << "? - Show this help message\n"

                            puts message
                          }
                        }

                        unless hooked_repos_removed.include?(line) || blacklisted_repos_removed.include?(line) || skipped_repos.include?(line)
                          complex_prompt message: message, answers: answers, loop_char: "?"
                        end
                      end
                    end

                    if to_add && (!hooked_repos_removed.include?(line) || !blacklisted_repos_removed.include?(line))
                      updated_lines << line
                    end
                  end

                  File.open(f, "w") { |ff| ff.puts updated_lines.join("") unless updated_lines.empty? }
                  if hooked_repos_removed.count > 0 || blacklisted_repos_removed.count > 0
                    changed << true
                  else
                    changed << false
                  end
                end
              else
                updated_lines = []
                contents[type].each do |line|
                  added = false

                  arguments.each do |arg|
                    if line =~ /#{arg}/
                      if updated_lines.include?(line)
                        if type == :hooked
                          hooked_repos_removed << line
                        else
                          blacklisted_repos_removed << line
                        end
                      else
                        updated_lines << line
                      end
                    else
                      unless added
                        updated_lines << line
                        added = true
                      end
                    end
                  end
                end

                changed << (updated_lines != contents[type])
                if changed.last
                  File.open(f, "w") do |ff|
                    ff.puts updated_lines.join("")
                  end
                end
              end
            end

            if changed.count(false) == files.count
              puts yellow(message: "\nNothing changed...")
            else
              puts

              hooked_repos_removed.uniq.each { |r| puts red(message: "Removed duplicate repo from the hooked list: #{r.chomp}") }
              blacklisted_repos_removed.uniq.each { |r| puts red(message: "Removed duplicate repo from the blacklisted list: #{r.chomp}") }
            end
          }
        elsif options =~ /\A-{1,2}h/
          notice = "You are about to remove some of the repos\n"
          notice << "from the hooked list!\n"
          notice << "Are you sure you want to proceed? [YynN]"

          files = {
            hooked: ENV["GISHTANK_GIT_REPOS_HOOKED"]
          }
        elsif options =~ /\A-{1,2}b/
          notice = "You are about to remove some of the repos\n"
          notice << "from the blacklisted list!\n"
          notice << "Are you sure you want to proceed? [YynN]"

          files = {
            blacklisted: ENV["GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED"]
          }
        end
      end

      query ||= -> {
        changed = []
        files.each do |type, f|
          changed << remove_lines_in(file: f, lines: arguments, message: "Do you want to remove this repo from the #{type} list? [YynN] ", success: "Repo removed!")
        end

        puts yellow(message: "\nNothing changed...") if changed.count(false) == files.count
      }
    end

    prompt message: notice, &query
  end

  def repos(command: "list", only: nil)
    raise ArgumentError unless ["hooked", "blacklisted", nil].include? only

    hooked_count = File.foreach(ENV["GISHTANK_GIT_REPOS_HOOKED"]).inject(0) {|c, line| c + 1}
    blacklisted_count = File.foreach(ENV["GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED"]).inject(0) {|c, line| c+1}

    if arguments.empty?
      if hooked_count > 0 && only != "blacklisted"
        puts header("Hooked repos")
        puts File.open(ENV["GISHTANK_GIT_REPOS_HOOKED"], "rb").read
      elsif only == "hooked"
        puts yellow(message: "No hooked repos")
      end

      if blacklisted_count > 0 && only != "hooked"
        puts if hooked_count > 0

        puts header("Blacklisted repos")
        puts File.open(ENV["GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED"], "rb").read
      elsif only == "blacklisted"
        puts yellow(message: "No blacklisted repos")
      end
    else
      if options.empty?
        if arguments.first == "list"
          self.arguments = []
          repos
        elsif arguments.first == "search"
          search
        end
      else
        if options =~ /\A-{1,2}h/
          if arguments.first == "list" || arguments.empty?
            self.arguments = []
            repos only: "hooked"
          elsif arguments.first == "search"
            search only: "hooked"
          end
        elsif options =~ /\A-{1,2}b/
          if arguments.first == "list" || arguments.empty?
            self.arguments = []
            repos only: "blacklisted"
          elsif arguments.first == "search"
            search only: "blacklisted"
          end
        end
      end
    end
  end

  private

  def complex_prompt(message: "", answers: {}, loop_char: "")
    raise ArgumentError if message.empty?
    raise Gish::Exceptions::MissingPromptAnswersError if answers.empty?
    raise Gish::Exceptions::InvalidPromptAnswerError unless answers.values.select { |v| !v.is_a?(Proc) }.empty?

    print "#{message.rstrip} "

    response = loop_char
    action = -> {
      response = $stdin.gets.chomp

      if answers.keys.include?(response.to_sym)
        answers[response.downcase.to_sym].call
      end
    }

    if loop_char.empty?
      action.call
    else
      while response == loop_char
        action.call
        if response == loop_char
          print "#{message.rstrip} "
        end
      end
    end

    response
  end

  def prompt(message: "Are you sure you want to proceed? [YynN] ", &block)
    print yellow(message: "#{message.rstrip} ")

    response = $stdin.gets.chomp

    positive = response =~ /\Ay/i ? true : false
    # FIXME: Use block_given? instead
    yield if !block.nil? && positive
    positive
  end

  def search(file: "", queries: [], bare: false, only: "")
    if bare && (file.empty? || !File.file?(file))
      raise Gish::Exceptions::FileNotFoundError.new file: file
    end

    if bare
      return if queries.empty?

      results = []
      File.open(file) do |f|
        f.each do |line|
          results << line if line =~ /#{queries.join("|")}/
        end
      end

      return results
    else
      arguments.shift

      if arguments.empty?
        puts red(message: "gish: Search query required")
        Gish::Documentation::Hooks.new.repos
        self.status_code = 1
        return
      end

      if only == "hooked"
        files = {
          hooked: ENV["GISHTANK_GIT_REPOS_HOOKED"]
        }
      elsif only == "blacklisted"
        files = {
          blacklisted: ENV["GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED"]
        }
      else
        files = {
          hooked: ENV["GISHTANK_GIT_REPOS_HOOKED"],
          blacklisted: ENV["GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED"]
        }
      end

      results = { hooked: [], blacklisted: [] }

      files.each do |type, f|
        results[type] << search(file: f, queries: arguments, bare: true)
        results[type].flatten!
      end

      if results.values.flatten.empty?
        puts yellow(message: "No matched repos found.")
        return
      end

      output = ""

      unless results[:hooked].empty?
        output << header("Hooked repos")
        output << results[:hooked].map { |r| r.gsub(/(#{arguments.join("|")})*/, blue(message: '\1')) }.join("")
      end

      unless results[:blacklisted].empty?
        output << "\n" unless results[:hooked].empty?
        output << header("Blacklisted repos")
        output << results[:blacklisted].map { |r| r.gsub(/(#{arguments.join("|")})*/, blue(message: '\1')) }.join("")
      end

      puts output
    end
  end

  def remove_lines_in(file: "", lines: [], message: "Do you want to remove this line? [YynN]", success: "Line removed!")
    if file.empty? || !File.file?(file)
      raise Gish::Exceptions::FileNotFoundError.new file: file
    end

    return if lines.empty?

    updated_file = ""

    IO.readlines(file).map do |line|
      update = true

      lines.each do |l|
        if line =~ /#{l}/i
          msg = "Match found: #{line}"
          msg << message

          update = prompt(message: msg) do
            puts green(message: success)
          end

          update = !update
          break
        end
      end

      updated_file << line if update
    end

    changed = true

    File.open file, "rb" do |f|
      if f.read == updated_file
        changed = false
      end
    end

    File.open file, "wb" do |f|
      f.print updated_file
    end

    return changed
  end

  def options
    return @options if defined? @options

    @options = arguments.dup
    @options.select! { |a| a.start_with? "-" }

    duplicates = { h: [], b: [], d: [] }
    @options.each do |o|
      duplicates[:h] << o if o =~ /\A-{1,2}h/
      duplicates[:b] << o if o =~ /\A-{1,2}b/
      duplicates[:d] << o if o =~ /\A-d|\A--r/
    end

    if duplicates[:d].count > 1
      raise Gish::Exceptions::DuplicateoptionsError.new(duplicates[:d])
    end

    if duplicates[:h].count == 1 && duplicates[:b].count == 1
      raise Gish::Exceptions::InvalidOptionsError.new(duplicates.values)
    elsif duplicates[:h].count > 1 && duplicates[:b].empty?
      raise Gish::Exceptions::DuplicateOptionsError.new(duplicates[:h])
    elsif duplicates[:b].count > 1 && duplicates[:h].empty?
      raise Gish::Exceptions::DuplicateOptionsError.new(duplicates[:b])
    elsif duplicates[:h].count > 1 && duplicates[:b].count > 1
      message = "gish: Invalid options with duplicates (#{duplicates.values.join(", ")})"
      raise Gish::Exceptions::DuplicateOptionsError.new(message: message)
    end

    arguments.reject! { |a| a.start_with? "-" }

    @options = @options.join(" ")
  end
end
