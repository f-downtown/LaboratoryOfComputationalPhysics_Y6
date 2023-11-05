
#!/bin/bash
declare -A char_counts
for i in {A..Z}; do
  counter=0
  while IFS=, read -r A _; do
    if [[ ${A:0:1} == $i ]]; then
      ((counter=counter+1))
    fi
  done < <(tail -n +2 LCP_22-23_students.csv | cut -d ',' -f 1)
  char_counts["$i"]=$counter
done
echo "" > ct
touch maxval
max=0
for i in {A..Z}; do
  echo "$i : ${char_counts[$i]}" >> ct
  if [[ "${char_counts[$i]}" -gt "$max" ]]; then
    max=${char_counts[$i]}
  fi
done
echo "$max" > maxval


line_number=0
while IFS= read -r line; do
  j=$(( line_number % 18 ))
  output_file="Mod18_group_${j}.csv"
  echo "$line" >> "$output_file"
  ((line_number++))
done < <(tail -n+2 LCP_22-23_students.csv)
