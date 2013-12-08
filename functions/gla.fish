# TAGS: log, remote, branch
function gla --description="git log accross all branches and remotes"
  /bin/ls .git/logs > /dev/null ^/dev/null
  if test $status -ne 0
    set_color red
    echo "You didn't commit anything yet..."
    set_color normal
    return 1
  end

  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches --remotes
end
