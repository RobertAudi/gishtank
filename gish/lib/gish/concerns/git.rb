Dir[File.dirname(__FILE__) + "/git/*.rb"].each do |file|
  require file
end
