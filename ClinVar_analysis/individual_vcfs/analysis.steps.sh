# 20130606_g1k_3202_samples_ped_population.txt --> 1kGP populations list
# 1kGP.3202_samples.pedigree_info.txt --> 1kGP pedigree

# Downloading 1kGP data:
for chr in {1..22}; do
  wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20220422_3202_phased_SNV_INDEL_SV/1kGP_high_coverage_Illumina.chr${chr}.filtered.SNV_INDEL_SV_phased_panel.vcf.gz
  wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20220422_3202_phased_SNV_INDEL_SV/1kGP_high_coverage_Illumina.chr${chr}.filtered.SNV_INDEL_SV_phased_panel.vcf.gz.tbi
 done

# Extract a single sample (includes 0/0) for ease of annotation
for chr in {1..22}; do
  bcftools view --threads 8 -s NA12878 1kGP_high_coverage_Illumina.chr${chr}.filtered.SNV_INDEL_SV_phased_panel.vcf.gz > NA12878_chr${chr}.vcf
done

# SNPeff annotate
for chr in {1..22};
  do
    java -Xmx8g -jar /path/to/snpEff/snpEff.jar \
    -v GRCh38.86 -canon NA12878_chr${chr}.vcf  > NA12878_chr${chr}.snpeff.vcf
 done

# SNPshift with dbNSFP4a, grabs annotations
for chr in {1..22};
  do
    java -jar /path/to/snpEff/SnpSift.jar dbnsfp -v \
    -db /path/to/dbNSFP4.1a.txt.gz \
    -f gnomAD_exomes_AF,SIFT_score,SIFT4G_score,Polyphen2_HDIV_score,Polyphen2_HVAR_score,genename,Ensembl_geneid \
     NA12878_chr${chr}.snpeff.vcf >  NA12878_chr${chr}.snpeff.NSFP.vcf
  done

# Identifies functional sites based on PolyPhen, Sift, and allele frequency
for chr in {1..22};
  do
    perl filter.pl NA12878_chr${chr}.snpeff.NSFP.vcf > keep_chr${chr}.vcf
  done

# Extracts functional sites from all 3,202
for chr in {1..22};
  do
    grep -P "^#" NA12878_chr${chr}.snpeff.NSFP.vcf > header.txt
    cat header.txt keep_chr${chr}.vcf > keep_chr${chr}.reheader.vcf

    bcftools view \
      -T keep_chr${chr}.reheader.vcf \
      -O v --threads 8 \
      -o full_1kGP_functional_deleterious_noAFfilt.chr${chr}.vcf \
      1kGP_high_coverage_Illumina.chr${chr}.filtered.SNV_INDEL_SV_phased_panel.vcf.gz
  done
