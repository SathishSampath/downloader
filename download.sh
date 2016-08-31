#!/bin/bash
#
# Download all dependencies of a debian package (recursively)
# Courtesy:  Ddorda ( http://ddorda.net )
# Shell Script developed over the code

PKG_NAME=$1

# Usage
if [ $PKG_NAME == "" ]; then
	echo "Usage: $0 PACKAGE_NAME" 
	exit 1
fi

# Script dependencies
if ! hash apt-rdepends 2>/dev/null; then
	echo "Missing apt-rdepends. Installing..."
	sudo apt-get install apt-rdepends || ( echo "Failed installing apt-rdepends. abort." && exit )
fi

# Check package existance
if ! apt-cache show $PKG_NAME 2>&1 >/dev/null; then
	echo "No such package $PKG_NAME. abort."
	exit 1
fi

# Get dependencies list
DEPENDENCIES=$(apt-rdepends $PKG_NAME | grep -v "Depends" | sed "s/:any//" | sort | uniq)
if [ ! -d "$PKG_NAME" ]; then  
	# Download dependencies
	mkdir $PKG_NAME; cd $PKG_NAME
	for pkg in $DEPENDENCIES; do
		apt-get download $pkg
	done
fi

cd ..
echo "DONE! files are in $PWD/$PKG_NAME"
