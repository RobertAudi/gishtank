module Gish::Exceptions
  class UnknownCallbackTypeError < NotImplementedError
    def initialize(callback)
      super "gish: Unknown callback (#{callback})"
    end
  end
end
