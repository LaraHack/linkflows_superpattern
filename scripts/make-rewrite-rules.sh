#!/bin/bash

set -e

USAGE="$ scripts/make-rewrite-rules.sh"

if [ ! -z $1 ]; then
  echo "Usage: $USAGE"; exit 1
fi

if [ ! -f sp.trig ]; then
  echo "File sp.trig does not exist"; exit 1
fi

(
  echo "Header set Access-Control-Allow-Origin *";
  echo "Options +FollowSymLinks";
  echo "RewriteEngine on";
  echo
) \
  > sp.htaccess

if [ -f sp.head.htaccess ]; then
  cat sp.head.htaccess >> sp.htaccess
fi

(
  echo "RewriteRule ^superpattern/terms/(.+)$ https://w3id.org/linkflows/superpattern/latest/\$1 [R=302,L]";
  echo "RewriteRule ^superpattern/np/.+/(RA[A-Za-z0-9_\\-]{43})$ http://purl.org/np/\$1 [R=302,L]";
  echo
) \
  >> sp.htaccess

cat sp.trig \
  | grep '^@prefix this:' \
  | sed -r 's/^@prefix this: <//' \
  | sed -r 's/> .$//' \
  | sed -r 's|^https://w3id.org/linkflows/([^/]+)/np/(.+)/([^/]+)$|RewriteRule ^\1/latest/\2$ http://purl.org/np/\3 [R=302,L]|' \
  >> sp.htaccess

if [ ! -f sp.index.trig ]; then
  exit
fi

echo >> sp.htaccess

cat sp.index.trig \
  | grep '^@prefix this:' \
  | tail -1 \
  | sed -r 's/^@prefix this: <//' \
  | sed -r 's/> .$//' \
  | sed -r 's|^https://w3id.org/linkflows/([^/]+)/np/(.+)/([^/]+)$|RewriteRule ^\1/latest/\2$ http://purl.org/np/\3 [R=302,L]|' \
  >> sp.htaccess
