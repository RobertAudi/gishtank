function gcob --description="git checkout new branch"
  set -l argc (count $argv)
  if test $argc -eq 0
    set_color red
    echo "You need to supply a branch to checkout..."
    set_color normal
    return 1
  else
    if test $argc -gt 1
      set_color red
      echo "You cannot checkout more than one branch at a time..."
      set_color normal
      return 1
    else
      git show-ref --verify --quiet refs/heads/$argv[1]

      if test $status -eq 0
        set_color red
        echo "The $argv[1] branch already exist..."
        set_color normal
        return 1
      else
        git checkout -q -b $argv[1]
        set_color green
        echo "Switched to a new branch '$argv[1]'"
        set_color normal

        git status
      end
    end
  end
end
