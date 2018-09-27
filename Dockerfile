FROM sdwfrost/epirecipes-base:latest

LABEL maintainer="Simon Frost <sdwfrost@gmail.com>"

USER root

ENV DEBIAN_FRONTEND noninteractive

USER ${NB_USER}

# Python
RUN pip install --no-cache-dir \
    EoN \
    pydstool \
    pygom \
    salabim \
    simpy && \
    fix-permissions /home/$NB_USER /usr/local/lib/python3.6

# R packages
RUN R -e "setRepositories(ind=1:2);install.packages(c(\
    'adaptivetau', \
    'boot', \
    'cOde', \
    'deSolve',\
    'devtools', \
    'ddeSolve', \
    'GillespieSSA', \
    'git2r', \
    'ggplot2', \
    'FME', \
    'KernSmooth', \
    'magrittr', \
    'odeintr', \
    'PBSddesolve', \
    'plotly', \
    'pomp', \
    'pracma', \
    'rbi', \
    'ReacTran', \
    'reticulate', \
    'rmarkdown', \
    'rodeo', \
    'Rcpp', \
    'rpgm', \
    'simecol', \
    'simmer', \
    'spatial'), dependencies=TRUE, clean=TRUE, repos='https://cran.microsoft.com/snapshot/2018-08-14')"
RUN R -e "devtools::install_github('mrc-ide/odin',upgrade=FALSE)"

# Julia packages
# Takes a long time to download, so spread over multiple commands
RUN julia -e 'using Pkg;Pkg.update()'
RUN julia -e 'using Pkg;Pkg.add("DataFrames")'
RUN julia -e 'using Pkg;Pkg.add("GR")'
RUN julia -e 'using Pkg;Pkg.add("Plots")'
RUN julia -e 'using Pkg;Pkg.add("DifferentialEquations")'
RUN julia -e 'using Pkg;Pkg.add("NamedArrays")'
RUN julia -e 'using Pkg;Pkg.add("RandomNumbers")'
RUN julia -e 'using Pkg;Pkg.add("PyCall")'
RUN julia -e 'using Pkg;Pkg.add("PyPlot")'
RUN julia -e 'using Pkg;Pkg.add("RCall")'
RUN julia -e 'using Pkg;Pkg.add("SymPy")'

# Precompile Julia packages \
RUN julia -e 'using DataFrames' && \
    julia -e 'using GR' && \
    julia -e 'using Plots' && \
    julia -e 'using DifferentialEquations' && \
    julia -e 'using NamedArrays' && \
    julia -e 'using RandomNumbers' && \
    julia -e 'using PyCall' && \
    julia -e 'using PyPlot' && \
    julia -e 'using RCall' && \
    julia -e 'using SymPy' && \
    rm -rf $HOME/.local && \
    fix-permissions $JULIA_PKGDIR

RUN npm install -g ode-rk4 \
    plotly-notebook-js
