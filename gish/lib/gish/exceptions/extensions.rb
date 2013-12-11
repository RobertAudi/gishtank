require_relative "../helpers/inflector_helper"

module Gish
  module Exceptions
    module Extensions
      extend Gish::Helpers::InflectorHelper
    end
  end
end

Dir[File.dirname(__FILE__) + "/extensions/*.rb"].each do |file|
  require file
end
