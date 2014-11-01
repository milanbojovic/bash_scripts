#!/bin/bash
count=0

for i in *.jpg; 
do 
  s1="\t\t\t\t<span class=\"holder\" id=\"galleryItem"$count"\">"
  s2="\t\t\t\t<img alt=\"Tiny\" class=\"thumb\" src=\"./gallery/tiny/"$i"\">"
  s3="\t\t\t\t</span>"


  line="\n$s1\n\t$s2\n$s3\n"
  
  echo -e "$line" >> make1.txt

  count=$((count+1))
 
done


