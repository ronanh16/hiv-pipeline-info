#!/bin/sh

FILE=$1
DIR=$(dirname "${FILE}")
BASE=$(basename "${FILE}" .fas)
echo "$FILE"

for l in pr rt
do
  echo $l
 ${TOOLSDIR}/extract-gene.aa.pl -O -r ${l} -i ${FILE} -o ${DIR}/${BASE}.${l}.aa.csv
done

for l in tfp-pr pr-rt rt-rt rt-in
do
  echo $l
 ${TOOLSDIR}/extract-gene.aa.pl -O -r ${l} -i ${FILE} -o ${DIR}/${BASE}.${l}.aa.csv
done
for l in prrt
do
  echo $l
 ${TOOLSDIR}/extract-gene.aa.pl -O -g -r ${l} -i ${FILE} -o ${DIR}/${BASE}.${l}-geno.aa.csv
done
for l in in 
do
  echo $l
 ${TOOLSDIR}/extract-gene.aa.pl -O -g -m 12 -r ${l} -i ${FILE} -o ${DIR}/${BASE}.${l}-geno.aa.csv
done
