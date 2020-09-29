#!/bin/sh

in_file=all_NODDI_fnirt_jhu_roi.txt      # Input file
params=47            # Parameters count
res_file=$(mktemp)  # Temporary file
sep=' '             # Separator character

# Print header
cnt=0
for i in $(cat $in_file | head -$((params*2))); do
    if [ $((cnt % 2)) -eq 0 ]; then
        echo $i
    fi
    cnt=$((cnt+1))
done | sed ":a;N;\$!ba;s/\n/$sep/g" >>$res_file

# Parse and print values
cnt=0
for i in $(cat $in_file); do
    # Print values, skip param names
    if [ $((cnt % 2)) -eq 1 ]; then
        echo -n $i >>$res_file
    fi

    if [ $(((cnt+1) % (params*2))) -eq 0 ]; then
        # Values line is finished, print newline
        echo >>$res_file
    elif [ $((cnt % 2)) -eq 1 ]; then
        # More values expected to be printed on this line
        echo -n "$sep" >>$res_file
    fi

    cnt=$((cnt+1))
done

# Make nice table format
cat $res_file | column -t
rm -f $res_file
