function __gishtank_config_hooks
  not test -f $GISHTANK_GIT_REPOS_HOOKED
  and /usr/bin/touch $GISHTANK_GIT_REPOS_HOOKED

  not test -f $GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED
  and /usr/bin/touch $GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED

  set -l __gishtank_repo_root (git rev-parse --show-toplevel ^/dev/null)
  or set -l __gishtank_not_a_repo 1

  test "$__gishtank_not_a_repo" -eq 1
  and return

  if test (count $GISHTANK_HOOKS) -gt 0
    for hook in $GISHTANK_HOOKS
      if test -f "$__gishtank_repo_root/.git/hooks/$hook"
        if not contains $__gishtank_repo_root (/bin/cat $GISHTANK_GIT_REPOS_HOOKED)
          if not contains $__gishtank_repo_root (/bin/cat $GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED)
            set_color yellow
            echo "A $hook hook already exists in this git repo"
            set_color normal

            read -l response -p "echo \"Do you want to replace this hook with the gishtank hook? [Yy] \""

            if test (count (echo $response | /usr/bin/grep -E "^[yY]")) -eq 0
              echo $__gishtank_repo_root >> $GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED

              set_color red
              echo "Repo blacklisted: $__gishtank_repo_root"
              echo
              set_color normal
              return 1
            end
          else
            return
          end
        else
          return
        end
      end

      /bin/cp "$GISHTANK_HOOKS_DIR/$hook" "$__gishtank_repo_root/.git/hooks/$hook"

      if test $status -eq 0
        echo $__gishtank_repo_root >> $GISHTANK_GIT_REPOS_HOOKED

        set_color yellow
        echo "Hook added to repo: $hook"
        echo
        set_color normal
      end
    end
  end
end
