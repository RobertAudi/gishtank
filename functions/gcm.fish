# TAGS: commit, message
function gcm --description="git commit with message"
  emit __gishtank_command_called_event

  if test (count (git status --porcelain | /usr/bin/grep "^[ADMR]")) -eq 0
    set_color yellow
    echo "Nothing to commit..."
    set_color normal
    return
  end

  if test (count $argv) -eq 0
    set_color red
    echo "You need to write a commit message"
    set_color normal
    return 1
  else
    git commit -m "$argv"
    gs
  end
end
