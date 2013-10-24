---
layout: post
title:  "Mavericks and GHC"
date:   2013-10-23 23:45:42
author: katychuang
categories: tutorial installation osx
---

Were you trigger happy with the installation of OSX Mavericks? Here are quick steps to bring your haskell back. Tips referenced from [cartazio](http://www.reddit.com/r/haskell/comments/1ozukp/anyone_running_ghc_763_on_osx_mavericks/ccy9wnv?context=3):

1) Make sure you have [xcode 5 cli tools for OSX Mavericks](https://developer.apple.com/downloads/index.action) installed. Go to that link, download and install.

2) Get the proper gcc version. Open up your terminal and type `brew install apple-gcc42` and then followed by `brew link apple-gcc42`. Test things out with a fresh new terminal window and type `which gcc-4.2`.   Note that you may have to update `brew update`.
(you may have to uninstall or brew update, or brew link apple-gcc42)

{% highlight sh %}
$ brew install apple-gcc42
==> Downloading http://r.research.att.com/tools/gcc-42-5666.3-darwin11.pkg
Already downloaded: /Library/Caches/Homebrew/apple-gcc42-4.2.1-5666.3.pkg
==> Caveats
NOTE:
This formula provides components that were removed from XCode in the 4.2
release. There is no reason to install this formula if you are using a
version of XCode prior to 4.2.

This formula contains compilers built from Apple's GCC sources, build
5666.3, available from:

 http://opensource.apple.com/tarballs/gcc

All compilers have a `-4.2` suffix. A GFortran compiler is also included.
==> Summary
 /usr/local/Cellar/apple-gcc42/4.2.1-5666.3: 104 files, 75M, built in 7 seconds

$  brew link apple-gcc42
Linking /usr/local/Cellar/apple-gcc42/4.2.1-5666.3... 21 symlinks created

$ which gcc-4.2
/usr/local/bin/gcc-4.2
{% endhighlight %}

3) Install haskell platform with updated $PATH. If you don't know how to do this, it's best to ask someone to help you with this step, because it can vary depending on your operating system.


4) Point ghc compiler to gcc42. There are a few steps to do this, read carefully as doing the wrong thing can mess up your whole installation. Find out where gcc42 is with `which gcc-4.2` and then point to that in your ghc settings file.

{% highlight sh %}
# Location of your settings file
$ ghc-pkg list
/path/to/ghc/...conf

# Edit line 2 of settings
$ vim /path/to/ghc/settings
{% endhighlight %}

The change will look like

{% highlight vim %}
 ("C compiler command", "/usr/local/bin/gcc-4.2"),
{% endhighlight %}

5) :beers:

6) Make sure you have a fresh cabal for these commands

{% highlight sh %}
$ cabal install cabal-install
$ cabal -- version
cabal-install version 1.18.0.2
using version 1.18.1 of the Cabal library
{% endhighlight %}

7)  Proceed with installing dependencies for this project.

{% highlight sh %}
$ cd gloss-starter
$ cabal install
$ cabal build
$ dist/build/gloss-starter/gloss-starter
{% endhighlight %}

===

**Tip: **

`rm -rf ~/.ghc` if you want to remove installed packages.
