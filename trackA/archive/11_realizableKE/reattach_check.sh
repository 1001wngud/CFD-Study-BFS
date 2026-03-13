#!/usr/bin/env bash
set -euo pipefail

# Usage: ./reattach_check.sh [time] [H] [x0]
# Defaults are tuned for the current case.

t=${1:-285}
H=${2:-0.0254}
x0=${3:-$H}

base_dir=$(pwd)

f_tau="$base_dir/postProcessing/graphUniform_tauLowerWall/$t/line.xy"
f_u="$base_dir/postProcessing/graphUniform_reattach/$t/line.xy"

if [[ ! -f "$f_tau" ]]; then
  echo "Missing: $f_tau" >&2
  exit 1
fi
if [[ ! -f "$f_u" ]]; then
  echo "Missing: $f_u" >&2
  exit 1
fi

get_cross() {
  local file="$1"
  local col="$2"
  local label="$3"
  awk -v x0="$x0" -v H="$H" -v col="$col" -v label="$label" '
  BEGIN{have=0; xr=""; dir=""}
  !/^#/ && NF>=col {
    x=$1; v=$col;
    if(x < x0){ if(v!=0){px=x; pv=v; have=1} ; next }
    if(have && v!=0 && (pv*v)<0){
      xr = px + (0 - pv) * (x - px) / (v - pv);
      dir = (pv<0 && v>0) ? "neg_to_pos" : "pos_to_neg";
      printf("%s cross after x0: x=%.8g  x/H=%.3f  (prev=%g -> curr=%g)  dir=%s\n", label, xr, xr/H, pv, v, dir);
      printf("RESULT %g %s\n", xr, dir);
      exit;
    }
    if(v!=0){px=x; pv=v; have=1}
  }
  END{if(xr=="") {print label " cross after x0: not found"; print "RESULT NA NA";}}' "$file"
}

# 1) Crossings
u_res=$(get_cross "$f_u" 2 "Ux")
tau_res=$(get_cross "$f_tau" 2 "tau_x")

echo "$u_res" | sed -n '1p'
echo "$tau_res" | sed -n '1p'

read u_x u_dir <<< "$(echo "$u_res" | awk '/^RESULT/{print $2, $3}')"
read t_x t_dir <<< "$(echo "$tau_res" | awk '/^RESULT/{print $2, $3}')"

# 2) Sign relation after x0
sign_line=$(paste <(awk -v x0="$x0" '!/^#/ {if($1>=x0) print $2}' "$f_u") \
                 <(awk -v x0="$x0" '!/^#/ {if($1>=x0) print $2}' "$f_tau") | \
  awk 'BEGIN{n=0;same=0;opp=0}
       {u=$1; t=$2; if(u==0 || t==0) next; n++; if((u>0 && t>0)||(u<0 && t<0)) same++; else opp++}
       END{printf("sign compare after x0: n=%d  same=%d  opp=%d  same%%=%.1f  opp%%=%.1f\n", n, same, opp, (n?100*same/n:0), (n?100*opp/n:0))}')

echo "$sign_line"

# 3) Reattachment decision logic
same_pct=$(echo "$sign_line" | awk '{for(i=1;i<=NF;i++){if($i ~ /^same%=/){split($i,a,"="); print a[2]; exit}}}')
opp_pct=$(echo "$sign_line" | awk '{for(i=1;i<=NF;i++){if($i ~ /^opp%=/){split($i,a,"="); print a[2]; exit}}}')

rel="mixed"
if [[ -n "$same_pct" && $(awk -v s="$same_pct" 'BEGIN{print (s>=90)?1:0}') -eq 1 ]]; then
  rel="same"
elif [[ -n "$opp_pct" && $(awk -v o="$opp_pct" 'BEGIN{print (o>=90)?1:0}') -eq 1 ]]; then
  rel="opposite"
fi

echo "relation: Ux and tau_x are $rel after x0"

# Decide based on relation
if [[ "$rel" == "opposite" ]]; then
  if [[ "$t_dir" == "pos_to_neg" ]]; then
    echo "reattach (by tau_x): x=$t_x  x/H=$(awk -v x="$t_x" -v H="$H" 'BEGIN{printf("%.3f",x/H)}')"
  else
    echo "reattach (by tau_x): not found (expected pos_to_neg)"
  fi
elif [[ "$rel" == "same" ]]; then
  if [[ "$t_dir" == "neg_to_pos" ]]; then
    echo "reattach (by tau_x): x=$t_x  x/H=$(awk -v x="$t_x" -v H="$H" 'BEGIN{printf("%.3f",x/H)}')"
  else
    echo "reattach (by tau_x): not found (expected neg_to_pos)"
  fi
else
  echo "reattach (by tau_x): ambiguous (sign relation not consistent)"
fi

# Also report Ux-based reattachment (neg->pos)
if [[ "$u_dir" == "neg_to_pos" ]]; then
  echo "reattach (by Ux): x=$u_x  x/H=$(awk -v x="$u_x" -v H="$H" 'BEGIN{printf("%.3f",x/H)}')"
else
  echo "reattach (by Ux): not found (expected neg_to_pos)"
fi
