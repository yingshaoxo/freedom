git verify-pack -v .git/objects/pack/*.idx |
  sort -k3 -n |
  awk '$3 > 10485760 {print $1}' |
  while read hash; do
    git rev-list --objects --all | grep $hash
  done
