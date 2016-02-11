#!/bin/bash
curl http://www.nbs.rs/kursnaListaModul/srednjiKurs.faces?lang=lat | grep EMU | sed 's/.*\([0-9]\{3\},[0-9]\{4\}\).*/\1/'
