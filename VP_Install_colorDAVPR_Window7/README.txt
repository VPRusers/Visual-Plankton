
INSTALLATION INSTRUCTIONS for  Visual Plankton (version 4.1)
(tested on Windows 2000 and Windows xp and for Matlab version up to 7.2)


To install, carefully follow these steps in order:


1) Install Matlab on c: taking the defaults.

2) In the VPR_files folder on this Installation CD: 
   Copy startup.m to c:\$MATLABPATH$\work (you may need to create this directory if it doesn't exist)
   Copy the folder usermfiles to c:\$MATLABPATH$\toolbox, where 
      $MATLABPATH$ is the path to matlab, eg., MATLAB6p5, MATLAB704, MATLAB\R2006a
   Copy the folder plgui to c:\  using windows explorer and
      If necessary, UNcheck READONLY attribute (recursively; 
                    usually only necessary when installing from CDROM).
   Drag the Visual Plankton shortcut icon to the Quick Launch Toolbar or Desktop
   Right click this shortcut and choose properties. 
     In the target window enter the correct path for your version of matlab.
     Also change the path in the "start in" window for your version of matlab.

3) Install Irfanview or other thumbnail image viewing program, taking defaults.

4) Install the version of cygwin provide here by double-clicking setup.exe in the cygwin_install_files folder (using windows explorer) and take the defaults. Then copy cat.exe, cp.exe, cygintl.dll, cygwin1.dll, cygz.dll, ls.exe, and wc.exe from c:\cygwin\bin  to c:\WINNT\system32 (for w2k) or c:\windows\system32 (for wxp).  [Note that this is an older version of cygwin and if you install the latest version of cygwin from the web, you will need to copy additional and/or different files from c:\cygwin\bin to the windows system32 folder, e.g., cygiconv-2.dll, cygintl-1.dll, cygintl-2.dll, cygintl-3.dll]

5) Install the version of RAMDisk Utility provided here by double-clicking on the Dataram RAMDisk installer in the dataram_RAMDisk_install_files folder (using windows explorer) and take the defaults.

5) Create a data folder e.g., c:\data\cruisename, to hold the processed cruise data

You then can run Visual Plankton by clicking on the Visual Plankton shortcut.


License Information:  The Visual Plankton program is freeware and can be used freely for non-profit purposes.

