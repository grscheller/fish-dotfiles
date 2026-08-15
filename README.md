# grscheller/fish-dotfiles

Repository to maintain and install all my Fish configuration files.
Fish is my primary shell for Linux and the MSYS2 environment on
Windows 11. This is my actual working setup, take what may be useful
to you, or use as a starting point for your own version.

## Installation scripts

A POSIX shell script, [fishInstall](bin/fishInstall), installs the
"dotfiles" from the cloned repo into my Linux or MSYS2 $HOME directory.
Once your Fish environment has been bootstrapped, this script can be
launched from anywhere with the `fI` fish abbr and honors the
[XDG directory specification](https://specifications.freedesktop.org/basedir/latest/).

- fishInstall has shebang `#!/bin/dash`
  - on PopOS `/usr/bin/sh -> dash`
  - on MSYS2 I install dash with `pacman -S dash`
  - will work just fine if shebang is changed to `#!/bin/sh`
- does more than just install, see `bashInstall --help` 

### Note

MSYS2 integration is still a work in progress.

## Public Domain Declaration

To the extent possible under law,
[Geoffrey R. Scheller](https://github.com/grscheller)
has waived all copyright and related or neighboring rights
to [grscheller/dotfiles](https://github.com/grscheller/dotfiles).
This work is published from the United States of America.

See [LICENSE](LICENSE) for details.
