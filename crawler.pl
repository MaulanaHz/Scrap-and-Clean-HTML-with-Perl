use strict;
use warnings;
use POSIX qw(strftime);
use feature 'state';
use WWW::Mechanize;

sub genDate{
    return my $date = strftime "$_[0]", localtime time()-($_[1]*24*60*60);
}

my $mech = WWW::Mechanize->new();
my @all_urls;
my %news_links;
my $total_bola = 0;
my $total_oto = 0;
my $url = "";

my $fileName = $ARGV[1] or die "\nAnda tidak Memasukkan Nama File. Ulangi Input...\n";
open OUT, ">$fileName" or die "Tidak Bisa Membuat File!";

my $total_days = int($ARGV[0]) or die "\nAnda tidak menginput jumlah hari kebelakang yang ingin anda crawl\nUlangi Input...";

print "\nMemulai pendataan tautan.....\n";

for (my $i=0; $i<=$total_days; $i++){ #variabel $input harus dicasting ke int agar looping berjalan

    my $date = genDate("%Y-%m-%d", $i); 
    
    #melakukan operasi split terhadap string hasil dari
    #operasi genDate(). Setiap angka dipisahkan menurut tanda '-'
    (my $year, my $month, my $day) = split /-/, $date;
    print "Crawling data pada : $date==\t";

    my $page;

    for ($page=0; $page<=50; $page+=1){
        $url = "https://indeks.kompas.com/?site=all&date=$year-$month-$day&page=$page";
        
        $mech->get($url);
        @all_urls = $mech->links();
        #print "$url";
        foreach my $link (@all_urls){
            my $url = $link->url;

                #jika url mengandung substring "/read/" dan belum di-hash, maka hash
                if ($url=~"/read/" && !exists $news_links{$link->url}){

                    if ($url=~"otomotif.kompas.com" && $total_oto<=8000){
                        $news_links{$url} = 1;
                        $total_oto++;
                    }

                    if ($url =~"bola.kompas.com" && $total_bola<=8000){
                       $news_links{$url} = 1;
                       $total_bola++;
                    }
                }
        } #akhir looping untuk array all_urls
    } #akhir looping halaman
    print "Total Berita Bola      : $total_bola||\t";
    print "Total Berita Otomotif  : $total_oto\n";
} #akhir looping tanggal

print "Berhasil mendapatkan ". ($total_oto+$total_bola) ."tautan.\nMemulai pengunduhan....";
sleep(8);

foreach (sort keys (%news_links)) {
    print OUT "$_\n";
}
print "\nproses selesai!\nURL yang disimpan ". ($total_oto+$total_bola) ." \n\n";
close OUT;
