class Gish::Commands::Git::Add < Gish::Commands::Git::BasicCommand
  include Gish::Concerns::Git::Findable

  def initialize
    super

    @valid_options = {
      root: [
        %w(-u --untracked)
      ],
    }
  end

  define_method Gish::Commands::COMMAND_EXECUTION_METHOD do
    status = `\git status --porcelain`

    if status.empty? || status.split("\n").grep(/\A.[^ ]/).empty?
      puts yellow message: "Nothing to add..."
      return
    end

    untracked_only = !options.grep(/\A-{1,2}u/).empty?

    if arguments.empty? || arguments.first == "."
      if untracked_only
        files_to_add = `\git ls-files --other --exclude-standard`.split("\n")
        files_to_remove = []
      else
        files_to_add, files_to_remove = categorize files: status.split("\n")
      end
    else
      files = []

      filter = untracked_only ? :untracked : :none

      arguments.each do |arg|
        files << fuzzy_find(query: arg, filter: filter)
      end

      files.flatten!

      return if files.empty?

      if untracked_only
        files_to_add = files
        files_to_remove = []
      else
        files_to_add, files_to_remove = categorize files: files
      end
    end

    `\git add #{files_to_add.join(" ")} > /dev/null 2> /dev/null` unless files_to_add.empty?
    `\git rm #{files_to_remove.join(" ")} > /dev/null 2> /dev/null` unless files_to_remove.empty?

    env_opts = ENV["GISHTANK_ADD_OPTIONS"].split(":")

    if env_opts.include?("verbose")
      formatting = {
        left_alignment: "right",
        right_alignment: "right",
        middle: "  "
      }

      files_to_add.each do |f|
        left = green message: "Added"

        puts columnize(left, f, formatting: formatting)
      end

      files_to_remove.each do |f|
        left = red message: "Removed"

        puts columnize(left, f, formatting: formatting)
      end
    end
  end

  private

  def categorize(files: [])
    files_to_add = []
    files_to_remove = []

    files.delete_if { |f| f =~ /\A. / }

    files.each do |f|
      if f[0..2] =~ /D/
        files_to_remove << f
      else
        files_to_add << f
      end
    end

    files_to_add.each { |f| f[0..2] = "" }
    files_to_remove.each { |f| f[0..2] = "" }

    return files_to_add, files_to_remove
  end
end
