# r-tetrad

This is a proposed novel wrapping in R of the algorithms in the Tetrad project, https://github.com/cmu-phil/tetrad, using R-Java. This removes the need for the user to install anything but R.

Some algorithms have already been included as of 2024-09-05. Finishing up the rest should fairly quick once the idea has been worked out.

The idea is to reproduce the functionality of [TetradSearch.py in the py-tetrad project](https://github.com/cmu-phil/py-tetrad/blob/main/pytetrad/tools/TetradSearch.py) using [rJava](https://rdrr.io/cran/rJava/man/), without requiring the user to install Python or even to install Java themselves. That wrapping of Tetrad required that the user install both Java and Python themselves and coordinate them manually with R. We got extensive user feedback about that from R users, who almost universally expressed a preference that installing Python and Java in addition to R for R code, and manually coordinating them with R, was suboptimal. In this project, we eliminate the need to install Python or even Java; only R is needed; the scripts handle the connection to Java internally so that this is transparent to the user.

This will hopefully provide more up-to-date and more easily maintainable access to the current Tetrad library code than our previous Tetrad rJava project, [r-causal](https://github.com/bd2kccd/r-causal). Also, keeping this project up to date should be much easier than with r-causal, so it's less likely to get out of date. Mostly it's a matter of updating the URLs for the Java JDK and Tetrad jar downloads, as these jars are not stored on this GitHub site and to not need to be updated there. Any new requrested functionality can be added as well.

Comments are always welcome. After the initial implementation is completed, we will welcome updates from the community through the pull request functionality in GitHub (which has yet to be set up).

# Install

This code can be used in R or RStudio. It has been tested on Mac aarch64 and Windows x64 but should also work on Mac x64 and Linux. Additional platforms are available by mucking with the code. We used RStudio 2023.06.1 Build 524 with R version 4.3.2 (2023-10-31) to test it on Mac aarch64. Our use of Java and Tetrad are hard-coded (though the code can be mucked with). These are downloaded programmatically by our R scripts and stored locally, so occurrences of the Java JDK or Tetrad jar located elsewhere one one's computer are ignored. The version of the Java JDK we use is Corretto 21; the version of the Tetrad jar we use us 7.6.5. These will be updated as needed, and our code will be kept consistent with the choices used.

An internet connection is required in order to use this code, to download the above jars. Once the jars have been downloaded, an internet connection is no longer needed. These jars can be installed manually if an internet connection is not available.

The procedure for running it in RStudio is as follows.

* Clone this repository.
* Open RStudio.
* From the File menu, select "New Project".
* Click "Existing Directory".
* Click Browse and browse to the director for the repository you just cloned. Click "Open" and click "Create Project".
* In the lower right-hand corner of RStudio, in the Files tab, click "main.R".
* Click in the upper left-hand panel and type control-A to select all contents.
* Click "Run".

The required Java JDK and Tetrad jar should be donwloaded and a sample Tetrad search run. The sample data is the NASA airfoil self noise data, which can be downloaded from https://github.com/cmu-phil/example-causal-datasets/tree/main/real/airfoil-self-noise/data.

# Description

We assume for now that the data is continuous and calculate a covaraince matrix of the data. The only score currently wrapped is SEM BIC and the only test currently wrapped is Fisher Z; these choices will be expanded and more general datasets allowed. The algorithms currently made available are PC, FGES, BOSS, FCI, BFCI, and LV-Lite. These options will expand. Currently very few parameters for these algorithms are passed in; these choices will expand.

Please see the main.R file for a description of how to use the scripts.

Once this code is more mature, we will make an R package from it. As a step in that direction, we've organized the code into package-like directories.

# Support

This work is supported by the Department of Philosophy of Carnegie Mellon University and by the Software Engineering Institute of Carnegie Mellon University, both in Pittsburgh, PA, USA.
