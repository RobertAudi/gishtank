module Gish::Exceptions
  class FileNotFoundError < NameError
    def initialize(file: file, message: "")
      if message.empty?
        message = "gish: File not found (#{file.inspect})"
      end

      super message
    end
  end
end
