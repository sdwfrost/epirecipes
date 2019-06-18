FROM sdwfrost/polyglot-base:latest

LABEL maintainer="Simon Frost <sdwfrost@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

USER jovyan

# Julia packages
RUN julia -e 'using Pkg;Pkg.update()' && \
    julia -e 'using Pkg;Pkg.add("Conda")' && \
    julia -e 'using Pkg;Pkg.add("CmdStan")' && \
    julia -e 'using Pkg;Pkg.add("CSV")' && \
    julia -e 'using Pkg;Pkg.add("DataFrames")' && \
    julia -e 'using Pkg;Pkg.add("DataFramesMeta")' && \
    julia -e 'using Pkg;Pkg.add("GR")' && \
    julia -e 'using Pkg;Pkg.add("GSL")' && \
    julia -e 'using Pkg;Pkg.add("Hiccup")' && \
    julia -e 'using Pkg;Pkg.add("Plots")' && \
    julia -e 'using Pkg;Pkg.add("DifferentialEquations")' && \
    julia -e 'using Pkg;Pkg.add("NamedArrays")' && \
    julia -e 'using Pkg;Pkg.add("RandomNumbers")' && \
    julia -e 'using Pkg;Pkg.add("PlotThemes")' && \
    julia -e 'using Pkg;Pkg.add("PyCall")' && \
    julia -e 'using Pkg;Pkg.add("PyPlot")' && \
    julia -e 'using Pkg;Pkg.add("RCall")' && \
    julia -e 'using Pkg;Pkg.add("SimJulia")' && \
    julia -e 'using Pkg;Pkg.add("StatPlots")' && \
    julia -e 'using Pkg;Pkg.add("SymPy")'

# Precompile Julia packages
RUN julia -e 'using Conda' && \
    julia -e 'using CmdStan' && \
    julia -e 'using CSV' && \
    julia -e 'using DataFrames' && \
    julia -e 'using DataFramesMeta' && \
    julia -e 'using GR' && \
    julia -e 'using GSL' && \
    julia -e 'using Hiccup' && \
    julia -e 'using Plots' && \
    julia -e 'using PlotThemes' && \
    julia -e 'using DifferentialEquations' && \
    julia -e 'using NamedArrays' && \
    julia -e 'using RandomNumbers' && \
    julia -e 'using PyCall' && \
    julia -e 'using PyPlot' && \
    julia -e 'using RCall' && \
    julia -e 'using SimJulia' && \
    julia -e 'using StatPlots' && \
    julia -e 'using SymPy'

# Python
RUN pip install --no-cache-dir \
    differint \
    EoN \
    mesa \
    networkx \
    pydstool \
    pygom \
    pygsl \
    pystan \
    salabim \
    simpy

# R
# Old rgeos
RUN R -e "devtools::install_version('rgeos', version = '0.3-28')"
RUN R -e "setRepositories(ind=1:2);install.packages(c(\
    'animation', \
    'ape', \
    'data.table', \
    'deSolve', \
    'devtools', \
    'ddeSolve', \
    'diffeqr', \
    'DSAIDE', \
    'ecostat', \
    'epimdr', \
    'EpiDynamics', \
    'EpiILM', \
    'EpiModel', \
    'fields', \
    'geosphere' \
    'ggforce', \
    'ggmap', \
    'ggplot2', \
    'GillespieSSA', \
    'git2r', \
    'gridExtra', \
    'FME', \
    'maptools', \
    'odeintr', \
    'PBSddesolve', \
    'plotly', \
    'plyr', \
    'pomp', \
    'raster', \
    'rbi', \
    'rgdal', \
    'rgeos', \
    'ReacTran', \
    'reticulate', \
    'Rcpp', \
    'rstan', \
    'scales', \
    'SDMTools', \
    'sf', \
    'simecol', \
    'SimInf', \
    'simmer', \
    'sp', \
    'spatstat', \
    'spdep', \
    'stpp', \
    'tweenr', \
    'XRJulia', \
    'XRPython'), dependencies=TRUE, clean=TRUE, repos='https://cran.microsoft.com/snapshot/2018-11-01')"

# Tweak compilation settings for R
RUN R -e 'dotR <- file.path(Sys.getenv("HOME"), ".R"); \
    if (!file.exists(dotR)) dir.create(dotR); \
    M <- file.path(dotR, ifelse(.Platform$OS.type == "windows", "Makevars.win", "Makevars")); \
    if (!file.exists(M)) file.create(M); \
    cat("\nCXX14FLAGS=-O3 -march=native -mtune=native", \
    if( grepl("^darwin", R.version$os)) "CXX14FLAGS += -arch x86_64 -ftemplate-depth-256" else \
    if (.Platform$OS.type == "windows") "CXX11FLAGS=-O3 -march=native -mtune=native" else \
    "CXX14FLAGS += -fPIC", \
    file = M, sep = "\n", append = TRUE);'

# Load Github packages
RUN R -e "devtools::install_github(c('mrc-ide/cinterpolate', 'richfitz/dde', 'mrc-ide/odin', 'thomasp85/gganimate', 'emvolz-phylodynamics/phydynR'),upgrade=FALSE)"

# Node
RUN npm install -g ode-rk4 @redfish/agentscript

# Go
## ODE
RUN mkdir -p ${GOPATH%:*}/src/github.com/sj14 && \
    cd ${GOPATH%:*}/src/github.com/sj14 && \
    git clone https://github.com/sj14/ode.git

# OCAML
RUN opam update && \
    yes 'Y' | opam upgrade && \
    yes 'Y' | opam install odepack && \
    yes 'Y' | opam install gsl

# Nim
RUN yes 'y' | nimble install nimpy && \
    yes 'y' | nimble install inim && \
    yes 'y' | nimble install arraymancer && \
    yes 'y' | nimble install neo
RUN cd /tmp && \
    git clone https://github.com/sdwfrost/distributions && \
    cd distributions && \
    yes 'y' | nimble install && \
    cd /tmp && \
    rm -rf distributions

