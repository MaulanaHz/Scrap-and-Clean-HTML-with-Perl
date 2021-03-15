#!/usr/bin/perl
#
# Program ini digunakan untuk mengekstrak bagian konten dari sebuah file HTML
#
# Author: Taufik Fuadi Abidin
# Department of Informatics
# College of Science, Syiah Kuala Univ
# 
# Date: Mei 2011
# http://www.informatika.unsyiah.ac.id/tfa
#
# Dependencies:
# INSTALASI HTML-EXTRACTCONTENT
# See http://www.cpan.org/
#
# 1. Download HTML-ExtractContent-0.10.tar.gz and install
# 2. Download Exporter-Lite-0.02.tar.gz and install
# 3. Download Class-Accessor-Lvalue-0.11.tar.gz and install
# 4. Download Class-Accessor-0.34.tar.gz and install
# 5. Download Want-0.18.tar.gz and install
#

use strict;
use warnings;
use HTML::ExtractContent;
use File::Basename;
use Excel::Writer::XLSX;

my $x = 0;
while($x < 2){
  $x++;

  # get file
  #my $file = "bola-$x.html";
  my $file = "otomotif-$x.html";
  my $fileout = basename($file);
  #print "fileout: [$fileout]\n";

  # Directory where clean data are stored, its better to set this in config file
  my $PATHCLEAN = "./clean";

  $fileout = "$PATHCLEAN/$fileout";
  #print "$fileout\n";

  # open file
  $fileout =~ s/.html//;
  open OUT, "> $fileout.bersih.html" or die "Cannot Open File!!!";

  # object
  my $extractor = HTML::ExtractContent->new;
  my $html = `type $file`;

  #$html = lc($html);  # don't make it lowercase

  $html =~ s/\^M//g;
  
  # get TITLE
  $html =~ /<title.*?>(.*?)<\/title>/;
  my $title = $1;
  $title = clean_str($title);
  print "$fileout\t <title>$title</title>\n";
  print OUT "<title>$title</title>\n";
  
  # get BODY (Content)
  $extractor->extract($html);
  my $content = $extractor->as_text;
  $content = clean_str($content);
  my @array1 = split(/\./, $content);
  my $panjang = scalar(@array1);
  #print "$panjang\n";
  my @top = @array1[0..($panjang*(4/10))];
  my @middle = @array1[($panjang*(4/10))+1..($panjang*(7/10))];
  my @bottom = @array1[($panjang*(7/10))+1..$panjang];
  
  print OUT "<atas>@top</atas>\n";
  print OUT "<tengah>@middle</tengah>\n";
  print OUT "<bawah>@bottom</bawah>\n";
  #print OUT "<content>$content</content>\n";

  my $workbook  = Excel::Writer::XLSX->new( "$fileout.bersih.xlsx" );
  my $worksheet = $workbook->add_worksheet();
  $worksheet->write( "A1", "$title" );
  $worksheet->write( "B1", "@top" );
  $worksheet->write( "C1", "@middle" );
  $worksheet->write( "D1", "@bottom" );
 
  $workbook->close;

  close OUT;
  if($x % 1000 == 0){
    print "\nDone : $x\n";
  }
  
}

sub clean_str {
  my $str = shift;
  $str =~ s/>//g;
  $str =~ s/&.*?;//g;
  #$str =~ s/[\:\]\|\[\?\!\@\#\$\%\*\&\,\/\\\(\)\;"]+//g;
  $str =~ s/[\]\|\[\@\#\$\%\*\&\\\(\)\"]+//g;
  $str =~ s/-/ /g;
  $str =~ s/\n+//g;
  $str =~ s/\s+/ /g;
  $str =~ s/^\s+//g;
  $str =~ s/\s+$//g;
  $str =~ s/^$//g;
  return $str;
}