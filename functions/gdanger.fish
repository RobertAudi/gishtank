function gdanger --description="git reset --hard"
  set -l revision

  if test (count $argv) -ne 1
    set revision "HEAD"
  else
    set revision $argv[1]
  end

  git reset --hard $revision
  gls
end
