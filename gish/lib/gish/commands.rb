require_relative "./commands/base/base"

Dir[File.dirname(__FILE__) + "/commands/*.rb"].each do |file|
  require file
end
