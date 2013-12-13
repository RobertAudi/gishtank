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

#### Search gishtank's commands

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

##### Using (part of) the name of a gishtank command

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

##### Using (part of) a tag

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

##### Combining (part of) a gishtank command and (part of) a tag

```sh
% gish commands search gc branch
```

Output:

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

##### List repositories

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

##### Search repositories

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

#### Clean the lists

You can clean the list of hooked and blacklisted repositories using the `clean` subcommand.

```
Usage: gish hooks clean [<option>] [<query> ...]

Remove items from the list of hooked and blacklisted repos.
By passing an option or a query, specific repos can be removed.

Options
-------

-h, --hooked-only              Apply to hooked repos only
-b, --blacklisted-only         Apply to blacklisted repos only
-d, --remove-duplicates        Remove duplicates from the lists

NOTE: Only one filter option can be used at once!

Examples:
	$ gish hooks clean -h gishtank
	$ gish hooks clean -b dotfiles
	$ gish hooks clean -d
	$ gish hooks clean -h -d
	$ gish hooks clean -d foo
```

This subcommand is all about options. If you don't pass any options, the list of hooked and blacklisted repositories will be deleted.

The `-h` and `-b` options will force the changes to take place on hookes or blacklisted repositories only (respectively). ***Note:** only ONE of those two options can be used at once!*

The `-d` option (which can be used in conjunction with one of the filtering options) will only remove duplicates from the lists. When a repository appears in both hooked and blacklisted lists, a prompt will show up, and you will have the choice between five options:

- `h` or `H`: Keep the repository in the hooked list, remove all its occurences from the blacklisted list, and remove all duplicates from both lists.
- `b` or `B`: Keep the repository in the blacklisted list, remove all its occurences from the hooked list, and remove all duplicates from both lists.
- `s` or `S`: Skip the cleaning. In other words, no action will be taken.
- `n` or `N`: Remove **ALL** occurences of the repository in both lists.
- `?`: Show the list of options.

No matter what option(s) you passed, one or more keywords can be passed to the `clean` subcommand. Those keywords will filter out any repository that does not match them. ***Note:** keywords are independent of each other!*

Git wrappers
------------

Gishtank is mainly about git aliases and wrapper functions. Some wrappers (only one at the moment) are written in Ruby, and so are part of gish. You can use those wrappers through gish or directly using their alias.

### Status

This wrapper is coming from `scm_breeze`. I rewrote the ruby script into a class to integrate it to gish, but the code is (almost) the same, and the output is **exactly** the same. So **THANKS A LOT** to the creator of `scm_breeze`!
