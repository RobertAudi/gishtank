module Gish::Exceptions
  class DirectoryNotFoundError < NameError
    def initialize(directory: directory, message: "")
      if message.empty?
        message = "gish: Directory not found (#{directory.inspect})"
      end

      super message
    end
  end
end
