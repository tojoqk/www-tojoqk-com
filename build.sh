#!/bin/sh
set -eu

raco pkg install -n www-tojoqk-com --deps search-auto
raco exe --orig-exe -o bootstrap serverless.yml
raco test -x -p www-tojoqk-com
