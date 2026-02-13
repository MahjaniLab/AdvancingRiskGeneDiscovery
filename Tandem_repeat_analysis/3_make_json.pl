for($a = 1; $a <= 4; $a++){
  $out = "loci.$a.json";
  open(OUT, ">$out");
  print OUT "\[";

  $count = 0;
  open(IN, "loci_tested_wmotif.bed");
  while($line = <IN>){ 
    $count++;
    if($count == $a){
      chomp($line);
      @split = split "\t", $line;
      $loci_id = $split[0] . "_" . $split[1] . "_" . $split[2] . "_" . $split[3];
      if($split[2] !~ /random/){
        $string = "\n\{" . "\n" . 
          "\"LocusId\": \"" . $loci_id . "\"," . "\n" . 
          "\"LocusStructure\": \"\($split[3]\)\*\"," . "\n" .
          "\"ReferenceRegion\": \"" . $split[0] . ":" . $split[1] . "\-" . $split[2] . "\"," . "\n" .
          "\"VariantType\": \"Repeat\"". "\n" . "\}";
        push @command, $string;
      }
    }
    if($count == 4){$count = 0;}
  }
  close IN;
  $join = join ",", @command;
  print OUT $join;
  print OUT "\n\]\n";
  close OUT;
  undef(@command);  
}
