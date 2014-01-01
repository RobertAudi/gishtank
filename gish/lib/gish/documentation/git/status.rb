class Gish::Documentation::Git::Status < Gish::Documentation::BasicHelp
  def usage
    output = ""
    output << basic_usage << " status\n\n"

    output << "(Alias: `gs`)"

    puts output
  end

  def description
    "git status on steroids"
  end
end
