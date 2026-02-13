#!/usr/bin/perl
use strict;
use warnings;

$bed_file = "filtered_loci.bed";
$genome_file = "/sc/arion/projects/buxbaj01a/Madison/TRE/resources/Homo_sapiens_assembly38.fasta";
$regions_file = "filtered_loci.N.bed";
$fasta_output = "output.fasta";

# Create a list of regions
open($fh, '<', $bed_file) or die "Cannot open $bed_file: $!";
open($regions_fh, '>', $regions_file) or die "Cannot open $regions_file: $!";

while ($line = <$fh>) {
    chomp $line;
    ($chr, $start, $end, $motif) = split(/\t/, $line);

    # Adjust start and end to get 1000 bases upstream and downstream
    $seq_start = $start - 1000;
    $seq_end = $end + 1000;
    $seq_start = 0 if $seq_start < 0;

    print $regions_fh "$chr:$seq_start-$seq_end\n";
}

close $fh;
close $regions_fh;

# Fetch all sequences
`samtools faidx $genome_file -r $regions_file > $fasta_output`;

# Process the fetched sequences
open($fasta_fh, '<', $fasta_output) or die "Cannot open $fasta_output: $!";
$/ = ">"; # Set input record separator to fasta record separator

while ($record = <$fasta_fh>) {
    next if $record eq '>'; # Skip the first empty record
    ($header, @sequence) = split(/\n/, $record);
    $sequence = join('', @sequence);
    $n_count = ($sequence =~ tr/N//);

    if ($n_count <= 4) {
        print $header, "\n"; 
    }
}

close $fasta_fh;
