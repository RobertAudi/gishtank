class Gish::Documentation::Help < Gish::Documentation::BasicHelp
  def usage
    really_show = @show
    flush

    output = ""
    output << basic_usage << " <command>\n\n" if really_show
    output << header("Commands:")

    Gish::Commands::LIST.each do |c|
      if c === "help"
        next unless really_show
        desc = description
      else
        begin
          desc = Gish::Documentation.const_get(c.capitalize).new.description
        rescue
          desc = ""
        end
      end

      output << columnize(c, desc)
    end

    if really_show
      output << "\nSee 'gish help <command>' for more information on a specific command."

      puts output
    else
      return output
    end
  end

  def description
    "Show help for the gish commands"
  end

  def help
    flush
    output = basic_usage << " help [<command> [<subcommand> ...]]\n\n"
    output << usage
    puts output
  end
end
