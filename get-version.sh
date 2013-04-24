#!/bin/sh
# Gets the version of the library and its uses-annotations

if test $# -ne 6; then
  exit 1
fi
OMC="$1"
BUILD="$2"
FILE="$3"
LIB="$4"
ENCODING="$5"
STD="$6"
MOS="get-version.$$.mos"
VER="get-version.$$.ver"
rm -f $MOS $VER
cat > $MOS <<EOF
loadFile("$FILE",encoding="$ENCODING");getErrorString();
version:=getVersion($LIB);getErrorString();
writeFile("$VER",version);getErrorString();
uses:=getUses($LIB);getErrorString();
str:=sum(uses[i,1] + " " + uses[i,2] + "\n" for i in 1:size(uses,1));
writeFile("$BUILD/$LIB" + (if version <> "" then (" " + version) else "") + ".uses",str);getErrorString();
EOF
"$OMC" "+std=$STD" $MOS > /dev/null 2>&1
VERSION=`test -f "$VER" && cat "$VER"`
rm -f $MOS $VER
if test -z "$VERSION"; then
  exit 1
fi
echo $VERSION
