#        _     _     _              _
#   __ _(_)___| |__ | |_ __ _ _ __ | | __
#  / _` | / __| '_ \| __/ _` | '_ \| |/ /
# | (_| | \__ \ | | | || (_| | | | |   <
#  \__, |_|___/_| |_|\__\__,_|_| |_|_|\_\
#  |___/
#

set -gx GISHTANK_DIR $HOME/.gishtank
set -gx GISHTANK_ERROR_FILE $GISHTANK_DIR/tmp/error.out
set -gx GISHTANK_GISH_DIR $GISHTANK_DIR/gish
set -gx GISHTANK_GISH_INCLUDE_DIR $GISHTANK_GISH_DIR/include
set -gx GISHTANK_GISH_GIT_ENV_CHAR "e"
set -gx GISHTANK_GISH_STATUS_MAX_CHANGES "150"
set -gx GISHTANK_TEMPLATES_DIR $GISHTANK_DIR/share/templates
set -gx GISHTANK_HOOKS_DIR $GISHTANK_DIR/share/hooks
set -gx GISHTANK_VALID_HOOKS (/bin/ls $GISHTANK_HOOKS_DIR)
set -gx GISHTANK_GIT_REPOS_HOOKED $GISHTANK_DIR/git_repos_hooked
set -gx GISHTANK_GIT_REPOS_NOT_HOOKED_AND_BLACKLISTED $GISHTANK_DIR/git_repos_not_hooked_and_blacklisted

for function_dir in (/bin/ls -d $GISHTANK_DIR/functions/*/)
  set fish_function_path $function_dir $fish_function_path
end

set fish_function_path $GISHTANK_DIR/functions $fish_function_path
set fish_user_paths $GISHTANK_DIR/bin $fish_user_paths
set fish_user_paths $GISHTANK_DIR/gish/bin $fish_user_paths

__gishtank_config
