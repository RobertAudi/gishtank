function gd --description="git diff"
  if test (count (git status --porcelain)) -eq 0
    set_color yellow
    echo "Nothing to diff..."
    set_color normal
    return
  end

  if test (count $argv) -eq 0
    __git_diff_default
    return
  end

  if test $argv[1] = "."
    __git_diff_default
    return
  end

  set -l files

  for file in $argv
    set -l matches (__git_fuzzy_add $file)
    if test (count $matches) -gt 0
      set files $files $matches
    else
      set_color red
      echo "No matches found for $file"
      set_color normal
    end
  end

  if test (count $files) -gt 0
    git add $files > /dev/null
    git diff --cached --color=always -- $files | more -r
    git reset $files > /dev/null
  else
    echo " "
    git status
  end
end

function __git_diff_default
  set untracked_files (git ls-files --other --exclude-standard)
  if test (count $untracked_files) -gt 0
    git add $untracked_files > /dev/null
  end

  set -l modified_files (git ls-files -m)
  if test (count $modified_files) -gt 0
    git add $modified_files > /dev/null
  end

  set -l files $modified_files $untracked_files
  if test (count $files) -gt 0
    git diff --cached --color=always -- $files
    git reset $files > /dev/null
  end


  return
end
