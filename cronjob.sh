#!/bin/bash

conda activate pvlib-asv

# The directory containing the pvlib-python and pvlib-benchmarks repos
ROOTDIR='~'

# fetch any new commits on origin/master
cd $ROOTDIR/pvlib-python
git checkout master
git pull origin master

# install master, not to benchmark it, but to supply whatever imports
# are needed to make the benchmark files importable during discovery.
# this assumes that the benchmark files don't need anything besides pvlib[all].
pip install .[all]

cd $ROOTDIR/pvlib-benchmarks
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
