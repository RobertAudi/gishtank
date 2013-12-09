module Gish::Exceptions
  class InvalidColorError < ArgumentError
    def initialize(color: "", message: "")
      raise ArgumentError if !color.empty? && !message.empty?

      if message.empty?
        message = "gish: Invalid color"
        unless color.empty?
          message << " (#{color})"
        end
      end

      super message
    end
  end
end
