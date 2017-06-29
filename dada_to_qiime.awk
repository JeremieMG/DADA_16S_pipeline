BEGIN {
  print "#OTU table from DADA" ;
  a[8] = "k__" ;
  a[9] = "p__" ;
  a[10] = "c__" ;
  a[11] = "o__" ;
  a[12] = "f__" ;
  a[13] = "g__" ;
  a[14] = "s__" ;
}


#Print the OTU header without the taxonomic ranks
/^#OTU/ {
  for (i=1; i<(NF-6); i++) printf $i "\t"; print "taxonomy"
}

#Print the sequence variants, their count and their taxonomic assignment in the QIIME format
#First print the count, then add semicolon and white-space to classification names except for the last one
/^SV/ {
  for (i=1; i<(NF-6); i++) printf $i "\t";
  for (i=8; i<(NF); i++) printf a[i] $i "; ";
  print a[14] $NF
}
