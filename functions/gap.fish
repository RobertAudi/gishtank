# TAGS: add, patch, -p
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
    set -l matches (__git_fuzzy_find $file)
    if test (count $matches) -gt 0
      for match in $matches
        if test (count (echo $match | /usr/bin/grep "^\+")) -eq 1
          set files_to_patch $files_to_patch (echo $match | sed "s/^+//")
        end
      end
    else
      set_color red
      echo "No matches found for $file"
      set_color normal
    end
  end

  git add -p $files_to_patch
  git status
end
