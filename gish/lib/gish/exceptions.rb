Dir[File.dirname(__FILE__) + "/exceptions/*.rb"].each do |file|
  require file
end

module Gish::Exceptions
end
