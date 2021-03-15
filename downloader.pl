use strict;
use warnings;

my %hash;
my $filename = $ARGV[0] or die "\nAnda tidak memasukkan file link. Ulangi input....\n";

#mode pembacaan file adalah <
open (my $fh, '<:encoding(UTF-8)', $filename) or die "\nFile gagal dibuat!\n";

my $x=0, my $y=0;
while (my $row = <$fh>){

    #chomp digunakan untuk membuang newline dari string
    chomp($row);
    if ($row =~ "bola.kompas.com"){
        `wget -O bola-$x.html $row`;
	    $x++;
    }

    if ($row =~ "otomotif.kompas.com"){
        `wget -O otomotif-$y.html $row`;
	    $y++;
    }
}