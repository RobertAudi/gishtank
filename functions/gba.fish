# TAGS: branch
function gba --description="Show all git branches"
  emit __gishtank_command_called_event

  git branch -a
end
