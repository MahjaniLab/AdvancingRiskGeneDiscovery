open(IN, "loci_tested.bed");
while($line = <IN>){
  chomp($line);
  @split = split "\t", $line;
  $id = $split[0] . "_" . ($split[1] +1000) . "_" . ($split[2] - 1000);
  $store{$id}++;
}
close IN;

open(IN, "filtered_loci.bed");
while($line = <IN>){
  chomp($line);
  @split = split "\t", $line;
  $id = $split[0] . "_" . $split[1] . "_" . $split[2]; 
  if($store{$id} =~ /./){
    print $line, "\n";
  }
}
close IN;

