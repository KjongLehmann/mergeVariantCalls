#!/bin/bash
set -e


out_dir=$1 
run_cmd=$2 
fn_contigsize=$3
run_bcf=$4
fn_tcga=$5
fn_icgc=$6

chunksize=500000
for c_idx in {1..22}; do
    chr=$(cut -f 1 $fn_contigsize | head -n $c_idx | tail -n 1)
    len=$(cut -f 2 $fn_contigsize | head -n $c_idx | tail -n 1)
    if [ ! -d $out_dir/${chr} ]; then
	mkdir -p $out_dir/${chr};
    fi
    for chunk in $(seq 1 $chunksize $(($len + $chunksize)))
    do
	bsub -J "mergevcf"  -K -M 1024 -W 1:00 -n 1 -R "rusage[mem=1024]" $run_cmd $chr $chunk $(($chunk + $chunksize - 1)) $out_dir/${chr}/full_callset.all.$chr.$chunk.vcf.gz $run_bcf $fn_tcga $fn_icgc & ### -k option to wait later
	sleep 1
    done
    wait
done
