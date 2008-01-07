#!/bin/sh

DIR=`echo $0|sed 's/\/getfiles.sh//'`

cd $DIR/db
echo Fetching 02packages ...
wget -q -O 02packages http://cpan.org/modules/02packages.details.txt.gz &&
mv 02packages 02packages.details.txt.gz

echo Fetching CPAN-testers database ...
wget -q -O cpanstatsdatabase http://perl.grango.org/cpanstats.db.gz &&
mv cpanstatsdatabase cpanstats.db.gz &&
gzip -fd cpanstats.db.gz && (
  ../optimisedb.pl;
  cp cpantestresults cpantestresults.previous;
  mv cpanstats.db cpantestresults
)

rm cpanstats.db.gz >/dev/null 2>/dev/null

cd $DIR
echo select \* from cpanstats where os = \'Unknown OS\'\;|./dbish 2>/dev/null
