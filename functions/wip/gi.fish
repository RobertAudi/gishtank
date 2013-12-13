# TAGS: init
function gi --description="git init"
  emit __gishtank_command_called_event

  if test -n $GISHTANK_HOOKS_DIR
    not test -d $GISHTANK_HOOKS_DIR
    and /bin/mkdir -p $GISHTANK_HOOKS_DIR
  end
end
