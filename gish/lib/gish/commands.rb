module Gish::Commands
  LIST = Dir[File.join(File.dirname(__FILE__), "commands") + "/*.rb"].map { |c| File.split(c).last.gsub(/\.rb\Z/, "") }
  COMMAND_EXECUTION_METHOD = :execute!

  class BasicCommand
    attr_accessor :arguments, :task, :status_code

    def self.subcommands
      @subcommands ||= self.public_instance_methods(false).delete_if { |sc| sc === COMMAND_EXECUTION_METHOD }
    end

    def subcommands
      @subcommands ||= Gish::SubcommandsArray.new self
    end
  end
end

Dir[File.dirname(__FILE__) + "/commands/*.rb"].each do |file|
  require file
end

