module Gish::Exceptions
  class MissingPromptAnswersError < ArgumentError
    def initialize(message: "")
      if message.empty?
        message = "gish: Missing prompt answers"
      end

      super message
    end
  end
end
