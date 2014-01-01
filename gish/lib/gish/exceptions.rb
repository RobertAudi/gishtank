require_relative "./exceptions/extensions"

Dir[File.dirname(__FILE__) + "/exceptions/*.rb"].each do |file|
  require file unless file =~ /extensions\.rb/
end

Gish::Exceptions.constants.each do |const|
  exception = Gish::Exceptions.const_get(const)

  exception.send(:include, Gish::Concerns::CompliantError) if const.is_a?(Class)
end
