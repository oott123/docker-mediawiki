#!/bin/bash
# Put the MediaWiki installation path on the line below
IP=/var/www/html
RJ=$IP/maintenance/runJobs.php

echo Started.
while true; do
        # Job types that need to be run ASAP mo matter how many of them are in the queue
        # Those jobs should be very "cheap" to run
        php $RJ --type="enotifNotify"
        php $RJ --type="htmlCacheUpdate" --maxjobs=50
        # Everything else, limit the number of jobs on each batch
        # The --wait parameter will pause the execution here until new jobs are added,
        # to avoid running the loop without anything to do
        php $RJ --wait --maxjobs=10
        # Wait some seconds to let the CPU do other things, like handling web requests, etc
        echo Waiting for 10 seconds...
        sleep 10
done
