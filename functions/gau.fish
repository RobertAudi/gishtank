# TAGS: add, untracked
function gau --description="Add all untracked files to git"
  emit __gishtank_command_called_event

  set -l arguments "--untracked" $argv
  ruby $GISHTANK_GISH_INCLUDE_DIR/__gish_add.rb $arguments

  gs
end
