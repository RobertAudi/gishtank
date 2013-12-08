# TAGS: clone
function gcl --description="git clone"
  emit __gishtank_command_called_event

  if test (count $argv) -eq 0
    if test (pbpaste | xargs __git_repo_url_check) = "true"
      pbpaste | xargs git clone
    else
      set_color red
      echo "Invalid git repository URL in clipboard..."
      set_color normal
      return 1
    end
  else
    git clone $argv

    if test $status -ne 0
      set_color red
      echo "Unable to find the repository $argv[1]..."
      set_color normal
      return 1
    end
  end
end
