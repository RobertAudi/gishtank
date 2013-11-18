function gau --description="Add all untracked files to git"
  if test (count (git status --porcelain)) -eq 0
    set_color yellow
    echo "Nothing to add ..."
    set_color normal
    return
  end

  git add (git ls-files --other --exclude-standard | grep "$argv")
  git status
end
