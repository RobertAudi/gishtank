module Gish
  module Commands
    class BasicCommand
      attr_accessor :task, :fallback_command, :status_code
      attr_reader :arguments, :options, :valid_options

      def arguments=(value)
        @arguments = value

        @options = Gish::OptionsArray.new(self)
        @options.parse!
      rescue Gish::Exceptions::InvalidOptionsError => e
        puts red message: e.message
        self.status_code = 1
      end

      def self.has_subcommands?
        true
      end

      def self.subcommands
        @subcommands ||= self.public_instance_methods(false).delete_if { |sc| sc === COMMAND_EXECUTION_METHOD }
      end

      def subcommands
        @subcommands ||= Gish::SubcommandsArray.new self
      end

      def document
        components = self.class.to_s.split("::")
        components[1] = "Documentation"

        klass = constantize string: components.join("::")

        @documentation ||= klass.new
      rescue NameError => e
        raise Gish::Exceptions::NoHelpAvailableError.new components.last.downcase
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
