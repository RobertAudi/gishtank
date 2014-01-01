module Gish::Exceptions
  class DuplicateOptionsError < ArgumentError
    def initialize(options: [], message: "")
      raise ArgumentError if !options.empty? && !message.empty?

      if message.empty?
        message = "gish: Duplicate options"
        unless options.empty?
          message << " (#{options.join(", ")})"
        end
      end

      super message
    end
  end
end
