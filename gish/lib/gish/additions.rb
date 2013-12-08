Dir[File.dirname(__FILE__) + "/additions/*.rb"].each do |file|
  require file
end
