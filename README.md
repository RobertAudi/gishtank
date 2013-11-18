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

License
-------

The MIT License (MIT)

Copyright (c) 2013 Aziz Light

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
