# TAGS: add, patch, -p
function gap --description="git add patch"
  emit __gishtank_command_called_event

  set -l files_to_patch (ruby $GISHTANK_GISH_INCLUDE_DIR/__gish_add_patch.rb (basename (status -f)) $argv)

  git add -p $files_to_patch

  gs
end
