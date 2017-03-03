#!/usr/bin/bash



runvcfthdf5=vcfThdf5.py
runmergechunk=runMergeOnChunk.sh
run_bcf=bcftools #location of bcftool
dir_vcf=. #out dir for chunked vcf (YOU SHOULD CHANGE THAT)

fn_contigsize=./contig_size_list
fn_tcga=full_callset.TCGA.vcf.bgz 
fn_icgc=full_callset.ICGC.vcf.bgz

fn_variants_hdf5=output.hdf5
dir_var_temp=temp #define some temporary storage location

./parallelMergingVcf.sh $dir_vcf $runmergechunk $fn_contigsize $run_bcf $fn_tcga $fn_icgc
./submitvcfThdf5_eth.sh $runvcfthdf5 $dir_vcf $fn_variants $fn_contig $dir_var_tmp 
./mergevcfhdf5.py $dir_var_tmp $fn_variants_hdf5 


