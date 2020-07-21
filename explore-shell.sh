#!/usr/bin/env sh

# fast fail
set -Eeuo pipefail

# Usage
if [ $# != 3 ]; then
  echo "usage: $0 <ghc packages list within double quote> <haskell packages list within double quote> <system packages list within double quote>"
  exit 1
fi

# construct the haskellPackages list
MY_FINAL_HASKELL_PKGS_TEMP=""
for MY_HASKELL_PKG in $2
do
  MY_FINAL_HASKELL_PKGS_TEMP="${MY_FINAL_HASKELL_PKGS_TEMP} haskellPackages.${MY_HASKELL_PKG}"
done

# remove the leading space
MY_FINAL_HASKELL_PKGS=$(echo "${MY_FINAL_HASKELL_PKGS_TEMP}"|sed -n 's/^\ //p')

# now jump to the pure nix-shell with the needed dependencies
nix-shell --pure -p \
  "haskellPackages.ghcWithPackages (pkgs: with pkgs; [$1])" \
  "[${MY_FINAL_HASKELL_PKGS}]" \
  $3

