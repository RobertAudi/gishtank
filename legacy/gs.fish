# TAGS: status
function gs --description="git status"
  emit __gishtank_command_called_event

  /bin/rm -f $GISHTANK_ERROR_FILE > /dev/null ^/dev/null

  ruby $GISHTANK_GISH_INCLUDE_DIR/__gish_status.rb $argv ^ $GISHTANK_ERROR_FILE

  set -l gishtank_status_code $status

  if test -f $GISHTANK_ERROR_FILE
    /bin/cat $GISHTANK_ERROR_FILE

    if test $gishtank_status_code -eq 42
      echo ""

      set_color yellow
      echo "Falling back to the native git status command"
      set_color normal

      git status
    end

    /bin/rm -f $GISHTANK_ERROR_FILE > /dev/null ^/dev/null
  end
end
