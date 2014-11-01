#!/bin/bash

string="GC.galleryItems = {\n\n"
echo -e  "$string" >> make2.txt

count=0
for i in *.jpg; 
do 
  title="\t\t\"galleryItem"$count"\": {\n"
  medium="\t\t\t\t\"medium\": \"./gallery/medium/"$i"\",\n"
  large="\t\t\t\t\"large\": \"./gallery/large/"$i"\",\n"
  original="\t\t\t\t\"original\": \"./gallery/original/"$i"\",\n"
  separator="\t\t}\n\t\t,\n"
  echo -e "$title$medium$large$original$separator" >> make2.txt

  count=$((count+1))
 
done
