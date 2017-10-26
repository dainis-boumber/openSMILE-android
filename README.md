 openSMILE port to Android by:

 Dainis Boumber and Weidong Shi
 I2C Lab
 University of Houston (UH)
 Houston, Texas, USA

 Original openSMILE authors:
 
  - open Speech and Music Interpretation by Large-space Extraction -
  Copyright (C) 2008-2010  Florian Eyben, Martin Woellmer, Bjoern Schuller
  
  Institute for Human-Machine Communication
  Technische Universitaet Muenchen (TUM)
  D-80333 Munich, Germany

 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details (file: COPYING).
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 **********************************************************************************
 
 OVERVIEW

 This is a version of openSMILE 1.0.1, modified to run on Android platform and 
 ARM architecture. Two versions of statically linked, ready-to-use binaries
 are provided in bin directory. Both are compatible with android-8, armeabi. If you
 desire something different, instructions on how to compile your own binaries follow.
 As it stands, these instructions are only applicable to linux.
 
 INSTRUCTIONS

 Before proceeding, you must at the very least be able to compile, install and use the
 original openSMILE. Furthermore, although the scripts provided do all the work, you 
 must understand that the directory structure and contents of Android NDK are subject 
 to change. It is likely that you may need to modify things. Thus, basic understanding
 of make files, autoconf, and a few other things are necessary. Finally, you need be 
 somewhat familiar with Android NDK.

 First of all, the install scripts rely on NDK being present and being in the same 
 directory. They are written for android-ndk-r8e. If your version is different, you must
 either get r8e or edit the scripts, in case the directory structure is different (if
 there are compilation or configuration errors, that is the most likely cause). 

 There are two scripts you need to know about: buildAndroidARM-gnustl.sh and 
 buildAndroidARM-stlport.sh They are virtually identical, but one compiles against gnustl, and
 the other against stlport, which are different implementations of stl on Android. Their
 main difference is licensing, with gnustl being under GPL and stlport being under free license.
 Since openSMILE is under GPL anyway, and gnustl is the one with more support, we shall from 
 now on assume you are using it. The reason stlport is included is that if you encounter a 
 bug in gnustl (not unheard of), you can try the other.

 To compile, run script in shell followed by platform followed by optional config arguments:

 $ sudo sh buildAndroidARM-gnustl.sh android-8

 This will create a SMILExtract binary in the opensmile directory. 

 HOW IT WORKS

 If you want to modify things, here is a basic idea of how this works and what we did. 
 The shell script runs custom config, which edits the original make file. This config uses pre-built
 android toolchain. It targets custom android c and c++ compiler, as well as libraries and other 
 things provided by the NDK. 

 The source code is slightly modified. There were some issues with non-standard functions, which
 had to be re-implemented. Another problem is the fact that many variables in openSMILE code start 
 with a _ which is normally reserved for system-defined things. This causes a number of conflicts.
 There are also problems with casting and other code which is not 100% standard compliant. 

 If you wish to create your own implementation, we advise to run run pre-process.py first. Also,
 use our implementation of getline() - senguard_getline(), located in senguard.h Overall, the original
 openSMILE code is very well written and portable, and can be changed to run on almost any platform
 in a matter of hours.

 POSSIBLE ISSUES

 Compiler errors are usually an indication that some includes are not found. In the worst case, you
 may need to edit the source code a bit. Linker errors indicate that some libraries are not found.
 Look at the shell script and fix it. Many errors of all kinds probably mean your version of NDK
 is not r8e or not in the same directory as openSMILE.

 The functionality of this library is limited. Only static compilation have been tested (so no plugins), 
 and only the functionality required by our project (mfcc and other feature extraction) alhtough
 I do not see why you could not turn this into a full-fledged port with 100% of the features supported.

 SUPPORT

 This port was done as a part of SenGuard project. It is provided "as is" and support is provided on my
 own free time, so do not rely on it. However, ff you have questions or need help, feel free to e-mail:
 Dainis Boumber - dboumber@uh.edu 
