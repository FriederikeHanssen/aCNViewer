#
# Python Dockerfile
#
# https://github.com/dockerfile/python
#

# Pull base image.
FROM nfcore/base:1.7

COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
#ENV PATH /opt/conda/envs/nf-core-bamtofastq-1.0dev/bin:$PATH


#ENV DEBIAN_FRONTEND noninteractive
#ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN \
  echo "tzdata tzdata/Areas select Europe\ntzdata tzdata/Zones/Europe select Berlin" > tz.txt && debconf-set-selections tz.txt


# Define working directory.
WORKDIR /data
RUN \
  git clone https://github.com/FriederikeHanssen/aCNViewer.git
RUN \
   wget https://www.cng.fr/genodata/pub/LIVER/aCNViewer_DATA.tar.gz
RUN \
  tar -xzf aCNViewer_DATA.tar.gz && rm aCNViewer_DATA.tar.gz

RUN \
  cd aCNViewer_DATA/bin/GISTIC_2.0.23/MCR_Installer && ./install -mode silent -agreeToLicense yes -destinationFolder /data/aCNViewer_DATA/bin/GISTIC_2.0.23/MCR_ROOT
ENV LD_LIBRARY_PATH="/data/aCNViewer_DATA/bin/GISTIC_2.0.23/MCR_ROOT/v83/runtime/glnxa64:/data/aCNViewer_DATA/bin/GISTIC_2.0.23/MCR_ROOT/v83/bin/glnxa64:/data/aCNViewer_DATA/bin/GISTIC_2.0.23/MCR_ROOT/v83/sys/os/glnxa64:${LD_LIBRARY_PATH}"
ENV XAPPLRESDIR=/data/aCNViewer_DATA/bin/GISTIC_2.0.23/MCR_ROOT/v83/X11/app-defaults

# Define default command.
ENTRYPOINT ["python", "aCNViewer/code/aCNViewer.py"]