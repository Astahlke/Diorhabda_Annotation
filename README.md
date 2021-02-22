# Annotating Diorhabda genomes assembled through Ag100 Pest Initiative 
https://scinet.usda.gov/working-groups/ag100pest

## 1. Validate sex chromosomes in Diorhabda assemblies with population-level data
Following 
Running this on ibest cluster: https://crc.ibest.uidaho.edu/general/Services/ 


```
projhome=/mnt/ceph/stah3621/diorhabda/annotation_genome/radsex

```

### starting off with carinulata which has the first best assembly yet
 
```
outdir=$projhome/carinulata/

assmdir=/mnt/ceph/stah3621/diorhabda/assemble_genome/Hilo


# sexed samples map
popmap=$projhome/carinulata/carinulata_sex_popmap.txt
samplesdir=$projhome/carinulata/sexed_samples

# sym link and rename sexed samples de-multiplexed with process_radtags, only using the cut-site forward reads
samples=$(cut -f 1 $popmap)

for s in $samples; do

if [ -f "/mnt/ceph/stah3621/diorhabda/active_stacks/2019/2processed/${s}.1.fq.gz" ]; then #check that file exists 
	echo $s 
	ln -s /mnt/ceph/stah3621/diorhabda/active_stacks/2019/2processed/${s}.1.fq.gz $samplesdir/${s}.fq.gz;  
fi
done
```

Run radsex!

```
./bin/radsex process --input-dir $samplesdir --output-file $outdir/markers_table.tsv --threads 16
./bin/radsex distrib --markers-table $outdir/markers_table.tsv --output-file $outdir/distribution.tsv --popmap $popmap --min-depth 5 --groups M,F
./bin/radsex signif --markers-table $outdir/markers_table.tsv --output-file $outdir/significant_markers.tsv --popmap $popmap --min-depth 5 --groups M,F

## Map to reference genome
carinu_assm=$assmdir/ssim/Diorhabda_carinulata_no_mito.p_ctg.fasta  

./bin/radsex map --markers-file $outdir/markers_table.tsv --output-file $outdir/map_results.tsv --popmap $popmap --genome-file $assm --min-depth 5 --groups M,F

assms=$(ls $assmdir/ssim/Diorhabda_carinata_no_mito.p_ctg.fasta $assmdir/Diorhabda_*_male/purged.fa)

for a in $assms; do
	./bin/radsex map --markers-file $outdir/markers_table.tsv --output-file $outdir/map_results.tsv --popmap $popmap --genome-file $a --min-depth 5 --groups M,F
done
```

Complement this with vizualization in R using https://github.com/SexGenomicsToolkit/sgtr  





