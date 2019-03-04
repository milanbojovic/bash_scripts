sudo pacman -Qk > pacman.out 2> pacman.err
cat pacman.err | awk '{print $2}' | sed 's/://' | sort | uniq | tr "\n" " " > corupt_packages
echo `cat corupt_packages | grep wc -l`
