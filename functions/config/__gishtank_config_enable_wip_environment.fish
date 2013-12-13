function __gishtank_config_enable_wip_environment
  set fish_function_path $GISHTANK_DIR/functions/wip $fish_function_path

  set_color green
  echo "WIP env enabled!"
  set_color normal
end
