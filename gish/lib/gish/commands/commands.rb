class Gish::Commands::Commands < Gish::Commands::BasicCommand
  define_method Gish::Commands::COMMAND_EXECUTION_METHOD do
    if subcommands.empty?
      list
    else
      send subcommands.shift
    end
  end

  def list(raw: false)
    unless defined?(@gishtank_commands)
      @gishtank_commands = {}
      Dir.foreach(Gish::FUNCTIONS_PATH) do |f|
        next if %w(. ..).include?(f) || File.directory?(File.join(Gish::FUNCTIONS_PATH, f))

        filename, tags, description = analyse_file f
        @gishtank_commands[filename.to_sym] = { tags: tags, description: description }
      end
    end

    return @gishtank_commands if raw

    output = header("List of gishtank commands:")
    output << prettify(@gishtank_commands)

    puts output
  end

  def search(raw: false)
    if arguments.empty?
      puts red(message: "gish: Search query required")
      self.status_code = 1
      return
    end

    if arguments.first =~ /\Agit\Z/
      arguments.shift

      if arguments.empty?
        puts yellow(message: "gish: All gishtank commands are git commands!\n\n")
        list
        self.status_code = 1
        return
      end
    end

    argument_list = arguments.dup
    matched_arguments = []
    matches = []
    commands = list(raw: true)
    command_names = commands.keys.map(&:to_s)
    tag_list = tags.dup
    results = []

    if tag_list[argument_list.first].nil?
      matching_tag_list = tag_list.select { |tag, cmd_list| tag =~ /#{argument_list.first}/ || argument_list.first =~ /#{tag}/ }

      if matching_tag_list.count > 0
        tag_list.each do |tag, cmd_list|
          m = tag.match(/#{argument_list.first}/)
          matches << m[0] unless m.nil?

          m = argument_list.first.match(/#{tag}/)
          matches << m[0] unless m.nil?
        end

        results = matching_tag_list.values.flatten.uniq
        tag_list.delete_if { |tag, cmd_list| matching_tag_list.has_key?(tag) }
      else
        command_names.each do |cmd|
          m = cmd.match(/#{argument_list.first}/)
          unless m.nil?
            results << cmd.to_sym
            matches << m[0]
          end
        end
      end
    else
      results << tag_list[argument_list.first]
      tag_list.delete(argument_list.first)
      results.flatten!
      matches << argument_list.first
    end

    if results.empty?
      puts red(message: "No results found for query: ") + yellow(message: argument_list.shift) + " " + black(message: argument_list.join(" "), bold: true)
      self.status_code = 1
      return
    else
      matched_arguments << argument_list.shift
    end

    commands_tags = {}
    results.each do |result|
      commands_tags[result] = []

      tags.each do |tag, cmd_list|
        commands_tags[result] << tag if cmd_list.include?(result)
      end
    end

    until argument_list.empty?
      results.keep_if do |result|
        keep = false

        m = result.to_s.match(/#{argument_list.first}/)
        unless m.nil?
          matches << m[0]
          keep = true
        end

        unless keep
          m = argument_list.first.match(/#{result}/)
          unless m.nil?
            matches << m[0]
            keep = true
          end
        end

        unless keep
          m = commands_tags[result].grep(/#{argument_list.first}/)
          unless m.empty?
            matches << m
            matches.flatten!
            keep = true
          end
        end

        unless keep
          m = commands_tags[result].select { |tag| argument_list.first =~ /#{tag}/ }
          unless m.empty?
            matches << m
            matches.flatten!
            keep = true
          end
        end

        keep
      end

      if results.empty?
        puts red(message: "No results found for query: ") + blue(message: matched_arguments.join(" ")) + " " + yellow(message: argument_list.shift) + " " + black(message: argument_list.join(" "), bold: true)
        self.status_code = 1
        return
      else
        matched_arguments << argument_list.shift
      end
    end

    output = "Results for query: "
    output << "#{blue(message: arguments.join(" "))}\n\n"

    output << header("List of commands:")

    commands = list(raw: true).select { |k, v| results.include? k }
    output << prettify(commands)

    return output if raw

    puts output
  end

  private

  def analyse_file(file)
    filename = file.gsub(/\.fish/, "")
    description = ""
    tags = []

    File.open(File.join(Gish::FUNCTIONS_PATH, file)).each_line do |line|
      if line =~ /\A# TAGS: /
        matches = line.match(/\A# TAGS: (?<tags>[a-z-]+(?:, [a-z-]+)*)\Z/)

        tags = matches["tags"].split(", ") unless matches.nil?
      elsif line =~ /function #{filename}/
        matches = line.match(/--description="(?<description>.*)"/)

        description = matches["description"] unless matches.nil?
        break
      end
    end

    return filename, tags, description
  end

  def prettify(gishtank_commands)
    pretty_list = ""

    gishtank_commands.each do |key, value|
      pretty_list << columnize(key, value[:description])
    end

    pretty_list
  end

  def tags
    return @tags if defined?(@tags)

    @tags = {}

    commands = list(raw: true)
    commands.each do |cmd, info|
      info.fetch(:tags).each do |tag|
        @tags[tag] ||= []
        @tags[tag] << cmd
      end
    end

    @tags
  end
end
