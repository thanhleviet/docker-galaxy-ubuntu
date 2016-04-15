#Base Image
FROM ubuntu:14.04
RUN apt-get update


#Install Python and dependencies
RUN apt-get install -y python python-pip
RUN apt-get install -y python-dev
RUN apt-get install -y zlib1g-dev
RUN pip install --upgrade pip

# Install PostgreSQL and dependencies
RUN apt-get install postgresql -y
RUN apt-get install git -y
RUN apt-get install mercurial -y

#Environment
ENV HOME=/home
ENV GALAXY_FOLDER=$HOME/galaxy
ENV PATH=$GALAXY_PATH:$PATH

WORKDIR $HOME
#Clone and install galaxy
RUN git clone https://github.com/galaxyproject/galaxy/

# RUN cd $GALAXY_FOLDER && git checkout -b master origin/master

COPY galaxy/galaxy.ini $GALAXY_FOLDER/config/galaxy.ini

WORKDIR $GALAXY_FOLDER

RUN git checkout -b master origin/master

########################################
# Configure
########################################
# Starting the server for the first time will download/create the dependent Python eggs, configuration files, etc.
RUN run.sh --daemon

EXPOSE 80

ENTRYPOINT ["run.sh"]

