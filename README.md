# pvlib-benchmarks
Benchmarking for [pvlib-python](https://github.com/pvlib/pvlib-python)

The benchmark timings are hosted on this repo's
[github pages](https://pvlib-benchmarker.github.io/pvlib-benchmarks/).

## Setting up a new nightly runner
The following commands should be executed in a Anaconda Prompt:

1) Navigate to your preferred directory for saving github repositories.

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

1) In the `pvlib-benchmarks` repo directory, set the git user info:
   - `git config user.name 'pvlib-benchmarker'`
   - `git config user.email 'pvlib.benchmarker@gmail.com'`
   - Note: it seems like `asv gh-pages` ignores the repo-level configuration,
     so it might be necessary to set these parameters globally (e.g. use
     `git config --global user.name 'pvlib-benchmarker'`).

1) Also configure the remote URL to use ssh so pushing results doesn't require
   you to enter your username/password:
   - `git remote set-url origin git+ssh://git@github.com/pvlib-benchmarker/pvlib-benchmarks.git`

1) Create an ssh key, register it with `ssh-add ...`, and configure it with GitHub.
   This is so the nightly job can push to GitHub without needing the user to
   authenticate manually.

1) Navigate to the 'benchmarks' folder in the cloned 'pvlib-python' repository.

1) Set the machine information:
   - `asv machine`

1) Validate and build environments (may take a couple minutes to run):
   - `asv check`

1) Do a quick test run to verify that things seem to be working:
   - `asv dev`

1) Establish a benchmark history, for example:
   - `asv run v0.6.0..v0.7.2`

1) Finally, enable the nightly job in whatever job scheduler you are using. A
   suitable starting point for a crontab entry might be:
   - ```0 0 * * * $HOME/pvlib-benchmarks/cronjob.sh > $HOME/logs/`date +\%Y-\%m-\%d`-cron.log 2>&1```

   If using systemd units, copy the files `pvlib_benchmarks.service` and `pvlib_benchmarks.timer`
   files to the `~/.config/systemd/user/` directory (create it if needed).  Useful commands:

   - `systemctl --user daemon-reload`
   - `systemctl --user list-timers`
   - `systemctl --user status pvlib_benchmarks.timer`
   - `systemctl --user start pvlib_benchmarks.timer`
   - `journalctl -xe`
