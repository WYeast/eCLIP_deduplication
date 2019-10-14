#!/usr/bin/perl
use strict;

## For removing the PCR duplicates

open FASTQ, "$ARGV[0]", or die $!;
open BAM,"samtools view -h $ARGV[1] |" or die $!;
open OUT,">$ARGV[2]" or die $!;
my %barcode_hash;

## extract reads id and barcode from fastq file
while(<FASTQ>){
	chomp;
	my @sp=split /\s+/;
	$sp[0]=~s/@//;
	my $read_id=$sp[0];
	chomp (my $seq = <FASTQ>);
        my $barcode= substr($seq,0,10);
	$barcode_hash{$read_id}=$barcode;
}
close FASTQ;

## extract reads id, genomic coordination, barcode of each sequence from bam files
my %id_hash;
while(<BAM>){
	chomp;
	if(/^@/){
		print OUT "$_\n";
	}
	else{
		my @sp=split /\s+/;
		my $new_id="$barcode_hash{$sp[0]}\s$sp[2]\s$sp[3]";
		$id_hash{$new_id}=$_;
	}
}
close BAM;
my %count;

## if reads id, genomic coordination, barcode of two or multiple reads are identical, they will be regarded as duplicates
## only one of duplicates will be retained and wrote to deduplicated file	
my @unique_reads_id = grep { ++$count{$_} < 2; } keys %id_hash;
foreach(@unique_reads_id){
	print OUT "$id_hash{$_}\n";
}


