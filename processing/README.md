This container is designed to host the following screen sessions:

- `offline_processing`
- `benchmarking`
- `enqueue_processing`
- `enqueue_production`

## REQUIREMENTS

The following must be mounted in (_only_ if using Docker)

- ~/.globus containing valid usercert.pem and userkey.pem
- ~/data-flow
- /cvmfs

It containers:

- CentOS 7
- Python 2.7 / Python 3 with virtualenv for both
- Ganga 7.1.9
- DIRAC client v7r1p26

The GFAL utilities are accessed via CVMFS which will be mounted in, so no need to install in the container. Specifically, they are made available by sourcing the Centos7 UI here:
`/cvmfs/grid.cern.ch/centos7-ui-preview-v04/etc/profile.d/setup-c7-ui-example.sh`
