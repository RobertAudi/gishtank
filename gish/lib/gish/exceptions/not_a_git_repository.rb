module Gish::Exceptions
  class NotAGitRepositoryError < NameError
    def initialize(directory: directory, message: "")
      if message.empty?
        message = "gish: Directory is not a git repository (#{directory.inspect})"
      end

      super message
    end
  end
end
