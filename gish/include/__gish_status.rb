require_relative "../lib/gish/exceptions/git"
require_relative "../lib/gish/commands/base/base"
require_relative "../lib/gish/commands/git"

module Gish::Commands::Git
  module Aliases
    class Status < Gish::Commands::BasicCommand
      def initialize(arguments: [])
        @command = Gish::Commands::Git::Status.new
        @command.arguments = arguments
      rescue Gish::Exceptions::Git::NotAGitRepositoryError => e
        $stderr.puts red(message: e.message)
        exit e.code
      rescue Gish::Exceptions::Git::TooManyChangesError => e
        $stderr.puts red(message: e.message)
        exit e.code
      end

      define_method Gish::Commands::COMMAND_EXECUTION_METHOD do
        @command.send(Gish::Commands::COMMAND_EXECUTION_METHOD)
      end
    end
  end
end

Gish::Commands::Git::Aliases::Status.new(arguments: ARGV).send(Gish::Commands::COMMAND_EXECUTION_METHOD)
