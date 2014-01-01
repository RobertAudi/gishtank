module Gish::Commands::Git
  LIST = Dir[File.join(File.dirname(__FILE__), "git") + "/*.rb"].map { |c| File.split(c).last.gsub(/\.rb\Z/, "") }

  class BasicCommand < Gish::Commands::BasicCommand
    def initialize
      @project_root = File.directory?(File.join(Dir.getwd, ".git")) ? Dir.getwd : `\git rev-parse --show-toplevel 2> /dev/null`.strip

      raise Gish::Exceptions::Git::NotAGitRepositoryError.new directory: Dir.getwd if @project_root.empty?
    end

    def self.has_subcommands?
      false
    end
  end
end

Dir[File.dirname(__FILE__) + "/git/*.rb"].each do |file|
  require file
end
