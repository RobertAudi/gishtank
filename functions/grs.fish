function grs --description="git reset"
  if test (git diff --name-only --cached | wc -l | tr -d ' \t') -eq 0
    set_color yellow
    echo "Nothing to reset..."
    set_color normal
    return
  end

  if test (count $argv) -eq 0
    git reset > /dev/null ^/dev/null
  else
    set -l files_to_reset

    for file in $argv
      set -l matches (__git_fuzzy_add_cached $file)
      if test (count $matches) -gt 0
        set files_to_reset $files_to_reset $matches
      else
        set_color red
        echo "No matches found for $file"
        set_color normal
      end
    end

    echo -n $files_to_reset | xargs git reset > /dev/null ^/dev/null
  end

  git status
end
