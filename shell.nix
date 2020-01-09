let
  jupyter = import (builtins.fetchGit {
   url = https://github.com/tweag/jupyterWith;
    rev = "";
  }) {};

  iPython = jupyter.kernels.iPythonWith {
    name = "python";
    packages = p: with p; [
      plotly
      numpy
      pandas
      jupytext
      matplotlib
      scikitlearn
      seaborn
      scipy
      future
      ipywidgets
      scikitimage
      tzlocal
      simplegeneric
      pprintpp
    ];
  };

  iR = jupyter.kernels.juniperWith {
    name = "R";
    packages = p: with p; [
       mlbench
       arules
       tidyverse
       ggplot2
       dplyr
    ];
  };

  iHaskell = jupyter.kernels.iHaskellWith {
    name = "haskell";
    packages = p: with p; [ hvega formatting ];
  };

  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iPython iHaskell iR];
   #   directory = jupyter.mkDirectoryWith {
  #      extensions = [
#         "jupyterlab-jupytext"
 #       ];
    #  };
    };
    pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    name = "scratchwork";
    buildInputs = with pkgs; [
      vscode
#       jupyterEnvironment
       python37
       python37Packages.pandas
       python37Packages.numpy
       python37Packages.matplotlib
       #python37Packages.sqlite
       python37Packages.notebook
       python37Packages.ipython
       python37Packages.jupytext
       python37Packages.scikitlearn
       python37Packages.seaborn
       python37Packages.scipy
       python37Packages.plotly
       python37Packages.ipywidgets
       python37Packages.future
       python37Packages.scikitimage
       #Todo Package graphlab
       python37Packages.tzlocal
       rstudio
       python37Packages.simplegeneric
       R
       rPackages.ElemStatLearn
       rPackages.mlbench
       rPackages.magick
       rPackages.foreign
       rPackages.data_table
       rPackages.magrittr
       rPackages.lobstr
       rPackages.memery
       rPackages.lubridate
       rPackages.stringr
       rPackages.abind
       rPackages.foreign
       rPackages.downloader
       rPackages.memoise
       rPackages.lattice
       rPackages.microbenchmark
       rPackages.arules
       rPackages.tidyverse
       rPackages.devtools
       rPackages.pander
       rPackages.Rcpp
       rPackages.RNHANES
       rPackages.reticulate
       rPackages.humaniformat
       rPackages.httr
       rPackages.profvis
       rPackages.pryr
       rPackages.tswge
       rPackages.RcppArmadillo
       rPackages.benchmarkme
       python37Packages.pprintpp
       rPackages.jsonlite
       openblas
       julia
    ];

    # First important part: Add here the dependencies the packages you want to install need
   # LD_LIBRARY_PATH="${glfw}/lib:${mesa}/lib:${freetype}/lib:${imagemagick}/lib:${portaudio}/lib:${libsndfile.out}/lib:${libxml2.out}/lib:${expat.out}/lib:${cairo.out}/lib:${pango.out}/lib:${gettext.out}/lib:${glib.out}/lib:${gtk3.out}/lib:${gdk_pixbuf.out}/lib:${cairo.out}:${tk.out}/lib:${tcl.out}/lib:${pkgs.sqlite.out}/lib:${pkgs.zlib}/lib";
   shellHook = ''
     echo "#!/usr/bin/env Rscript" > libs.R
     echo "devtools::install_github('csgillespie/efficient', build_vignettes=TRUE)" >> libs.R
     Rscript libs.R
      '';
} 
