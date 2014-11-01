#!/bin/bash
for i in *.jpg; do convert $i -resize 960x571 large_$(basename $i .jpg).JPG; done
