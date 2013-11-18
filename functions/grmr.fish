function grmr --description="git rm"
  if test (count $argv) -eq 0
    set_color red
    echo "You need to list the directories to remove"
    set_color normal
    return
  end

  for directory in $argv
    set -l matches (git ls-tree -d -r --name-only HEAD | /usr/bin/grep "$directory")
    if test (count $matches) -gt 0
      echo -n $matches | xargs git rm -r > /dev/null ^/dev/null
    else
      set_color red
      echo "No matches found for $directory"
      set_color normal
    end
  end

  git status
end
