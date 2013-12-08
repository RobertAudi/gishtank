module Gish::Documentation
  class BasicHelp
    def show
      raise Gish::Exceptions::NestedMethodCallError.new if @show
      @show = true
      self
    end

    protected

    def basic_usage
      "Usage: gish"
    end

    def flush
      @show = false if @show
    end

    def self.method_added(method)
      @@added_methods ||= {}
      @@added_methods[self.to_s] ||= []

      unless @@added_methods[self.to_s].include? method
        @@added_methods[self.to_s] << method

        original_method = instance_method(method)
        remove_method method
        define_method method do |*args|
          return_value = original_method.bind(self).call(*args)
          flush
          return_value
        end
      end
    end
  end
end

Dir[File.dirname(__FILE__) + "/documentation/*.rb"].each do |file|
  require file
end
