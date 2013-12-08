class Gish::Commands::Help < Gish::Commands::BasicCommand
  def initialize
    @help = Gish::Documentation::Help.new
  end

  define_method Gish::Commands::COMMAND_EXECUTION_METHOD do
    if subcommands.empty?
      @help.show.usage
    else
      send subcommands.shift
    end
  end

  def help
    if subcommands.empty?
      @help.show.help
    else
      task.command = subcommands.shift
      2.times { arguments.shift if task.command.subcommands << arguments.first }
      task.command.arguments = arguments
      task.send :run!
    end
  end

  private

  def help_for(command)
    @help = Gish::Documentation.const_get(command.to_s.capitalize).new
    if subcommands.empty?
      @help.show.usage
    else
      @help.send subcommands.shift
    end
  rescue StandardError => e
    if ENV["GISHTANK_ENABLE_GISH_DEBUG_MODE"] == "true"
      raise e
    else
      puts "gish: No help available for this command (#{command})"
      @help.show.usage
      self.status_code = 1
    end
  end

  def method_missing(method_name, *arguments, &block)
    if Gish::Commands::LIST.include? method_name.to_s
      send(:help_for, method_name)
    else
      raise Gish::Exceptions::CommandNotFoundError.new method_name
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    Gish::Commands::LIST.include? method_name.to_s || super
  end
end
