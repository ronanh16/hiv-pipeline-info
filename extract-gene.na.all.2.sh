#!/bin/sh

FILE=$1
DIR=$(dirname ${FILE})
BASE=$(basename ${FILE} .fas)
echo $FILE

for l in pr rt
do
  echo $l
  ${TOOLSDIR}/extract-gene.na.pl -O -r ${l} -i ${FILE} -o ${DIR}/${BASE}.${l}.na.csv
done
for l in in prin
do
  echo $l
  ${TOOLSDIR}/extract-gene.na.pl -O -m 12 -r ${l} -i ${FILE} -o ${DIR}/${BASE}.${l}.na.csv
done

for l in tfp-pr pr-rt rt-rt rt-in
do
  echo $l
  ${TOOLSDIR}/extract-gene.na.pl -O -r ${l} -i ${FILE} -o ${DIR}/${BASE}.${l}.na.csv
done
for l in prrt
do
  echo $l
  ${TOOLSDIR}/extract-gene.na.pl -O -g -r ${l} -i ${FILE} -o ${DIR}/${BASE}.${l}-geno.na.csv
done
for l in in 
do
  echo $l
  ${TOOLSDIR}/extract-gene.na.pl -O -g -m 12 -r ${l} -i ${FILE} -o ${DIR}/${BASE}.${l}-geno.na.csv
done
