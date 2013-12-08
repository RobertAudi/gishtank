module Gish::Exceptions
  class CommandNotFoundError < NotImplementedError
    # FIXME: Make the command optional if the message is present
    def initialize(command, message: "")
      if message.empty?
        super "gish: Command not found (#{command})"
      else
        super message
      end
    end
  end
end
