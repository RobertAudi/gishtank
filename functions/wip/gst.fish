# TAGS: stash
function gst --description="git stash"
  emit __gishtank_command_called_event

  if test (count (git status --porcelain)) -eq 0
    set_color yellow
    echo "Nothing to stash..."
    set_color normal
    return
  end

  if test (count (git stash list)) -gt 0
    set_color yellow
    echo "you already have an item in the stash..."
    echo "Use git stash instead"
    set_color normal
    return
  end

  set -l raw_message
  if test (count $argv) -eq 0
    set raw_message (git stash | tail -1)
  else
    # TODO: Code the alternative scenario
    return
    # set -l files_to_reset (git)
    # git add .
    # grs $argv > /dev/null ^/dev/null
    # set -l files_not_to_stash (git status --porcelain | /usr/bin/grep ^[^ ] | sed 's/.[AMRD ] \(.*\)/\1/')
    # set raw_message (git stash --keep-index | tail -1)
    # grs $files_not_to_stash > /dev/null ^/dev/null
  end

  set -l sha (echo $message | tail -1 | sed 's/.*\( [0-9a-f]\{7\} \).*/\1/')
  set -l message (echo $raw_message | tail -1 | sed 's/\(.*\) [0-9a-f]\{7\} \(.*\)/\1 __XXX__ \2/' | awk 'BEGIN{FS=" __XXX__ "}{for (i=1; i<=NF; i++) print $i}')
  set_color green
  echo "Changes stashed"
  echo -n $message[1]
  set_color blue
  echo -n $sha
  set_color green
  echo $message[2]
  set_color normal
end
