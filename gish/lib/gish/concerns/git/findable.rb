module Gish
  module Exceptions
    module Git
      class InvalidFilterError < ArgumentError
        def initialize(filter: "")
          message = "Invalid filter"
          message << ": #{filter}" unless filter.empty?

          super message
        end
      end
    end
  end


  module Concerns
    module Git
      module Findable
        VALID_FILTERS = %i(none all cached untracked tracked)

        def fuzzy_find(query: nil, filter: :none, colorize: false)
          unless VALID_FILTERS.include?(filter)
            raise Gish::Exceptions::Git::InvalidFilterError.new filter: filter
          end

          return files if query.nil?

          files = case filter
          when :none
            `\git status --porcelain`
          when :all
            `\git ls-files`
          when :cached
            `\git diff --cached --name-only`
          when :tracked
            `\git status --untracked=no --porcelain`
          when :untracked
            `\git ls-files --other --exclude-standard`
          end

          files = files.split("\n")

          if query.include?("/")
            pattern = query.split("/").map { |p| p.split("").join(")[^\/]*?(").prepend("[^\/]*?(") + ")[^\/]*?" }.join("\/")
            pattern << "\/" if query[-1] == "/"
          else
            pattern = query.split("").join(").*?(").prepend(".*?(") + ").*?"
          end

          results = []

          files.each do |f|
            matches = f.match(/#{pattern}/).to_a

            results << f unless matches.empty?

            if colorize
              matches.shift

              if query.include?("/")
                matched_characters = pattern.split(")[^\/]*?(")
              else
                matched_characters = pattern.split(").*?(")
                matched_characters.first[0..3] = ""
                matched_characters.last[-4..-1] = ""
              end

              matched_characters.keep_if { |c| matches.include?(c) }
              new_pattern = ""
              colorized = []


              matched_characters.each do |m|
                new_pattern.gsub!(/[()]/, "")
                new_pattern = "(#{new_pattern})"

                if query.include?("/")
                  new_pattern << "(#{m})([^\/]*?)"
                else
                  new_pattern << "(#{m})(.*?)"
                end

                results[-1].sub! /#{new_pattern}/ do |s|
                  $1 + blue(message: $2) + $3
                end
              end
            end
          end

          results
        end
      end
    end
  end
end
