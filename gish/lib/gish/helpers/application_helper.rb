module Gish
  module Helpers
    module ApplicationHelper
      def header(content, character: "-")
        underline = character * content.length
        "#{content}\n#{underline}\n\n"
      end

      def columnize(cmd, desc, gap: 20)
        sprintf("%-#{gap}s %s\n", cmd, desc)
      end

      def tab(string, count: 1)
        output = ""
        if count.is_a?(Float)
          raise ArgumentError.new "Invalid tab count" unless count == 0.5

          indentation = "  "
        elsif !count.is_a?(Fixnum)
          raise ArgumentError.new "Invalid tab count"
        else
          indentation = "\t" * count
        end

        string.each_line do |line|
          output << "#{indentation}#{line}"
        end

        output
      end

      def examplify(examples)
        output = "Example"
        output << "s" if examples.count > 1
        output << ":\n"

        examples.each do |example|
          output << tab("$ gish #{example[:command]}") + "\n"

          unless example[:output].nil?
            tabified = tab(example[:output])

            tabified.each_line do |line|
              output << line.gsub(/\A([ \t]*)/, '\1=> ')
            end

            output << "\n"
          end
        end

        output.rstrip
      end
    end
  end
end
