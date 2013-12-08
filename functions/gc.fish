# TAGS: commit
function gc --description="git commit"
  if test (count (git status --porcelain | /usr/bin/grep "^[ADMR]")) -eq 0
    set_color yellow
    echo "Nothing to commit..."
    set_color normal
    return
  end

  git commit $argv
  git status
end
