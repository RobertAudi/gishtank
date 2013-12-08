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
    arguments.shift if arguments.first =~ /git/

    if arguments.empty?
      puts "gish: All gishtank commands are git commands!\n\n"
      list
      self.status_code = 1
      return
    end

    argument_list = arguments.dup
    commands = list(raw: true)
    command_names = commands.keys.map(&:to_s)
    tag_list = tags.dup
    results = []

    until argument_list.empty?
      if results.empty?
        if tag_list[argument_list.first].nil?
          command_names.map do |cmd|
            if cmd =~ /#{argument_list.first}/
              results << cmd.to_sym
            end
          end
        else
          results << tag_list[argument_list.first]
          tag_list.delete(argument_list.first)
          results.flatten!
        end

        argument_list.shift
      else
        tag_list.each do |tag, cmd_list|
          if argument_list.first == tag
            results.delete_if { |result| !cmd_list.include?(result) }
            argument_list.shift
          end
        end
      end
    end

    if results.empty?
      puts "No results found for query: #{arguments.join(" ")}"
      self.status_code = 1
      return
    end

    output = "Results for query: "
    output << "#{arguments.join(" ")}\n\n"

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
