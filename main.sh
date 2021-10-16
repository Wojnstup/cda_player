#! /bin/bash

## Getting the search query
read -p "Name of the movie: " query

## Getting the url of a search query
query=${query// /_}
query=${query,,}
url="https://www.cda.pl/info/${query}"

## Getting the links and titles of search results
links=$(curl $url | grep "link-title-visit" | grep "video/" | awk '{print $3}' | awk -F\" '{print $2}')
titles=$(curl $url | grep "link-title-visit" | grep "video/" | awk -F\> '{print $2}' | awk -F\< '{print $1}') 

## Print out the titles of search results
declare -i index=1
for link in $links
do
	echo -n "$index. "
	echo "$titles" | sed -n $index\p 
	index=$(( index + 1 ))
done

read -p "Index to watch: " movie
output=$( echo "$links" | sed -n $movie\p )
final=${output//"https://www.cda.pl"/}

mpv "https://www.cda.pl$final"

