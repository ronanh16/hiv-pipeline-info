#!/bin/bash

export DIR2=$(pwd)
export TOOLSDIR="${DIR2}/tools"
export INPUTDIR="${DIR2}/inputs"
export OUTPUTDIR="${DIR2}/outputs"

for v in SELECT NUMBERS HERE; do
    var=$(printf "%02d" $v)
    BASENAME="${INPUTDIR}/barcode${var}"
    OUTPUTNAME="${OUTPUTDIR}/barcode${var}"

    echo "Processing ${BASENAME}"

     
    if [ -f "${BASENAME}.fastq" ]; then
        
        docker run -v "${DIR2}:${DIR2}" quay.io/biocontainers/nanofilt:2.8.0--py_0 sh -c "NanoFilt -l 400 --maxlength 9800 ${BASENAME}.fastq > ${OUTPUTNAME}.trim.fastq"
        docker run -v "${DIR2}:${DIR2}" quay.io/biocontainers/minimap2:2.9--1 sh -c "minimap2 -a -x map-ont -A 2 -O 24,24 -E 2,2 --secondary=no ${TOOLSDIR}/HXB2.790-9719.fas ${OUTPUTNAME}.trim.fastq > ${OUTPUTNAME}.trim.tmp.sam"

        ${TOOLSDIR}/sam2alignment.pl ${OUTPUTNAME}.trim.tmp.sam ${TOOLSDIR}/HXB2.790-9719.fas | ${TOOLSDIR}/HomoPoly-check.pl > ${OUTPUTNAME}.trim.align.tmp.fas
        ${TOOLSDIR}/make-consensus.ref.pl ${OUTPUTNAME}.trim.align.tmp.fas > ${OUTPUTNAME}.ref.fas
        
        docker run -v "${DIR2}:${DIR2}" quay.io/biocontainers/minimap2:2.9--1 sh -c "minimap2 -a -x map-ont -A 2 -O 24,24 -E 2,2 --secondary=no ${OUTPUTNAME}.ref.fas ${OUTPUTNAME}.trim.fastq > ${OUTPUTNAME}.trim.sam"
        ${TOOLSDIR}/sam2alignment.pl ${OUTPUTNAME}.trim.sam ${TOOLSDIR}/HXB2.790-9417.fas | ${TOOLSDIR}/HomoPoly-check.pl > ${OUTPUTNAME}.trim.align.fas
        ${TOOLSDIR}/extract-gene.aa.all.sh ${OUTPUTNAME}.trim.align.fas
        ${TOOLSDIR}/extract-gene.na.all.sh ${OUTPUTNAME}.trim.align.fas

        for i in ${OUTPUTNAME}.trim.align.*.?a.csv; do
            BASE2=$(basename $i .csv)
            DIR2=$(dirname $i)
            ${TOOLSDIR}/summary.pl $i > ${DIR2}/${BASE2}.summary.csv
        done

        ${TOOLSDIR}/genotype.fl.pl ${OUTPUTNAME}.trim.align.fas barcode${var} > ${OUTPUTNAME}.trim.align.genotype.fas

        for i in ${OUTPUTNAME}.trim.align.*-geno.??.csv ${OUTPUTNAME}.trim.align.??-??.??.csv ${OUTPUTNAME}.trim.align.tfp-??.??.csv; do
            BASE3=$(basename $i .csv)
            DIR3=$(dirname $i)
            ${TOOLSDIR}/summary2geno.pl $i barcode${var} > ${DIR3}/${BASE3}.summary.fas
        done

        for i in ${OUTPUTNAME}.trim.align.*-geno.??.summary.csv ${OUTPUTNAME}.trim.align.??-??.??.summary.csv ${OUTPUTNAME}.trim.align.tfp-??.??.summary.csv; do
            BASE4=$(basename $i .csv)
            DIR4=$(dirname $i)
            ${TOOLSDIR}/summary-geno2csv.pl $i > ${DIR4}/${BASE4}.geno.csv
        done

        for i in pr rt in prin; do
            ${TOOLSDIR}/make-consensus.pl ${OUTPUTNAME}.trim.align.${i}.na.summary.csv barcode${var} > ${OUTPUTNAME}.trim.align.${i}.na.cons.fas
        done
    fi
done

echo "Run finished"
