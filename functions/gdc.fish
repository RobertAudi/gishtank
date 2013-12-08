# TAGS: diff, staging, cached
function gdc --description="git diff the staging area"
  if test (git diff --name-only --cached | wc -l | tr -d ' \t') -eq 0
    set_color yellow
    echo "Nothing to diff..."
    set_color normal
    return
  end

  if test (count $argv) -eq 0
    git diff --cached --color=always | more -r
  else
    set -l files_to_diff

    for file in $argv
      set -l matches (__git_fuzzy_find --cached $file)
      if test (count $matches) -gt 0
        set files_to_diff $files_to_diff $matches
      else
        set_color red
        echo "No matches found for $file"
        set_color normal
      end
    end

    git diff --cached --color=always -- $files_to_diff | more -r
  end
end
