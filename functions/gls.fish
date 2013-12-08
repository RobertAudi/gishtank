# TAGS: log, short
function gls --description="Short git log"
  emit __gishtank_command_called_event

  /bin/ls .git/logs > /dev/null ^/dev/null
  if test $status -ne 0
    set_color red
    echo "You didn't commit anything yet..."
    set_color normal
    return 1
  end

  git log -5 --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
end
