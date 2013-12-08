# TAGS: add, patch, -p
function gap --description="git add patch"
  emit __gishtank_command_called_event

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

  if test (count $files_to_patch) -gt 0
    git add -p $files_to_patch

    if contains "verbose" $GISHTANK_ADD_OPTIONS
      set_color green

      for file in $files_to_patch
        echo "Added $file"
      end

      set_color normal
    end
  end

  git status
end
