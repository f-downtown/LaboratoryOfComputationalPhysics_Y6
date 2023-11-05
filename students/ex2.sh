
#!/bin/bash
touch tmp
tail -n+4 data.csv > tmp
awk 'NR > 1 {for (i=1; i<=NF; i++) gsub(/,/, " ", $i)}1' tmp > data.txt
rm tmp
counter=0
greater_count=0
smaller_count=0

while IFS= read -r line; do
  IFS=" " read -ra fields <<< "$line"
    X=${fields[0]}
    Y=${fields[1]}
    Z=${fields[2]}
    value=$(echo "scale=10; sqrt($X^2 + $Y^2 + $Z^2)" | bc)
    threshold=$(echo "scale=10; 100*sqrt(3)/2" | bc)
    if (( $(echo "$value > $threshold" | bc -l) )); then
    ((greater_count++))
    else
    ((smaller_count++))
    fi
  for field in "${fields[@]}"; do
    if ((field % 2 == 0)); then
      ((counter++))
    fi
  done
done < <(tail -n +2 data.txt)
echo "$counter"
echo "Entries with sqrt(X^2 + Y^2 + Z^2) > 100*sqrt(3)/2: $greater_count"
echo "Entries with sqrt(X^2 + Y^2 + Z^2) <= 100*sqrt(3)/2: $smaller_count"



if [ $# -ne 1 ]; then
  echo "Usage: $0 <n>"
  exit 1
fi
n=$1
if [ ! -f data.txt ]; then
  echo "data.txt not found."
  exit 1
fi
for ((i = 1; i <= n; i++)); do
  output_file="data_divided_by_${i}.txt"
  awk -v factor="$i" 'NR == 1 {print; next} {for (j = 1; j <= NF; j++) $j /= factor; print}' data.txt > "$output_file"
  echo "Created $output_file"
done