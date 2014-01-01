module Gish
  module Concerns
    module Optionable
      def option?(item)
        item =~ /\A-{1,2}\w+(-\w+)*\Z/
      end
    end
  end
end
