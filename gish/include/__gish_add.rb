require_relative "./__gish_basic_alias_command"

module Gish::Commands::Git::Aliases
  class Add < Gish::Commands::Git::Aliases::BasicCommand
  end
end

Gish::Commands::Git::Aliases::Add.new(arguments: ARGV).send(Gish::Commands::COMMAND_EXECUTION_METHOD)
