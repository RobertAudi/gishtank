# TAGS: add, commit
function gac --description="git add and commit straight away"
  emit __gishtank_command_called_event

  ga $argv;
  # and git config commit.status false
  git commit --template="$GISHTANK_DIR/share/git_commit_template" --verbose
  # and git config commit.status true
end
