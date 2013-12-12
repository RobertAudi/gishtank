Gishtank
========

<dl>
  <dt>Gish</dt>
  <dd>A warrior/mage hybrid, generally using magical powers to enhance his or her abilities in melee. From the Githyanki word " 'gish", meaning 'skilled'.</dd>
</dl>

*(Reference: [Urban Dictionary](http://gish.urbanup.com/6946625))*

Requirements
------------

Gishtank uses ruby for the `git status` wrapper and for the `gish` tool. Other than that, there are no requirements other than `git` and `fish`.

- Fish
- Git
- Ruby 2.0+ - **Ruby 1.8 and 1.9 not supported!**

Also, I only tested gishtank on OS X, but there shouldn't be any problems on other Unix-based systems.

Installation
------------

First, clone the repository in your home directory (or anywhere else):

```
% git clone https://github.com/AzizLight/gishtank $HOME/.gishtank
```

In your Fish config file (`$HOME/.config/fish/config.fish`), source the gishtank init script:

```
. $HOME/.gishtank/gtinit.fish
```

You're done!

Configuration
-------------

There are a couple of environment variable that you can set to customize gishtank.


### `GISHTANK_ADD_OPTIONS`

This environment variable lets you customize a bit the functionality of the `add` commands. At the moment, there is only one option available: `verbose`. It lets you increase the verbosity of the `add` commands. With this options, everytime a file is added to the staging area (this includes the removal of files as well), a message will appear to notify you.

```
set -gx GISHTANK_ADD_OPTIONS "verbose"
```

### `GISHTANK_HOOKS`

Gishtank comes with hooks. Right now, there is only one hook (`prepare-commit-msg`), but more will come (hopefully). You can specify which hooks to use in your projects by adding its name to this environment variable. The hook(s) will then be copied to your git repo when you navigate to it. That will only happen if you do not already have a hook of the same name in your git repo. If you do, gishtank will ask you if you want to replace it, and it will memorize your choice (so it will only ask once per repo).

```
set -gx GISHTANK_HOOKS "prepare-commit-msg"
```

### `GISHTANK_GISH_STATUS_MAX_CHANGES`

The improved status script from `scm_breeze` was ported to gishtank. This environment variable represents the maximum number of changes that gishtank will display. If there are too many files in the `git status` output, gishtank will fallback to the native `git status` command, for performance reasons. If you experience lagging, try to lower the value of this variable. The default is `150`.

```
set -gx GISHTANK_GISH_STATUS_MAX_CHANGES "150"
```

Gish
----

Gish is a Ruby tool. As of today, it has the following features:

- List and search gishtank's commands
- Manage the git repos that have been "hooked" by gishtank

More information on gish can be found in its [README](https://github.com/AzizLight/gishtank/tree/master/gish/README.md).

Credits
-------

- Nathan Broadbent - Creator of [`scm_breeze`](https://github.com/ndbroadbent/scm_breeze)

`scm_breeze` is the reason why I started this project. It is my main source of inspiration.

Contributing
------------

1. Fork it.
2. Create a branch (`git checkout -b awesome-feature`)
3. Commit your changes (`git commit -am "Add AWESOME feature"`)
4. Push to the branch (`git push origin awesome-feature`)
5. Open a [Pull Request](https://github.com/AzizLight/gishtank/pulls)

### Guidelines

- The first line of a commit message should be:
    * Short
    * In the present tense
- The first line of a commit message **MUST NOT** end with a punctuation mark (i.e.: `.` or `!`)
- If the commit has a lot of changes (which should NOT happen by the way), add a description after the commit message containing a list of the changes (among other things).

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
