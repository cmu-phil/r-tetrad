# r-tetrad

This is a proposed still-experimental wrapping in R of the algorithms in the Tetrad project, https://github.com/cmu-phil/tetrad, using [rJava](https://rdrr.io/cran/rJava/man/) that removes the need for the user to install anything but R.

As of 2024-09-05, some algorithms have already been included. Once the idea has been worked out and debugged, finishing up the rest should be fairly quick.

We got user feedback about that from R users who expressed a preference that having the user install Python and Java themselves in addition to R for R code and manually coordinate them with R was suboptimal. In this project, we eliminate the need to install Python or even Java; only R is needed. The scripts handle the internal connection to Java so that this is transparent to the user. 

The initial goal is to reproduce the functionality of [TetradSearch.py in the py-tetrad project](https://github.com/cmu-phil/py-tetrad/blob/main/pytetrad/tools/TetradSearch.py) using rJava without requiring the user to install Python or even Java themselves. The TetradSearch.py class in py-tetrad is a model we can follow to create methods for our new R wrapping.

This will hopefully provide more up-to-date and more easily maintainable access to the current Tetrad library code than our previous Tetrad rJava project, [r-causal](https://github.com/bd2kccd/r-causal). Keeping this project up to date should be much easier than with r-causal, so it's less likely to get out of date. Mostly, it's a matter of updating the URLs for the Java JDK and Tetrad jar downloads, as these jars are not stored on this GitHub site and do not need to be updated there. Any new requested functionality can be added as well. (Tetrad has a lot of functionality that could be exposed with a little rJava work.)

Comments are always welcome. After the initial implementation, we will welcome updates from the community through the pull request functionality in GitHub (which has yet to be set up).

# Install

This code can be used in R or RStudio. We used RStudio 2023.06.1 Build 524 with R version 4.3.2 (2023-10-31) to test it on Mac aarch64. Our use of Java and Tetrad is hard-coded (though the code can be mucked with). These are downloaded programmatically by our R scripts and stored locally, so occurrences of the Java JDK or Tetrad jar located elsewhere on one's computer are ignored. The version of the Java JDK we use is Corretto 21; the version of the Tetrad jar is 7.6.5. These will be updated as needed, and our code will be consistent with the choices.

An internet connection is required to use this code to download the above jars. Once the jars have been downloaded, an internet connection is no longer needed. If an internet connection is unavailable, these jars can be installed manually.

The procedure for running it in RStudio is as follows.

* Clone this repository. A good way to do this is to install Git if you don't already have it and then type a git clone command in a terminal window.
    1. Install Git if you don't already have it
        ```
        https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
        ```
    1. Open a terminal window and use the cd command to move to a directory where you would like to clone the repository--e.g., `cd /Users/user`. Then type:
       ```
       git clone https://github.com/cmu-phil/r-tetrad
       cd r-tetrad
       ```
    1. The contents of the r-tetrad project should be in this directory; you can examine them.

* Then, in RStudio:
    1. Open RStudio.
    1. From the File menu, select "New Project".
    1. Click "Existing Directory".
    1. Click Browse and navigate to the "r-tetrad" directory you just cloned. Click "Open" and click "Create Project."
    1. In the lower right-hand corner of RStudio, in the Files tab "main.R". It's inside the "scripts" directory, so you may need to click on "scripts" first. This should place the contents of main.R in the upper-left-hand panel.
    1. Then click in the upper left-hand panel and select all its contents.
        1. On a Mac, type command-A.
        2. On Windows, type control-A.
    1. Click "Run".
        1. If the Run button is not visible, you may need to drag the center divider to the right to see it.

The required Java JDK and Tetrad jar should be downloaded, and a sample Tetrad search should be run. The sample data is the NASA airfoil self-noise data. This data is included in the package in the directory "data," but it can also be downloaded from https://github.com/cmu-phil/example-causal-datasets/tree/main/real/airfoil-self-noise/data.

This code has been tested on Mac (aarch64), Mac (Intel), and Windows 11, though in some cases software needed to be updated to recent versions. The versions used for Mac for testing were:

```
platform       aarch64-apple-darwin20      
arch           aarch64                     
os             darwin20                    
system         aarch64, darwin20           
status                                     
major          4                           
minor          3.2                         
year           2023                        
month          10                          
day            31                          
svn rev        85441                       
language       R                           
version.string R version 4.3.2 (2023-10-31)
nickname       Eye Holes
```

Once this code is more mature, we expect to create an R package from it so that it can be installed using the usual "install.packages()" and "library()" commands. We've organized the code into the expected package directories as a step in that direction.

# Discussion

Note that, like [JPype](https://jpype.readthedocs.io/en/latest/) for [Python](https://docs.python.org/3/), [rJava](https://rdrr.io/cran/rJava/man/) allows  access to arbitrary code in the Tetrad library for [R](https://www.rdocumentation.org/), though the access is lower-level and requires a bit more work to manage. But armed with just the [Tetrad Javadocs](https://www.phil.cmu.edu/tetrad-javadocs/7.6.5/), one can manage all access to the Tetrad jar oneself. So this project, like our [py-tetrad](https://github.com/cmu-phil/py-tetrad) and [rpy-tetrad](https://github.com/cmu-phil/py-tetrad/tree/main/pytetrad/R) projects, is in that sense merely a convenience to show how it can be done. Feel free to steal whatever you need from it for your own projects.

That said, working out the details for accessing Tetrad via rJava can be time-consuming and error-prone, and we don't think R users will generally want to do it. So, we will try to develop access to some main functionality in R that doesn't require intimate knowledge of how to do this. We aim to make running Tetrad code in R easy to the greatest extent possible; if you find this not to be so, please let us know.

We assume for now that the data is continuous and calculate a covariance matrix of the data. The only score currently wrapped is SEM BIC, and the only test currently wrapped is Fisher Z; these choices will be expanded, and more general datasets will be allowed. The currently available algorithms are PC, FGES, BOSS, FCI, BFCI, and LV-Lite. These options will expand. Currently very few parameters for these algorithms are passed in; these choices will expand.

Please see the main.R file for a description of how to use the scripts.

We will work to provide documentation, example scripts for the functions we provide, and unit tests.

# Support

This work is supported by the Department of Philosophy and the Software Engineering Institute of Carnegie Mellon University, both in Pittsburgh, PA, USA.
