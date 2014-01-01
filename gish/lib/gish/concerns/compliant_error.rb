module Gish
  module Concerns
    module CompliantError
      EXIT_CODE = 1

      def self.included(mod)
        mod.class_eval do
          include Gish::Helpers::InflectorHelper

          def code
            hierarchy = self.class.to_s.split("::")

            if @parent.nil?
              @parent = constantize(string: hierarchy.dup.shift(hierarchy.count - 1).join("::"))
            end

            mod_key = hierarchy.last.to_sym
            if @parent.const_defined?(:EXIT_CODES) && @parent::EXIT_CODES.is_a?(Hash) && !@parent::EXIT_CODES[mod_key].nil?
              @code ||= @parent::EXIT_CODES[mod_key]
            else
              @code ||= EXIT_CODE
            end
          end
        end
      end
    end
  end
end
