Gish
====

Gish is a Ruby tool to document and manage several aspects of gishtank. It is a command line tool which comes with several commands and subcommands.

Commands
--------

### Getting help

Gish comes with a `help` command to ease the use of gish itself.

```sh
% gish help
```

Output:

```
Usage: gish <command>

Commands
--------

commands             List or search gishtank commands
help                 Show help for the gish commands
hooks                All about gishtank hooks

Git Wrappers
------------

status               git status on steroids

See 'gish help <command>' for more information on a specific command.
```

The different gish commands will be described here.

### Gishtank commands

The `commands` command comes with a couple of subcommands:

```
Usage: gish commands [<subcommand> [<args>]]

Subcommands:
------------

list                 List all gishtank commands
search               Search for gishtank commands

See 'gish help commands <subcommand>' for more information on a specific subcommand.
```

#### List gishtank's commands

The `list` subcommand does one thing: list the available gishtank commands, with a short description.

```sh
% gish commands list
```

Output:

```
List of gishtank commands:
--------------------------

ga                   Fuzzy git add
gap                  git add patch
gau                  Add all untracked files to git
gb                   git branch
gba                  Show all git branches
gbr                  Open the Github page for the current repo
gc                   git commit
...
```

The `list` subcommand is the default one, so calling the `commands` command without a subcommand will produce the same output:

```sh
% gish commands
```

### Search gishtank's commands

The `search` subcommand lets you search for commands. You can provide the name of a command, a tag that represents it and both or part of those.

```
Usage: gish commands search <command> [<command> ...]

Search for a gishtank command

Example:
	$ gish commands search add
	=> Results for query: add
	=>
	=> List of commands:
	=> -----------------
	=>
	=> ga                   Fuzzy git add
	=> gap                  git add patch
	=> gau                  Add all untracked files to git

```

Here are more examples:

#### Using (part of) the name of a gishtank command

```sh
% gish commands search gc
```

Output:

```
Results for query: gc

List of commands:
-----------------

gc                   git commit
gcl                  git clone
gcm                  git commit with message
gco                  git checkout
gcob                 git checkout new branch
gcv                  git commit verbose
```

#### Using (part of) a tag

```sh
% gish commands search commit
```

```
Results for query: commit

List of commands:
-----------------

gc                   git commit
gcm                  git commit with message
gcv                  git commit verbose
gdl                  git diff last commit
```

#### Combining (part of) a gishtank command and (part of) a tag

```sh
% gish commands search gc branch
```

Ouput:

```
Results for query: gc branch

List of commands:
-----------------

gcob                 git checkout new branch
```

### Gishtank hooks

Gishtank comes with git hooks (only one at the moment). When you install gishtank and you use a command for the first time in a repository, gishtank will ask you if you want to copy its hooks in the repository. If your answer is positive, the repository will be *hooked*, otherwise it will be *blacklisted*. When navigating to a hooked or blacklisted repository, gishtank will not ask again if you want to copy hooks. Gish comes with a `hooks` command that lets you manage the hooked and blacklisted repositories through subcommands.

```
Usage: gish hooks <subcommand> [<args> ...]

Subcommands:
------------

clean                Remove items from the list of hooked and blacklisted repos
repos                List hooked and blacklisted repos

See 'gish help hooks <subcommand>' for more information on a specific subcommand.
```

#### Hooked and blacklisted repositories

The `repos` command is very similar to the `commands` command. You can list and search for hooked and blacklisted repositories. You can also pass options to filter the output of the subcommands.

```
Usage: gish hooks repos [<subcommand>] [<option>] [<query> ...]
List or search repos in the hooked and blacklisted lists.
By passing an option or a query, specific repos can be listed or searched.

Subcommands
-----------

list                           List repos (implied)
search                         Search for a repo

Options
-------

-h, --hooked-only              Apply to hooked repos only
-b, --blacklisted-only         Apply to blacklisted repos only

NOTE: Only one option can be used at once!

Examples:
	$ gish hooks repos
	$ gish hooks repos list
	$ gish hooks repos -h
	$ gish hooks repos list -b
	$ gish hooks repos search gishtank
	$ gish hooks repos search -b dotfiles
```

#### List repositories

You can see the list of hooked and/or blacklisted repositories using the `list` subcommand:

```sh
% gish hooks repos list
```

Output:

```
Hooked repos
------------

/Users/aziz/.gishtank
/Users/aziz/.homesick/repos/dotfiles
/Users/aziz/tmp/foo

Blacklisted repos
-----------------

/Users/aziz/tmp/bar
/Users/aziz/tmp/qux
/Users/aziz/tmp/baz
```

The `-h` and `-b` options will list only the hooked repositories or only the blacklisted repositories (respectively).

#### Search repositories

You can search the list of hooked/blacklisted repositories using the `search` subcommand:

```
% gish hooks repos search tmp
```

Output:

```
Hooked repos
------------

/Users/aziz/tmp/foo

Blacklisted repos
-----------------

/Users/aziz/tmp/bar
/Users/aziz/tmp/qux
/Users/aziz/tmp/baz
```

You can also use the `-h` and `-b` options to narrow the scope of the search.
