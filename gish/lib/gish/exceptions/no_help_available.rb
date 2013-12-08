module Gish::Exceptions
  class NoHelpAvailableError < NotImplementedError
    def initialize(command, message: "")
      full_message = ""

      if message.empty?
        full_message << "gish: No help found for #{command}"
      else
        full_message "#{message} (#{command})"
      end

      super full_message
    rescue
      if message.empty?
        super "gish: No help found"
      else
        super message
      end
    end
  end
end
