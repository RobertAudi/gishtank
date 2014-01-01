require_relative "./__gish_basic_alias_command"

module Gish::Commands::Git::Aliases
  class Status < Gish::Commands::Git::Aliases::BasicCommand
    def initialize(arguments: [])
      super arguments: arguments
    rescue Gish::Exceptions::Git::TooManyChangesError => e
      $stderr.puts red(message: e.message)
      exit e.code
    end
  end
end

Gish::Commands::Git::Aliases::Status.new(arguments: ARGV).send(Gish::Commands::COMMAND_EXECUTION_METHOD)
