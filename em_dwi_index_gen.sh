subject=${1}
cd $subject
myVar=($(wc -w bval)) #Count the number of volumes and save as a variable
indx=""
for ((i=1; i<=$myVar; i+=1)); do indx="$indx 1"; done
echo $indx > index.txt
