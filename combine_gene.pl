#!/usr/bin/perl  -w
use strict;

my ($profile,$output)=@ARGV;

my %hash;
open IN,"$profile" or die "can not open the file $profile!\n";
my $head=<IN>;
my @class_name=split(/\t/,$head);
shift(@class_name);
my @class_head;
foreach my $i(@class_name)
{
	my $name=(split/\:/,$i)[1];
	if($name=~/([a-zA-Z]+)([0-9]+)/)
	{
		my $a=$1;
		push(@class_head,$a)
	}

}
my $new_head=join("\t",@class_head);

open OUT,">$output" or die "can not open the file $output!\n";
print OUT "\t$new_head\n";
my $len;
while(<IN>)
{
	chomp;
	my $gene=(split/\t/,$_)[0];
	my @info=split(/\t/,$_);
	shift @info;
	$len=@info;
	
	if(exists $hash{$gene})
	{
		$hash{$gene}.=" @info";
	}
	else
	{
		$hash{$gene}="@info";
	}
}
close IN;

foreach my $key (keys %hash)
{
	my $value=$hash{$key};
	my @value=split(/\s+|\t/,$value);
	my $len_g=@value;
	my $n=$len_g/$len;
	my $final_value;
	if($n==1)
	{
		$final_value=join("\t",@value);
		print OUT "$key\t$final_value\n";
	}
	else
	{
		my $i=1;
		my @mid_value;
		while($i<=$len)
		{
			my @array;
			my $j;
			for($j=1;$j<=$n;$j=$j+1)
			{
				my $q=($j-1)*$len+$i-1;
				my $v=$value[$q];
				push(@array,$v);
			}
			my $mid_value=mid(@array);
			push(@mid_value,$mid_value);
			$i=$i+1;
		}
		$final_value=join("\t",@mid_value);
		print OUT "$key\t$final_value\n";
	}

}

sub mid{
    my @list = sort{$a<=>$b} @_;
    my $count = @list;
    if( $count == 0 )
    {
        return undef;
    }   
    if(($count%2)==1){
        return $list[int(($count-1)/2)];
    }
    elsif(($count%2)==0){
        return ($list[int(($count-1)/2)]+$list[int(($count)/2)])/2;
    }
}
