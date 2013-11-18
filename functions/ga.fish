function ga --description="Fuzzy git add"
  if test (count (git status --porcelain)) -eq 0
    set_color yellow
    echo "Nothing to add ..."
    set_color normal
    return
  end

  if test (count $argv) -eq 0
    git add .
    git status
    return
  end

  if test $argv[1] = "."
    git add .
    git status
    return
  end

  for file in $argv
    set -l matches (__git_fuzzy_add $file)
    if test (count $matches) -gt 0
      git add $matches
    else
      set_color red
      echo "No matches found for $file"
      set_color normal
    end
  end

  git status
end
