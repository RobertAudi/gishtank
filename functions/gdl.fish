function gdl --description="git diff last commit"
  # TODO: Add the option to diff a particular file in the last commit
  git diff HEAD^..HEAD
end
