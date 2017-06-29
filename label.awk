BEGIN {
  a = 1
  seq = "SV_"
}

#Print header
/^OTU/ {
print "#" $0
}

#Print lines with another label
/^[ACTG]/{printf seq a "\t"; for (i=2; i<NF; i++) printf $i "\t"; print $NF ;
a += 1
}
