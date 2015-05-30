convert $2 -gravity east -splice $1x0 temp.png 
convert temp.png -gravity west -splice $1x0 $3
rm temp.png
