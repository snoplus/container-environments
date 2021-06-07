FROM centos:7.9.2009

LABEL maintainer="Jamie Rajewski <jrajewsk@ualberta.ca>"
SHELL ["/bin/bash", "-c"]

WORKDIR /home/snoprod

# Update base packages
RUN yum update -y
# Useful packages and requirements to install python 2.7.18 etc
RUN yum install -y gcc openssl-devel bzip2-devel wget make less

# Install Python 2
RUN wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
RUN tar xzf Python-2.7.18.tgz
WORKDIR /home/snoprod/Python-2.7.18
RUN ./configure --enable-optimizations
RUN make altinstall
# Install pip2
RUN curl "https://bootstrap.pypa.io/pip/2.7/get-pip.py" -o "get-pip.py"
RUN python2.7 get-pip.py
RUN python2.7 -m pip install virtualenv
WORKDIR /home/snoprod
RUN rm -rf /home/snoprod/Python-2.7.18*

# Install Python 3 and pip3
RUN yum install -y python3-devel python3-pip
RUN python3 -m pip install virtualenv

# Install Ganga with a virtual environment
RUN python2.7 -m virtualenv ganga-7.1.9
RUN source ganga-7.1.9/bin/activate 
RUN python -m pip install ganga==7.1.9 && deactivate

# Install DIRAC client according to docs:
# https://www.gridpp.ac.uk/wiki/Quick_Guide_to_Dirac#Dirac_client_installation
RUN mkdir dirac_ui
WORKDIR /home/snoprod/dirac_ui
RUN wget --no-check-certificate -np -O dirac-install https://raw.githubusercontent.com/DIRACGrid/DIRAC/integration/src/DIRAC/Core/scripts/dirac-install.py
RUN chmod u+x dirac-install
RUN ./dirac-install -r v7r1p26
# The proxy still needs to be started, do so in the container

# Clean yum cache
RUN yum clean all