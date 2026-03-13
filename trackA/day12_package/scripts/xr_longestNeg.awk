# Usage:
#   awk -v H=0.0254 -v xMax=0.206 -f xr_longestNeg.awk line.xy
# Notes:
# - reads x, Ux from columns 1,2
# - finds all contiguous segments where Ux<0
# - selects the segment with maximum streamwise length
# - defines reattachment xr at downstream end via linear interpolation across Ux=0
BEGIN{
  bestLen=-1; bestEnd=-1;
}
!/^#/ && NF>0{
  x=$1; u=$2;

  if(xMax>0 && x>xMax) next;

  xs[n]=x; us[n]=u; n++;

  if(n==1){ inNeg=(u<0); s=n-1; next; }

  if(!inNeg && u<0){ inNeg=1; s=n-1; }

  if(inNeg && u>=0){
    inNeg=0;
    e=n-2;
    len=xs[e]-xs[s];
    if(len>bestLen){
      bestLen=len; bs=s; be=e;
      L=e; R=e+1;
    }
  }
}
END{
  if(bestLen<0){
    print "ERROR: no negative segment found" > "/dev/stderr";
    exit 2;
  }
  x1=xs[L]; u1=us[L];
  x2=xs[R]; u2=us[R];

  if(!(u1<0 && u2>=0)){
    print "ERROR: invalid crossing bracket (need u1<0, u2>=0)" > "/dev/stderr";
    exit 3;
  }

  xr = x1 + (0-u1)*(x2-x1)/(u2-u1);

  printf("bestNeg [%.6g, %.6g], len=%.6g m\n", xs[bs], xs[be], bestLen);
  printf("xr=%.6g m, xr/H=%.6f\n", xr, xr/H);
}
