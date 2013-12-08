module Gish::Exceptions
  class SubcommandNotFoundError < CommandNotFoundError
    def initialize(command, subcommand, message: "")
      if message.empty?
        super command, message: "gish: Subcommand not found for command (#{command}, #{subcommand})"
      else
        super message
      end
    end
  end
end
