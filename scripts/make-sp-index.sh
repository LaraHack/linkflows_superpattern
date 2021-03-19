#!/bin/bash

set -e

USAGE="$ scripts/make-sp-index.sh"

if [ ! -z $1 ]; then
  echo "Usage: $USAGE"; exit 1
fi

LASTRELEASE=$(scripts/get-last-release-nr.sh sp)

if [ -z $LASTRELEASE ]; then
  echo "No previous release found"
  LASTINDEXARG=""
else
  LASTINDEX=$(
    cat releases/sp.index.$LASTRELEASE.trig \
    | egrep '^@prefix this:' \
    | tail -1 \
    | sed -r 's/.*<(.*)>.*/\1/'
  )
  echo "Supersedes index: $LASTINDEX"
  LASTINDEXARG="-x $LASTINDEX"
fi

echo "Making index..."
scripts/np mkindex \
  -u https://w3id.org/linkflows/superpattern/np/index/ \
  -c https://orcid.org/0000-0002-7114-6459 \
  -c https://orcid.org/0000-0002-1267-0234 \
  -t "Nanopublications representing the Superpattern Ontology" \
  -l https://creativecommons.org/publicdomain/zero/1.0/ \
  $LASTINDEXARG \
  -o sp.index.trig \
  sp.trig
