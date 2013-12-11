require_relative "./gish/helpers.rb"
require "pp" # DEBUG

module Gish
  FUNCTIONS_PATH = File.join(ENV["GISHTANK_DIR"], "functions")
  CMD_METHOD_SUFFIX = "_command"
  DOC_METHOD_SUFFIX = "_doc"

  COMPONENTS = %w(exceptions additions documentation commands task)
end

Gish::COMPONENTS.each do |component|
  require_relative "./gish/#{component}"
end

%w(documentation commands).each do |component|
  component_const = Gish.const_get(component.capitalize)

  Gish::Helpers.constants.each do |const|
    helper = Gish::Helpers.const_get(const)
    component_const.constants.each do |c|
      comp = component_const.const_get(c)
      comp.send(:include, helper) if comp.is_a?(Class)
    end
  end
end
