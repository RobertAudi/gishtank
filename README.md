Gishtank
========

<dl>
  <dt>Gish</dt>
  <dd>A warrior/mage hybrid, generally using magical powers to enhance his or her abilities in melee. From the Githyanki word " 'gish", meaning 'skilled'.</dd>
</dl>

*(Reference: [Urban Dictionary](http://gish.urbanup.com/6946625))*

Installation
------------

First, clone the repository in your home directory:

~~~
% cd
% git clone https://github.com/AzizLight/gishtank $HOME/.gishtank
~~~

And add the `bin` directory in the `PATH` and the functions directory to the `fish_function_path` in `$HOME/.config/fish/config.fish`:

~~~
set fish_user_paths $HOME/.gishtank/bin $fish_user_paths
set fish_function_path $HOME/.gishtank/functions $fish_function_path
~~~
