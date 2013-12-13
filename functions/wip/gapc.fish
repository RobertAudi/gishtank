# TAGS: add, patch, -p, commit
function gapc --description="git add patch and commit straight away"
  emit __gishtank_command_called_event

  # gap $argv; and git config commit.status false; git commit --verbose
  gap $argv; git commit --template="$GISHTANK_DIR/share/git_commit_template" --verbose
end
