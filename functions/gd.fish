# TAGS: diff
function gd --description="git diff"
  emit __gishtank_command_called_event

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
    set -l matches (__git_fuzzy_find $file)
    if test (count $matches) -gt 0
      for match in $matches
        test (count (echo $match | /usr/bin/grep "^[+-]")) -eq 1
        and set files $files (echo $match | sed "s/^[+-]//")
      end
    else
      set_color red
      echo "No matches found for $file"
      set_color normal
    end
  end

  if test (count $files) -gt 0
    git add $files > /dev/null
    git diff --cached -- $files
    git reset $files > /dev/null
  else
    echo " "
    git status
  end
end

function __git_diff_default
  set -l modified_files (git ls-files -m)
  if test (count $modified_files) -gt 0
    git diff
  else
    set untracked_files (git ls-files --other --exclude-standard)
    if test (count $untracked_files) -gt 0
      git add $untracked_files > /dev/null
      git diff --cached -- $untracked_files
      git reset $untracked_files > /dev/null
    end
  end
end
