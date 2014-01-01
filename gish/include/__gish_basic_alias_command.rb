require_relative "../lib/gish/concerns"
require_relative "../lib/gish/exceptions"
require_relative "../lib/gish/additions"
require_relative "../lib/gish/commands/base/base"
require_relative "../lib/gish/commands/git"

module Gish::Commands::Git
  module Aliases
    class BasicCommand < Gish::Commands::BasicCommand
      def initialize(arguments: [])
        cmd = self.class.to_s.split("::").last
        @command = Gish::Commands::Git.const_get(cmd).new
        @command.arguments = arguments
      rescue Gish::Exceptions::Git::NotAGitRepositoryError => e
        $stderr.puts red(message: e.message)
        exit e.code
      end

      define_method Gish::Commands::COMMAND_EXECUTION_METHOD do
        @command.send(Gish::Commands::COMMAND_EXECUTION_METHOD)
      end
    end
  end
end
