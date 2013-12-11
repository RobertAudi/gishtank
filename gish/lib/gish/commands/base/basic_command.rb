module Gish
  module Commands
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
end

Dir[File.join(File.dirname(__FILE__), "..", "..", "helpers") + "/*.rb"].map { |file| file.split("/").last.gsub(/_helper\.rb/, "") }.each do |helper|
  begin
    Gish.const_get("Helpers::#{helper.capitalize}Helper")
  rescue NameError
    require_relative "../../helpers/#{helper}_helper"

    Gish::Commands::BasicCommand.send(:include, Gish.const_get("Helpers::#{helper.capitalize}Helper"))
  end
end
