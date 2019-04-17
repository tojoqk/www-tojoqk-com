#!/bin/sh

raco pkg install -n www-tojoqk-com --deps search-auto
raco exe --orig-exe -o bootstrap serverless.yml
