# TAGS: add, untracked
function gau --description="Add all untracked files to git"
  emit __gishtank_command_called_event

  if test (count (git status --porcelain)) -eq 0
    set_color yellow
    echo "Nothing to add ..."
    set_color normal
    return
  end

  git add (git ls-files --other --exclude-standard | grep "$argv")
  gs
end
