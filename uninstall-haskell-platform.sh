#!/bin/sh

#if [ ! -d /Library/Frameworks/HaskellPlatform.framework ]
#then
  #if which -s ghc
  #then
    #echo "A different Haskell was found." >&2
  #else
    #echo "Haskell Platform for OSX is not installed." >&2
  #fi
  #echo >&2
  #echo "Abort" >&2
  #exit 1
#fi

cat << BANNER >&2

This will COMPLETELY uninstall the Haskell Platform for OSX and

all associated files.

BANNER
read -p 'Are you sure? Type "yes" if so > ' answer >&2
test "$answer" = 'yes' || exit 1

sudo rm -rf /Library/Frameworks/GHC.framework
sudo rm -rf /Library/Frameworks/HaskellPlatform.framework
sudo rm -rf /Library/Haskell
sudo rm -rf /usr/share/doc/ghc
sudo rm /usr/share/man/man1/ghc.1
sudo rm -rf /var/db/receipts/org.haskell.HaskellPlatform.* # already deleted everything listed in every .bom
rm -rf ~/.cabal
rm -rf ~/.ghc
rm -rf ~/Library/Haskell
find /usr/bin /usr/local/bin -type l | \
  xargs -If sh -c '/bin/echo -n f /; readlink f' | \
    egrep '//Library/(Haskell|Frameworks/(GHC|HaskellPlatform).framework)' | \
    cut -f 1 -d ' ' | \
    xargs sudo rm -f

cat << FOOTER >&2

Haskell can be reinstalled at any time via

  http://hackage.haskell.org/platform/

or

  brew install haskell-platform

if using brew.

FOOTER
