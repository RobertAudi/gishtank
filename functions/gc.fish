# TAGS: commit
function gc --description="git commit"
  emit __gishtank_command_called_event

  if test (count (git status --porcelain | /usr/bin/grep "^[ADMR]")) -eq 0
    set_color yellow
    echo "Nothing to commit..."
    set_color normal
    return
  end

  git commit $argv
  gs
end
