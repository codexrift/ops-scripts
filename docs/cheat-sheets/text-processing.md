# Text Processing Cheat Sheet (sed + awk)

## sed

```bash
sed 's/old/new/' file.txt
sed 's/old/new/g' file.txt
sed -n '5,10p' file.txt
sed -i 's/old/new/g' file.txt
sed '/^$/d' file.txt
```

## awk

```bash
awk '{print $1, $3}' file.txt
awk -F, '{print $1, $2}' file.csv
awk '$3 > 100' file.txt
awk '/ERROR/ {print}' app.log
awk '{sum += $2} END {print sum}' numbers.txt
awk '!seen[$1]++' file.txt
```

