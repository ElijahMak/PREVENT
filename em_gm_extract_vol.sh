subject=${1}
cd $subject
fslstats *_bet_pve_1 -M -V | awk '{ print $1 * $3 }'

