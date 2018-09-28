FROM sdwfrost/polyglot-base:latest

LABEL maintainer="Simon Frost <sdwfrost@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

USER jovyan

# Julia packages
# Takes a long time to download, so spread over multiple commands
RUN julia -e 'Pkg.update()'
RUN julia -e 'Pkg.add("Conda")'
RUN julia -e 'Pkg.add("DataFrames")'
RUN julia -e 'Pkg.add("Gillespie")'
RUN julia -e 'Pkg.add("GR")'
RUN julia -e 'Pkg.add("Hiccup")'
RUN julia -e 'Pkg.add("Plots")'
RUN julia -e 'Pkg.add("DifferentialEquations")'
RUN julia -e 'Pkg.add("NamedArrays")'
RUN julia -e 'Pkg.add("RandomNumbers")'
RUN julia -e 'Pkg.add("PyCall")'
RUN julia -e 'Pkg.add("PyPlot")'
RUN julia -e 'Pkg.add("RCall")'
RUN julia -e 'Pkg.add("StatPlots")'
RUN julia -e 'Pkg.add("SymPy")'

# Precompile Julia packages
RUN julia -e 'using Conda'
RUN julia -e 'using DataFrames'
RUN julia -e 'using Gillespie'
RUN julia -e 'using GR'
RUN julia -e 'using Hiccup'
RUN julia -e 'using Plots'
RUN julia -e 'using DifferentialEquations'
RUN julia -e 'using NamedArrays'
RUN julia -e 'using RandomNumbers'
RUN julia -e 'ENV["PYTHON"]="";using PyCall'
RUN julia -e 'ENV["PYTHON"]="";using PyPlot'
RUN julia -e 'using RCall'
RUN julia -e 'using StatPlots'
RUN julia -e 'using SymPy'

# Python
RUN pip install --no-cache-dir \
    EoN \
    pydstool \
    pygom \
    salabim \
    simpy

RUN R -e "setRepositories(ind=1:2);install.packages(c(\
    'deSolve', \
    'devtools', \
    'ddeSolve', \
    'ggplot2', \
    'GillespieSSA', \
    'git2r', \
    'FME', \
    'odeintr', \
    'PBSddesolve', \
    'plotly', \
    'pomp', \
    'rbi', \
    'ReacTran', \
    'reticulate', \
    'Rcpp', \
    'simecol'), dependencies=TRUE, clean=TRUE, repos='https://cran.microsoft.com/snapshot/2018-09-01')"
RUN R -e "devtools::install_github('mrc-ide/odin',upgrade=FALSE)"

RUN npm install -g ode-rk4 \
    plotly-notebook-js

