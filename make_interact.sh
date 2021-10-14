# Convert loops.bedgraph to .interact format for UCSC Genome Browser
export OUTDIR=/home/FCAM/awilderman/ANALYSIS/HiC/CNCC/HiCExplorer
export LABEL=H9
export RESOLUTION=10000
export REGION=chr7:25000000-28000000

cd "$OUTDIR"
echo "cat "$LABEL"_"$RESOLUTION"_loops.bedgraph | \
awk '{print \$1\"\t\"\$2\"\t\"\$6\"\t"$LABEL"_"$RESOLUTION"_\"\$1\":\"\$2\"-\"\$6\"\t0\t\"\$7\"\t"$LABEL"_"$RESOLUTION"\t0,0,0\t\"\$1\"\t\"\$2\"\t\"\$3\"\t\"\$1\":\"\$2\"-\"\$3\"\t.\t\"\$4\"\t\"\$5\"\t\"\$6\"\t\"\$4\":\"\$5\"-\"\$6\"\t.\"}' > "$LABEL"_"$RESOLUTION".interact
sed -i -e '1i \
track type=interact name=\"interact "$LABEL"_"$RESOLUTION" pval=0.05\" description=\""$LABEL" loops at "$RESOLUTION"\" interactDirectional=true maxHeightPixels=200:100:50 visibility=full\\nbrowser position "$REGION"' "$LABEL"_"$RESOLUTION".interact"> write_interact.sh

echo "cat "$LABEL"_"$RESOLUTION"_loops_p1.bedgraph | \
awk '{print \$1\"\t\"\$2\"\t\"\$6\"\t"$LABEL"_"$RESOLUTION"_\"\$1\":\"\$2\"-\"\$6\"\t0\t\"\$7\"\t"$LABEL"_"$RESOLUTION"\t0,0,0\t\"\$1\"\t\"\$2\"\t\"\$3\"\t\"\$1\":\"\$2\"-\"\$3\"\t.\t\"\$4\"\t\"\$5\"\t\"\$6\"\t\"\$4\":\"\$5\"-\"\$6\"\t.\"}' > "$LABEL"_"$RESOLUTION".interact
sed -i -e '1i \
track type=interact name=\"interact "$LABEL"_"$RESOLUTION" pval=0.1\" description=\""$LABEL" loops at "$RESOLUTION" interact\" Directional=true maxHeightPixels=200:100:50 visibility=full\\nbrowser position "$REGION"' "$LABEL"_"$RESOLUTION".interact"> write_interact.sh

# Double-check the track line of the .interact file after sed, some versions don't introduce the newline as expected
