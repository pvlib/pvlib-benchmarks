#!/bin/bash

set -e

# conda functions aren't exported to subshells by default
source /var/home/pvlib/miniconda3/etc/profile.d/conda.sh
conda activate pvlib-asv

# The directory containing the pvlib-python and pvlib-benchmarks repos
ROOTDIR=~

# fetch any new commits on origin/main
cd $ROOTDIR/pvlib-python
git checkout main
git pull origin main
# also fetch new tags (needed to have correct version string in benchmarks)
git fetch --all --tags

# install main, not to benchmark it, but to supply whatever imports
# are needed to make the benchmark files importable during discovery.
# this assumes that the benchmark files don't need anything besides pvlib[all].
pip install .[all]

cd $ROOTDIR/pvlib-benchmarks
# fetch any remote updates first, so the `git push` later on doesn't fail
git pull origin master

# copy over the asv configuration from pvlib-python
cp $ROOTDIR/pvlib-python/benchmarks/asv.conf.json ./asv.conf.json

# custom settings -- overwrite the location of the benchmarks since we
# are running from another directory
sed -i '/\"repo\":/c\    \"repo\": \"../pvlib-python\",' asv.conf.json
sed -i '/\"benchmark_dir\":/c\    \"benchmark_dir\": \"../pvlib-python/benchmarks/benchmarks\",' asv.conf.json

MACHINE=`python -c "from asv.machine import Machine; print(Machine.load('.asv-machine.json').machine)"`

echo "asv: "`asv --version`
echo "Machine: "$MACHINE

# run benchmarks for all commits since the latest benchmarked on this machine
asv run NEW

# save results, push to GH
git add results
git commit -m "Nightly ASV results ($MACHINE)"
git push origin master

# update HTML report, push to GH
asv gh-pages --no-push --rewrite
git push origin -f gh-pages
