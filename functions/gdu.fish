# TAGS: diff, untracked
function gdu --description="git diff for untracked files"
  if test (count (git status --porcelain)) -eq 0
    set_color yellow
    echo "Nothing to diff..."
    set_color normal
    return
  end

  set -l untracked_files

  if test (count $argv) -eq 0
    set untracked_files (git ls-files --other --exclude-standard)
  else
    for file in $argv
      set -l matches (__git_fuzzy_add $file)
      if test (count $matches) -gt 0
        set untracked_files $untracked_files $matches
      else
        set_color red
        echo "No matches found for $file"
        set_color normal
      end
    end
  end

  git add $untracked_files > /dev/null
  git diff --cached --color=always -- $untracked_files | more -r
  git reset $untracked_files > /dev/null
end
