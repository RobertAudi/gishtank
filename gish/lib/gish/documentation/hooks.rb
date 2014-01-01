class Gish::Documentation::Hooks < Gish::Documentation::BasicHelp
  def usage
    output = ""
    output << basic_usage << " hooks <subcommand> [<args> ...]\n\n"
    output << header("Subcommands:")

    Gish::Commands::Hooks.subcommands.each do |method|
      begin
        desc = send(method, description_only: true)
      rescue NoMethodError, ArgumentError
        desc = ""
      end

      output << columnize(method, desc)
    end

    output << "\nSee 'gish help hooks <subcommand>' for more information on a specific subcommand."

    puts output
  end

  def description
    "All about gishtank hooks"
  end

  def clean(description_only: false)
    return "Remove items from the list of hooked and blacklisted repos" if description_only

    output = basic_usage << " hooks clean [<option>] [<query> ...]"
    output << "\n\nRemove items from the list of hooked and blacklisted repos.\n"
    output << "By passing an option or a query, specific repos can be removed.\n\n"

    formatting = { left_gap: 30 }
    output << header("Options")
    output << columnize("-h, --hooked-only", "Apply to hooked repos only", formatting: formatting)
    output << columnize("-b, --blacklisted-only", "Apply to blacklisted repos only", formatting: formatting)
    output << columnize("-d, --remove-duplicates", "Remove duplicates from the lists", formatting: formatting)
    output << "\n"
    output << "NOTE: Only one filter option can be used at once!\n\n"

    examples = [
      { command: "hooks clean -h gishtank" },
      { command: "hooks clean -b dotfiles" },
      { command: "hooks clean -d" },
      { command: "hooks clean -h -d" },
      { command: "hooks clean -d foo" }
    ]
    output << examplify(examples)

    puts output
  end

  def repos(description_only: false)
    return "List hooked and blacklisted repos" if description_only

    output = basic_usage << " hooks repos [<subcommand>] [<option>] [<query> ...]"
    output << "\n\List or search repos in the hooked and blacklisted lists.\n"
    output << "By passing an option or a query, specific repos can be listed or searched.\n\n"

    formatting = { left_gap: 30 }
    output << header("Subcommands")
    output << columnize("list", "List repos (implied)", formatting: formatting)
    output << columnize("search", "Search for a repo", formatting: formatting)
    output << "\n"

    output << header("Options")
    output << columnize("-h, --hooked-only", "Apply to hooked repos only", formatting: formatting)
    output << columnize("-b, --blacklisted-only", "Apply to blacklisted repos only", formatting: formatting)
    output << "\n"
    output << "NOTE: Only one option can be used at once!\n\n"

    examples = [
      { command: "hooks repos" },
      { command: "hooks repos list" },
      { command: "hooks repos -h" },
      { command: "hooks repos list -b" },
      { command: "hooks repos search gishtank" },
      { command: "hooks repos search -b dotfiles" }
    ]
    output << examplify(examples)

    puts output
  end
end
