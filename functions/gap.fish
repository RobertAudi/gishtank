function gap --description="git add patch"
  if test (count (git status --porcelain)) -eq 0
    set_color yellow
    echo "Nothing to add ..."
    set_color normal
    return
  end

  if test (count $argv) -eq 0
    git add -p .
    git status
    return
  end

  if test $argv[1] = "."
    git add -p .
    git status
    return
  end

  set -l files_to_patch

  for file in $argv
    set -l matches (__git_fuzzy_add $file)
    if test (count $matches) -gt 0
      set files_to_patch $files_to_patch $matches
    else
      set_color red
      echo "No matches found for $file"
      set_color normal
    end
  end

  git add -p $files_to_patch
  git status
end
