#!/bin/bash

# Launch the corresponding containers depending on which variables are set

## TODO
# - Add safety check to ensure we cant launch more than one instance of each container
#   - Do something like in launch_processing.sh - if [ podman ps | grep container_name ] etc...

#################
OFFLINE=false
BENCH=false
PROCESSING=false
PRODUCTION=false
#################

if [ "$OFFLINE" = true ]; then
    singularity instance start $HOME/containers/processing_container.sif offline_processing 
fi

if [ "$BENCH" = true ]; then
    singularity instance start $HOME/containers/processing_container.sif benchmarking
fi

if [ "$PROCESSING" = true ]; then
    singularity instance start $HOME/containers/processing_container.sif enqueue_processing
fi

if ["$PRODUCTION" = true ]; then
    singularity instance start $HOME/containers/processing_container.sif enqueue_production
fi
