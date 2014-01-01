module Gish::Exceptions
  class InvalidOptionsError < ArgumentError
    def initialize(options: [], message: "")
      raise ArgumentError if !options.empty? && !message.empty?

      if message.empty?
        message = "gish: Invalid options"
        unless options.empty?
          message << " (#{options.join(", ")})"
        end
      end

      super message
    end
  end
end
