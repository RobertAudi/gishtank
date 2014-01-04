# TAGS: add
function ga --description="Fuzzy git add"
  emit __gishtank_command_called_event

  ruby $GISHTANK_GISH_INCLUDE_DIR/__gish_add.rb $argv

  gs
end
