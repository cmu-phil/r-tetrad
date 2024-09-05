# r-tetrad

We are working on a new wrapping of the algorithms in the Tetrad project, https://github.com/cmu-phil/tetrad, using R-Java. The idea is to remove the need for the user to install anything but R, so the user will not need to install Python or Java. The jars for the Java JDK used and the Tetrad jar used will be downloaded programmatically from the web and configured for use in the project.

Initial code has been done for some algorithms as of 2024-09-05.

# Install

This code can be used in R or RStudio. It has been tested on Mac aarch64 and Windows x64 but should also work on Mac x64 and Linux. Additional platforms are available by mucking with the code.

The procedure for running it in RStudio is as follows.

* Clone this repositoy.
* Open RStudio.
* From the File menu, select "New Project".
* Click "Existing Directory".
* Click Browse and browse to the director for the repository you just cloned. Click "Open" and click "Create Project".
* In the lower right-hand corner of RStudio, in the Files tab, click "main.R".
* Click in the upper left-hand panel and type control-A to select all contents.
* Click "Run".

The required Java JDK and Tetrad jar should be donwloaded and a sample Tetrad search run. The sample data is the NASA airfoil self noise data, which can be downloaded from https://github.com/cmu-phil/example-causal-datasets/tree/main/real/airfoil-self-noise/data.

# Description

We assume for now that the data is continuous and calculate a covaraince matrix of the data. The only score currently wrapped is SEM BIC and the only test currently wrapped is Fisher Z; these choices will be expanded and more general datasets allowed. The algorithms currently made available are PC, FGES, BOSS, FCI, BFCI, and LV-Lite. These options will expand.

Please see the main.R file for a description of how to use the scripts.

Once this code is more mature, we will make an R package from it. As a step in that direction, we've organized the code into package-like directories.

We used RStudio 2023.06.1 Build 524 with R version 4.3.2 (2023-10-31) to test it on Mac aarch64.
