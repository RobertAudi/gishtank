function __gishtank_config_check_user_hooks_list
  if test (count $GISHTANK_HOOKS) -gt 0
    for hook in $GISHTANK_HOOKS
      test (count (echo $GISHTANK_VALID_HOOKS | /usr/bin/grep -E "^$hook\$")) -eq 0
      and emit __gishtank_invalid_hook_found_event
    end
  end
end
