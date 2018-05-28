This is an attempt to make a new type of config for Emacs that will
actually be portable between a lot of machines.

I really like the go-lang/crystal-lang idea of just using git repos to
carry modules and then pulling in those.

So this config has tools to allow me to do that.

I also want just one file to initialize my emacs, though the obvious
way to handle emacs startup is with an after-init hook, so I write an
after-init file from the init file and I have tools to make that
possible.


## How I use this

If you can use cloning:

1. git clone this repository to a directory somewhere, say /sandbox/nics-emacs-config
2. run `bash getstate.sh` to clone all the packages
3. make `~/.emacs.d/init.el` simply: `(load-file "/sandbox/nics-emacs-confg/init.el")`

If you can't use cloning but can download, then:

1. download this repository to a directory somewhere, say /sandbox/nics-emacs-config
2. run `DOWNLOAD=download bash getstate.sh` to download all the packages
3. make `~/.emacs.d/init.el` simply: `(load-file "/sandbox/nics-emacs-confg/init.el")`


## How does getstate.sh know what packages to download?

The package state is kept in the file `.packages`.

The script `savestate.sh` updates the package state file and then you
can commit it and push.

Yes, I know it's not very portable.


## What about depends and stuff?

I don't bother with any of that yet. Clearly I could use ELPA
declarations to track package depends and automatically download them.

I'd rather just download the repository for the package though.


## Why use source code repositories for packages?

When you pull source code from repositories you can also assess who
changed what. In today's world, where security is more and more a
concern, this is good. I can trust some people when they
commit... when I see people I don't trust committing I can review.

That process of trust and review should all be part of a tool for
managing package state IMO.


## My involvement with Emacs

I have long periods where I do contribute to Emacs. Sadly, I am too
busy with other things which I consider more important right now.

I am sure the Emacs community is moving on in my absence and inventing
new ways to do this stuff... but this is mine and it works ok.
