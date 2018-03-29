#!/usr/bin/perl  -w
use strict;

my ($profile1,$profile2,$output)=@ARGV;

open IN1,"$profile1" or die "can not open the file $profile1!\n";
my $head1=<IN1>;
my @head1=split("\t",$head1);
shift @head1;
chomp (@head1);
my %hash1;
while(<IN1>)
{
	chmod;
	my $gene=(split/\t/,$_)[0];
	my @info=split(/\t/,$_);
	shift @info;
	chomp (@info);
	$hash1{$gene}="@info";
}
close IN1;

open IN2,"$profile2" or die "can not open the file $profile2!\n";
my $head2=<IN2>;
my @head2=split("\t",$head2);
shift @head2;
chomp (@head2);
my %hash2;
while(<IN2>)
{
	chmod;
	my $gene=(split/\t/,$_)[0];
	my @info=split(/\t/,$_);
	shift @info;
	chomp (@info);
	$hash2{$gene}="@info";
}
close IN2;

my @key1=keys %hash1;
my @key2=keys %hash2;
my @key;
push(@key,@key1);push(@key,@key2);
my %count;
my @co_key=grep {++$count{$_}>1;}@key;

open OUT,">$output" or die "can not open the file $output!\n";
my @head;
push(@head,@head1);push(@head,@head2);
my $head=join("\t",@head);
print OUT "\t$head\n";
foreach my $i(@co_key)
{
	my $info1=$hash1{$i};
	my @info1=split(/\s+/,$info1);

	my $info2=$hash2{$i};
	my @info2=split(/\s+/,$info2);

	my @info;
	push(@info,@info1);
	push(@info,@info2);

	my $info_all=join("\t",@info);
	print OUT "$i\t$info_all\n";
}
