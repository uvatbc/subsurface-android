# [Subsurface](https://subsurface-divelog.org/) for Android

The build steps for Subsurface require that the [source for Subsurface](https://github.com/Subsurface-divelog/subsurface.git) and the [source for libdivecomputer](https://github.com/Subsurface-divelog/libdc.git) are at the same level.   
This can be easily represented as a git repository with two submodules.   
This is that git repository.   

In addition to that, there is a Makefile that makes it easy to set up the sources, init the repositories and pull the standalone NDK as well.   
Also, the build steps themselves are in the Makefile.   
