class Gish::Documentation::Git::Add < Gish::Documentation::BasicHelp
  def usage
    output = ""
    output << basic_usage << " add [<query> ...]\n\n"

    output << "(Alias: `ga`)"

    output << "\n\nAdd files to the git staging area, optionally passing a query.\n"
    output << "The query can be part of a word or a path.\n"
    output << "Deleted files will also be removed from the git repo and added\n"
    output << "to the staging area.\n\n"

    output << header("Options")
    output << columnize("-u, --untracked", "Only add untracked files\n")

    output << header("Examples")
    output << "File structure for the examples:\n"
    output << tab("pwd: /Users/aziz/tmp\n")
    output << tab(".\n")
    output << tab("|-foo/\n")
    output << tab("   |---1.foo\n")
    output << tab("   |---2.foo\n")
    output << tab("   |---3.foo\n")
    output << tab("|-bar.rb\n")
    output << tab("|-baz.rb\n")
    output << tab("|-foo.rb\n")
    output << tab("|-qux.rb\n")

    examples = [
      { command: columnize("add", "# add all files") },
      { command: columnize("add -u", "# add all untracked files") },
      { command: "add foo" },
      { command: "add rb" },
      { command: "add 1 2" },
      { command: "add b" },
    ]

    output << examplify(examples)

    puts output
  end

  def description
    "Better git add"
  end
end
