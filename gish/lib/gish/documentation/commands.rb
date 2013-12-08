class Gish::Documentation::Commands < Gish::Documentation::BasicHelp
  def usage
    output = ""
    output << basic_usage << " commands [<subcommand> [<args>]]\n\n"
    output << header("Subcommands:")

    Gish::Commands::Commands.subcommands.each do |method|
      begin
        desc = send(method, description_only: true)
      rescue NoMethodError, ArgumentError
        desc = ""
      end

      output << columnize(method, desc)
    end

    output << "\nSee 'gish help commands <subcommand>' for more information on a specific subcommand."

    puts output
  end

  def description
    "List or search gishtank commands"
  end

  def list(description_only: false)
    return "List all gishtank commands" if description_only
  end

  def search(description_only: false)
    return "Search for gishtank commands" if description_only

    output = basic_usage << " commands search <command> [<command> ...]"

    output << "\n\nSearch for a gishtank command"

    cmd = Gish::Commands::Commands.new
    cmd.subcommands << "search"
    cmd.arguments = ["add"]

    examples = [{ command: "commands search add", output: cmd.search(raw: true) }]
    output << "\n\n" + examplify(examples)

    puts output
  end
end
