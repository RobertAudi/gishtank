require_relative "./extensions"

module Gish
  module Exceptions
    module Git
      EXIT_CODES = {
        TooManyChangesError: 42
      }
    end
  end
end

Dir[File.dirname(__FILE__) + "/git/*.rb"].each do |file|
  require file
end

Gish::Exceptions::Git.constants.each do |const|
  exception = Gish::Exceptions::Git.const_get(const)

  exception.send(:include, Gish::Concerns::CompliantError) if exception.is_a?(Class)
end
