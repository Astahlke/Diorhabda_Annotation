#!/bin/bash

#Define the string to split
text=$(cat chromosomes_names.tsv)

#Define multi-character delimiter
delimiter=">ptg000"
#Concatenate the delimiter with the main string
string=$text$delimiter

rm new_names.tsv

#Split the text based on the delimiter
myarray=()
while [[ $string ]]; do
  myarray+=( "${string%%"$delimiter"*}" )
  string=${string#*"$delimiter"}
done

#Print the words after the split
for value in ${myarray[@]}
do
  echo "${value}" >> new_names.tsv
done

paste chromosomes_names.tsv new_names.tsv > new_chromosomes_names.tsv

# append the new name to the scaffold names 
#for f in file1 file2 file3; do sed -i "s/$/\t$f/" $f; done


