clib-init
=============

Interactively generate a `package.json' for your [clibs](https://github.com/clibs/clib)

## install

With [clib](https://github.com/clibs/clib):

```sh
$ clib install jwerle/clib-init
```

From source:

```sh
$ git clone git@github.com:jwerle/clib-init.git /tmp/clib-init
$ cd /tmp/clib-init
$ make install
```

## usage

Simply invoke `clib init` and you wil be prompted with a series
of questions about the generation of your `package.json`. Most options
have sane defaults.

This will walk you through initialzing the clib `package.json' file.
It will prompt you for the bare minimum that is needed and provide
defaults.

See github.com/clibs/clib for more information on defining the clib
`package.json' file.

You can press ^C anytime to quit this prompt. The `package.json' file
will only be written upon completion.

```sh
$ c lib init

This will walk you through initialzing the clib `package.json' file.
It will prompt you for the bare minimum that is needed and provide
defaults.

See github.com/clibs/clib for more information on defining the clib
`package.json' file.

You can press ^C anytime to quit this prompt. The `package.json' file
will only be written upon completion.

name: (clib-init)

...
```

## license

MIT

