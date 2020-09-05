# pvlib-benchmarks
Benchmark data for pvlib-python

## How to set up a new machine to run the pvlib benchmark suite

1) Clone the pvlib-python github repository:
   - `git clone https://github.com/pvlib/pvlib-python.git`

1) Clone this github repository:
   - `git clone https://github.com/pvlib-benchmarker/pvlib-benchmarks.git`

1) Create and activate a new conda environment:
   - `conda create -n pvlib-asv python=3.7`
   - `conda activate pvlib-asv`

1) Install airspeed velocity:
   - `pip install asv==0.4.2`

1) Install pvlib so that the benchmark files can be imported:
   - `pip install ./pvlib-python[all]`

1) In the `pvlib-benchmarks` repo, set the git user info:
   - `git config user.name 'pvlib-benchmarker'`
   - `git config user.email 'pvlib.benchmarker@gmail.com'`

1) Also configure the remote URL to use ssh so pushing results doesn't require
   you to enter your username/password:
   - `git remote set-url origin git+ssh://git@github.com/pvlib-benchmarker/pvlib-benchmarks.git`

1) Create an ssh key, register it with `ssh-add ...`, and configure it with GitHub.

1) Set the machine information:
   - `asv machine`

1) Validate and build environments (may take a couple minutes to run):
   - `asv check`

1) Do a dry benchmark run:
   - `asv dev`

1) Establish a benchmark history (the nightly job will always run whatever
   new commits haven't yet been run):
   - `asv run v0.6.0..v0.7.2`

1) Finally, enable the nightly job in whatever job scheduler you are using.
