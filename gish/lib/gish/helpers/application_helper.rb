module Gish
  module Helpers
    module ApplicationHelper
      def header(content, character: "-")
        underline = character * content.length
        "#{content}\n#{underline}\n\n"
      end

      def columnize(left, right, formatting: {})
        formatting[:left_gap] ||= 20
        formatting[:left_alignment] ||= "left"
        formatting[:right_gap] ||= ""
        formatting[:right_alignment] ||= "right"
        formatting[:middle] ||= " "

        formatting[:left_modifier] = formatting[:left_alignment] == "left" ? "-" : ""
        formatting[:right_modifier] = formatting[:right_alignment] == "left" ? "-" : ""

        string  = "%#{formatting[:left_modifier]}#{formatting[:left_gap]}s"
        string << formatting[:middle]
        string << "%#{formatting[:right_modifier]}#{formatting[:right_gap]}s"

        sprintf("#{string}\n", left, right)
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
