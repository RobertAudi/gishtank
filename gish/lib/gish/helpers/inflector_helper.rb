module Gish
  module Helpers
    module InflectorHelper
      def constantize(string: "")
        string.split("::").inject(Module) { |acc, val| acc.const_get(val) }
      end
    end
  end
end


