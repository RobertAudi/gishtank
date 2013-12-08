module Gish::Exceptions
  class InvalidPromptAnswerError < ArgumentError
    def initialize(message: "gish: Each prompt answer must be associated with a lambda")
      super message
    end
  end
end
