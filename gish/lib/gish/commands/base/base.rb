module Gish
  module Commands
    LIST = Dir[File.join(File.dirname(__FILE__), "..") + "/*.rb"].select { |f| f !~ /git\.rb/ }.map { |c| File.split(c).last.gsub(/\.rb\Z/, "") }
    COMMAND_EXECUTION_METHOD = :execute!
  end
end

require_relative "./basic_command.rb"
