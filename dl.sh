#!/bin/bash

# install gsutil
# https://cloud.google.com/sdk/docs/downloads-interactive


datadir=$(jq -r .datadir config.json)

echo $datadir
echo $(ls $datadir)

p=$(pwd)
mkdir -p ${datadir}/dl
cd ${datadir}/dl

gsutil ls gs://finngen-public-data-r2/summary_stats/ > dllist.txt 

while IFS= read -r line
do
nom=$(basename $line)
echo $nom
gsutil cp $line $nom
done < dllist.txt

cp r2_manifest.tsv $p

