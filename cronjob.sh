#!/bin/bash

conda activate pvlib-asv

# The directory containing the pvlib-python and pvlib-benchmarks repos
ROOTDIR='~'

cd $ROOTDIR/pvlib-python
git checkout master
git pull origin master

# install pvlib/master, not to benchmark it, but to supply whatever imports
# are needed to make the benchmark files importable during discovery
pip install .[all]

cd $ROOTDIR/pvlib-benchmarks
MACHINE=`python -c "from asv.machine import Machine; print(Machine.load('.asv-machine.json').machine)"`

echo "asv: "`asv --version`
echo "Machine: "$MACHINE

asv run NEW

git add results
git commit -m "Nightly ASV results ($MACHINE)"

git push origin master
asv gh-pages

asv run
