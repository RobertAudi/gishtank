require_relative "./__gish_basic_alias_command"
require "pp"

module Gish::Commands::Git::Aliases
  class Patch < Gish::Commands::BasicCommand
    include Gish::Concerns::Git::Findable

    attr_accessor :command, :script

    def initialize
      super

      @command = self
    rescue Gish::Exceptions::Git::NotAGitRepositoryError => e
      $stderr.puts red(message: e.message)
      exit e.code
    end

    define_method Gish::Commands::COMMAND_EXECUTION_METHOD do
      if arguments.empty? || arguments.first == "."
        files = `\git status --untracked=no --porcelain`.split("\n")
      else
        colorize = (script !~ /\.fish/)

        files = []
        arguments.each do |arg|
          files << fuzzy_find(query: arg, filter: :tracked, colorize: colorize)
        end

        files.flatten!
      end

      files.keep_if { |f| f[1] == "M" }
      files.map! { |f| f[3..-1] }

      if files.empty?
        puts yellow message: "No mathces found"
        self.status_code = 1
      else
        unless script =~ /\.fish/
          message = "You cannot use this wrapper directly\n"
          message << "because `git add -p` is an interactive command"

          puts red message: message

          puts "However, according to your query, here is the list of files to patch:\n\n"
        end

        # TODO: colorize the output if the script was called directly
        puts files
      end
    end
  end
end

cmd = Gish::Commands::Git::Aliases::Patch.new
cmd.script = ARGV.first =~ /\.fish/ ? ARGV.shift : nil
cmd.arguments = ARGV
cmd.send(Gish::Commands::COMMAND_EXECUTION_METHOD)
