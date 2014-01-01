require_relative "./helpers"

class Gish::Task
  include Gish::Helpers::ApplicationHelper
  include Gish::Helpers::RainbowHelper

  def initialize(arguments: [])
    arguments.map!(&:strip).reject!(&:empty?)

    if arguments.empty?
      self.command = "help"
    else
      self.command = arguments.shift
    end
  rescue Gish::Exceptions::CommandNotFoundError => e
    if ENV["GISHTANK_ENABLE_GISH_DEBUG_MODE"] == "true"
      raise e
    else
      puts red(message: e.message)
      command.status_code = 1
    end
  ensure
    2.times { arguments.shift if command.subcommands << arguments.first }
    command.arguments = arguments
    command.task = self
  end

  def run!
    command.status_code ||= 0
    unless command.status_code == 0
      cmd = command.dup

      self.command = "help"
      cmd.subcommands.each { |sc| command.subcommands << sc }
      command.arguments = cmd.arguments
      command.task = cmd.task
      command.status_code = cmd.status_code
    end

    command.send(Gish::Commands::COMMAND_EXECUTION_METHOD)
    exit command.status_code
  end

  def command=(cmd)
    raise Gish::Exceptions::CommandNotFoundError.new cmd if cmd =~ /\Abasiccommand\Z/i

    if Gish::Commands::LIST.include?(cmd)
      @command = Gish::Commands.const_get(cmd.capitalize).new
    elsif Gish::Commands::Git::LIST.include?(cmd)
      @command = Gish::Commands::Git.const_get(cmd.capitalize).new
    else
      raise Gish::Exceptions::CommandNotFoundError.new cmd
    end
  rescue Gish::Exceptions::Git::TooManyChangesError, Gish::Exceptions::Git::NotAGitRepositoryError => e
    puts red(message: e.message)
    exit e.code
  rescue NameError => e
    unknown_command = e.message.scan(/\Auninitialized constant (.*)\Z/).first.first
    raise Gish::Exceptions::CommandNotFoundError.new(unknown_command)
  end

  def command
    @command ||= Gish::Commands::Help.new
  end
end
