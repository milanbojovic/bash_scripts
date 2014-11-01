#!/bin/bash
for i in *.jpg; 
do
 new="$(echo "$i" | cut -c7-)"
 mv "$i" "$new"
done
