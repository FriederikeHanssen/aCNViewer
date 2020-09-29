FROM nfcore/base:1.10.2
#Use base image 1.7 because it runs with miniconda not miniconda3 incase I run into python problems
LABEL authors="Friederike Hanssen" \
      description="Docker image containing all software requirements for the nf-core/babysarek pipeline"

# Install the conda environment
COPY environment.yml /
RUN conda env create --quiet -f /environment.yml python=2.7 && conda clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/fhanssen-acnviewer-1.0dev/bin:$PATH

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name fhanssen-acnviewer-1.0dev > fhanssen-acnviewer-1.0dev.yml

# Instruct R processes to use these empty files instead of clashing with a local version
RUN touch .Rprofile
RUN touch .Renviron