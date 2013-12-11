class Gish::Exceptions::Git::NotAGitRepositoryError < NameError
  def initialize(directory: "", message: "")
    if message.empty?
      message = "gish: Directory is not a git repository"

      unless directory.empty?
        message << " (#{directory})"
      end
    end

    super message
  end
end
