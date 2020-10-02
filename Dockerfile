FROM nfcore/base:1.7
#Use base image 1.7 because it runs with miniconda not miniconda3 incase I run into python problems
LABEL authors="Friederike Hanssen" \
      description="Docker image containing all software requirements for the nf-core/babysarek pipeline"

# Install the conda environment
COPY environment.yml /
RUN conda env create --quiet -f /environment.yml python=2.7 && conda clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/fhanssen-acnviewer-1.0dev/bin:$PATH
SHELL ["conda", "run", "-n", "fhanssen-acnviewer-1.0dev", "/bin/bash", "-c"]

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name fhanssen-acnviewer-1.0dev > fhanssen-acnviewer-1.0dev.yml

# Instruct R processes to use these empty files instead of clashing with a local version
#RUN touch .Rprofile
#RUN touch .Renviron

# Define working directory.
WORKDIR /data

# Although ADD and COPY are functionally similar, 
#generally speaking, COPY is preferred. That’s because it’s 
#more transparent than ADD. COPY only supports the basic copying of 
#local files into the container, while ADD has some features 
#(like local-only tar extraction and remote URL support) that are 
#not immediately obvious. Consequently, the best use for ADD is 
#local tar file auto-extraction into the image, 
#as in ADD rootfs.tar.xz /.
ADD aCNViewer_DATA.tar.gz /data/.

RUN \
  git clone https://github.com/FriederikeHanssen/aCNViewer.git 
  # --branch v2.2

RUN \
  cd /data/aCNViewer_DATA/bin/GISTIC_2.0.23/MCR_Installer && ./install -mode silent -agreeToLicense yes -destinationFolder /data/aCNViewer_DATA/bin/GISTIC_2.0.23/MCR_ROOT

ENV LD_LIBRARY_PATH="/data/aCNViewer_DATA/bin/GISTIC_2.0.23/MCR_ROOT/v83/runtime/glnxa64:/data/aCNViewer_DATA/bin/GISTIC_2.0.23/MCR_ROOT/v83/bin/glnxa64:/data/aCNViewer_DATA/bin/GISTIC_2.0.23/MCR_ROOT/v83/sys/os/glnxa64:${LD_LIBRARY_PATH}"

ENV XAPPLRESDIR=/data/aCNViewer_DATA/bin/GISTIC_2.0.23/MCR_ROOT/v83/X11/app-defaults

ENTRYPOINT ["conda", "run", "-n", "fhanssen-acnviewer-1.0dev"]
#, "python2"] 
#, "src/server.py"]