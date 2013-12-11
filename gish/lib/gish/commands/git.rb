module Gish::Commands::Git
  LIST = Dir[File.join(File.dirname(__FILE__), "git") + "/*.rb"].map { |c| File.split(c).last.gsub(/\.rb\Z/, "") }
end

Dir[File.dirname(__FILE__) + "/git/*.rb"].each do |file|
  require file
end
