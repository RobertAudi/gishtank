module Gish::Exceptions
  class NoSubcommandForCommandError < NotImplementedError
    def initialize(command, message: "")
      full_message = ""

      if message.empty?
        full_message << "gish: No subcommands available for this command (#{command})"
      else
        full_message << "#{message} (#{command})"
      end

      super full_message
    rescue
      if message.empty?
        super "gish: No subcommands available for this command"
      else
        super message
      end
    end
  end
end
