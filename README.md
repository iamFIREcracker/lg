# lg

Grab links from stdin, and print them to stdout.

# Background
Not much to say about this, given that similar and sometimes even more powerful
tools already exist (see: [urlview](https://linux.die.net/man/1/urlview),
[urlview](https://linux.die.net/man/1/urlview), or Suckless'
[linkgrabber.sh](https://st.suckless.org/patches/externalpipe/linkgrabber.sh)).

So why? Not a specific reason, really, except that I simply wanted to have some
fun with Common Lisp.

_enters `lg`.._

# Install

You got 2 options:

- Compile binary from sources
- Download a pre-compiled binary

## Compile

- Get yourself a [SBCL](http://www.sbcl.org/) -- apologies, it's the only Common
  Lips implementation that I tested this with, but hopefully none of those 30
  locs I managed to put together will be incompatible with other Common Lisp
  implementations
- Get yourself a [Quicklisp](https://www.quicklisp.org/beta/)
- Clone this repo
- Run `make` followed by `make install`

## Download

Each new tag ships with pre-compiled binaries for:

- Linux (tested on: Ubuntu 18.04 x64)
- macOS (tested on: Sierra)
- Windwos (tested on: Cygwin, MINGW, and LWM)

You can manually download which one you need, or you can run the following:

    ./download

It will guess your OS, download the pre-compiled binary, place it inside
'bin/', and make it executable.

Finally run `make install` to install the executable globally.

# Usage

    $ lg -h
    Grab links from stdin, and print them to stdout.

    Available options:
      -h, --help               print the help text and exit
      -v, --version            print the version and exit

Using `lg` is really simple: you just pipe some text into it, and it will
output all the _links_ it was able to extract from it:

    $ tail -n 200 ~/plan/.plan
    ...
    Then someone else suggested to use [unintenred symbols](http://www.lispworks.com/documentation/HyperSpec/Body/02_dhe.htm) instead, as that will not only keep you safe from the previously mentioned problem, but also give you the opportunity to _document_ why the specific form / element got intentionally excluded:
    ...
    * While releasing `cg`, the created GH release is named `refs/tags/...` -- turns out I was setting the `name` input to `github.ref`: https://github.com/iamFIREcracker/cg/commit/c0c3ef5b17be40872c67709f445dcbc66c1936c2
    ? migrate `ap` to GitHub actions -- see `cg`
    + migrate `adventofcode` to GitHub actions -- see `cg`
    + migrate `lg` to GitHub actions -- see `cg`
    ? migrate `plan-convert` to GitHub actions -- see `cg`
    ? migrate `xml-emitter` to GitHub actions -- see `cg`

    $ tail -n 200 ~/plan/.plan | lg
    http://www.lispworks.com/documentation/HyperSpec/Body/02_dhe.htm
    https://github.com/iamFIREcracker/cg/commit/c0c3ef5b17be40872c67709f445dcbc66c1936c2

## Execute one of the guessed commands

So far we saw `lg` grabbing links from its stdin; but what about selecting one
of those, and send it to the default browser?  Well, I did not bother
implementing a Terminal UI for this; instead, I opted to ship `lg` with an
adapter for fzf: [lg-fzf](./fzf/lg-fzf).

Hopefully, it should not take you long to implement adapters for other
programs, but `fzf` is what I am using these days, so that's what I will try to
support going forward.

# Extras

## Tmux

If you use `tmux`, you might want to add the following to your ".tmux.conf":

    tmux bind-key "u" capture-pane -J \\\; \
      save-buffer "${TMPDIR:-/tmp}/tmux-buffer" \\\; \
      delete-buffer \\\; \
      send-keys -t . " sh -c 'cat \"${TMPDIR:-/tmp}/tmux-buffer\" | lg-fzf'" Enter

Or even better, the following in case you had
[tmux-externalpipe](https://github.com/iamFIREcracker/tmux-externalpipe)
installed:

    set -g @externalpipe-lg-cmd      'lg-fzf'
    set -g @externalpipe-lg-key      'u'

Either one will configure `tmux` so that, when `PrefixKey + u` is pressed,
`lg-fzf` is started and the content of the current pane is piped into it.
