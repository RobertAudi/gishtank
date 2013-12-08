# TAGS: checkout
function gco --description="git checkout"
  emit __gishtank_command_called_event

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
        if test (count (git branch | /usr/bin/grep "*\s$argv[1]")) -eq 1
          set_color yellow
          echo "Already on '$argv[1]'"
          set_color normal
        else
          git checkout -q $argv[1]
          set_color green
          echo "Switched to branch '$argv[1]'"
          set_color normal
        end

        git status
      else
        set_color red
        echo "The $argv[1] branch doesn't exist..."
        set_color normal
        return 1
      end
    end
  end
end
