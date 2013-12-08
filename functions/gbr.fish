# TAGS: github, browse, open
function gbr --description="Open the Github page for the current repo"
  emit __gishtank_command_called_event

  git browse
end
