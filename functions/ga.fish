# TAGS: add
function ga --description="Fuzzy git add"
  emit __gishtank_command_called_event

  if test (count (git status --porcelain)) -eq 0
    set_color yellow
    echo "Nothing to add ..."
    set_color normal
    return
  end

  if test (count $argv) -eq 0
    __git_add_or_remove "."
    git status
    return
  end

  if test $argv[1] = "."
    __git_add_or_remove "."
    git status
    return
  end

  for file in $argv
    __git_add_or_remove $file
  end

  git status
end

function __git_add_or_remove
  test (count $argv) -ne 1
  and return 1

  set -l matches (__git_fuzzy_find $argv[1])
  set -l number_of_matches (count $matches)

  if test $number_of_matches -gt 0
    set -l files_to_add
    set -l files_to_remove

    for match in $matches
      if test (count (echo $match | /usr/bin/grep "^\+")) -eq 1
        set files_to_add $files_to_add (echo $match | sed "s/^+//")
      else if test (count (echo $match | /usr/bin/grep "^-")) -eq 1
        set files_to_remove $files_to_remove (echo $match | sed "s/^-//")
      end
    end

    if test (count $files_to_add) -gt 0
      git add $files_to_add

      if contains "verbose" $GISHTANK_ADD_OPTIONS
        set_color green

        for file in $files_to_add
          echo "Added $file"
        end

        set_color normal
      end
    end

    if test (count $files_to_remove) -gt 0
      git rm $files_to_remove > /dev/null

      if contains "verbose" $GISHTANK_ADD_OPTIONS
        set_color red

        for file in $files_to_remove
          echo "Removed $file"
        end

        set_color normal
      end
    end
  else
    set_color red
    echo "No matches found for $argv[1]"
    set_color normal
  end

  return $number_of_matches
end
