# TAGS: rm, remove
function grm --description="git rm"
  emit __gishtank_command_called_event

  if test (count $argv) -eq 0
    set_color red
    echo "You need to list the directories to remove"
    set_color normal
    return
  end

  for file in $argv
    set -l pattern "[^/]*\$"
    set -l matches (git ls-files | /usr/bin/grep "$file$pattern")
    if test (count $matches) -gt 0
      echo -n $matches | xargs git rm > /dev/null ^/dev/null
    else
      set_color red
      echo "No matches found for $file"
      set_color normal
    end
  end

  git status
end
