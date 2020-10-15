C same as mgridder except for use with uibugplot.m ,i.e. no input queries.
c  same as gridder except outputs two data files, one with the gridded
c  data and the other with the parameters used for gridding.
cc*********************************************************
       program gridder
c*
c
c      maps irregularly spaced data onto a rectangular grid using     
c      zgrid routine. allows for blanking of specified regions.
c
c      the format of the input random data file and blanking files 
c      are identical to those required by the grid program in surfer.
c
c      the format of the output grid file is also identical to that 
c      produced by the grid program in surfer.
c
c      -------------------------------------------------------------------
c             important note:  gridding should be performed in               
c                              x and y coordinates with the same           
c                              scale (say, kilometers).                    
c                             if x and y do not have the same scale
c                              (say, latitude and longitude), then the
c                              data should be tranformed prior to running
c                              this program or through a transform
c                              subroutine.
c      --------------------------------------------------------------------
c
c      inputs:  xll,yll,xur,xur  =  x,y values of lower left, upper
c                                    right corners of rectangle to be gridded.
c                dx,dy            =  x,y grid width
c                                    place.
c
c
c                cay             =   interpolation stiffness: (0 to infinity)
c                                    values near zero give laplacian interp,
c                                    with tent-pole-like behavior around data.
c                                    high values give spline interp, with
c                                    smoother data field, but with the 
c                                    possibility of spurious peaks.  a value
c                                    of 5 often works well.
c
c               nrng            =    range in grid intevals to search. if no 
c                                    is found within this range, the point is
c                                    blanked.
c
c                iblank          =   0  for no blanking
c                                =   1  for blanking
c
c                xp(i),yp(i),zp(i)=  arrays containing x,y location and
c                                    depth.  (input statement requires
c                                    one x,y,z point per line)
c
c    rich signell
c    10-1-88  
c*********************************************************************
c     npmax = maximum number of random data triplets
c     ntot = maximum number of elements in gridded array
c
      parameter(npmax=1000000,ntot=50000)
      dimension z(ntot),xp(npmax),yp(npmax),zarray(npmax,14),zp(npmax)
      common prefix
      common/zmask/xll,yll,xur,yur,dx,dy
      character*40 finp,fout1
      character*80 infile,fileout
c
      big=1.e35
      bigsurf=1.70141e38 
c     above value from original prog
c
c------------------------------------------
c     user specified information
c
c      write(6,*)'you should have a file of irregularly spaced data '
c data    write(6,*)'  which must contain one (x,y,z) triplet per line: '
c      call getfname(finp,'.dat')

c      write(6,1)
c1     format('    What is the name of your input file? ==>  '$)
c      write(6,*)'What is the name of your input file>'
      read(5,'(1A80)')infile
c      write(6,*)infile
      open(11,file=infile,status='old')

c      write(6,2)
c2     format('What is the name of the output file? ==>  '$)
c      write(6,*)'What is the name of the output file?'
      read(5,'(1A80)')fileout

c      open(11,file='bugtz.dat',status='old')
c	 write(6,*)'number of z points on each line: '
c      read(5,*)nz
      nz=1
c----------------------------------------------------
      xmin=big
      xmax=-big
      ymin=big
      ymax=-big
      do 35 i=1,npmax
          read(11,*,end=20)x,y,(zarray(i,iz),iz=1,nz)
          xp(i)=x
          yp(i)=y
          zp(i)=zarray(i,1)
c         call transform(x,y,xp(i),xp(i))
          xmin=min(xmin,xp(i))
          xmax=max(xmax,xp(i))
          ymin=min(ymin,yp(i))
          ymax=max(ymax,yp(i))
 35   continue
 20   npts=i-1
      write(6,121)xmin,xmax,ymin,ymax
121   format(' data limits: xmin,xmax,ymin,ymax=',/,4e12.4)
c      write(6,*)' enter grid limits xmin,xmax,ymin,ymax: '
c      read(5,*)xll,xur,yll,yur
      xll=xmin
      xur=xmax
      yll=ymin
      yur=ymax
c      write(6,*)' enter nx and ny: '
      read(5,*)nx,ny
      write(6,*)nx,ny
c     nx=31
c     ny=21
      dx=(xur-xll)/(nx-1)
      dy=(yur-yll)/(ny-1)
c      write(6,*)' enter dx and dy: '
c      read(5,*)dx,dy
c      nx=(xur-xll)/dx+1
c      ny=(yur-yll)/dx+1
      if(nx*ny.gt.ntot)then
         write(6,*)' too many matrix elements'
         stop
      endif
      xur=xll+(nx-1)*dx
      yur=yll+(ny-1)*dy
c      write(6,*)' a grid file will be output ... '
c      call getfname(fout1,'.grd')
      open(unit=9,file=fileout,status='unknown')
c      write(6,*)' ****** interpolation looseness selection **********'
c      write(6,*)' values near zero use laplacian interpolation (faithful) '
c      write(6,*)' values near infinity use spline interpolation (smooth)  '
c      write(6,*)' enter interpolation looseness (1-infinity): '
c      read(5,*)cay
      cay=3
c      cay=3
c     write(6,*)' enter search radius in number of grid intervals: '
c      read(5,*)nrng
      nrng=1
c      write(6,*)'blanking desired? (1 for yes, 0 for no): '
c      read(5,*)iblank
      iblank=0
      if(iblank.eq.1)then
         call blanking(z,nx,ny)
      endif
c
c       grid data using zgrid from ezplot contouring package
c
      nxsize=nx
      nysize=ntot/nxsize
      call zgrid(z,nxsize,nysize,nx,ny,xll,yll,dx,dy,xp,yp,
     &         zp,npts,cay,nrng)
      zmin=big
      zmax=-big
      do 91 j=1,ny
         nj=(j-1)*nx
         do 91 i=nj+1,nj+nx
            if(z(i).ge.big)then
              z(i)=-999
            else
              zmin=min(z(i),zmin)
              zmax=max(z(i),zmax)
           endif
 91   continue
c      write(9,'(a4)')'dsaa'
c      write(9,*)nx,ny
c      write(9,*)xll,xur
c      write(9,*)yll,yur
c      write(9,*)zmin,zmax
      do 94 j=1,ny   
          nj=(j-1)*nx
          write(9,'(3000e15.7,x)')(z(nj+i),i=1,nx)

94    continue
      stop
      end
c********************************************

      subroutine blanking(z,nx,ny)
c     reads in polygon data and calls blank to mask land 
      parameter(nbmax=2000,npolymax=50)
      common/ins/xbound(nbmax),ybound(nbmax),nbound
      dimension z(nx,ny)
      character*40 fname
c
       data nn/0/
       if(nn.eq.0)then
          write(6,*)'you should have a blanking file.... '
          call getfname(fname,'.bln')
          open(10,file=fname,status='old')
c-------- option to output transformed boundary file
c         write(6,*)' to output blanking/boundary file ... '
c         call getfname(fout2,'.bln')
c         open(unit=15,file=fout2,status='new')
       endif
       nn=1
       do 60 np=1,npolymax
c------ first record of boundary file contains number of points and 
c------ a flag for blanking inside or outside of polygon (1 to blank inside)
        read(10,*,end=900)nbound,index
        do 45 i=1,nbound
            read(10,*)x,y
            xbound(i)=x
            ybound(i)=y
c---------- option to transform input data
c           call transform(x,y,xbound(i),ybound(i))
 45     continue
c-----  write blanking file in transformed coordinates
c       write(15,*)nbound,index
c       write(15,'(2e14.6)')(xbound(i),ybound(i),i=1,nbound)
        call blank(z,nx,ny,xbound,ybound,nbound,index)
 60   continue    
 900  return
      end

      subroutine blank(z,nx,ny,xbound,ybound,nbound,index)
c     uses subroutine inside to blank polygons
c     if index is 1, blank inside polygons
c     if index is 0, blank outside polygons
      common/zmask/xll,yll,xur,yur,dx,dy
      dimension z(nx,ny),xbound(nbound),ybound(nbound)
      zbig=1.e35
      ind=999
      do 20 i=1,nx
            xz=xll+(i-1)*dx
            do 10 j=1,ny
               yz=yll+(j-1)*dy
c              if grid point already blanked, skip to next point
               if (z(i,j).ne.zbig)then
                  call inside(xz,yz,xbound,ybound,nbound,ind)
c                 ind=1 if point is inside
                  if(index.eq.1)then
                    z(i,j)=zbig*ind
                  else
                    z(i,j)=zbig*(1-ind)
                  endif
               endif
  10        continue
  20  continue
      return
      end
      subroutine transform(rlon,rlat,xp,yp)
c     transforms latitude, longitude input data into kilometers from a 
c     given reference point.
c
c     
      data nn/0/
      if(nn.eq.0)then
        degrad=acos(-1.)/180.
c   reference point from which to measure distance in kilometers
        rlat0=41.5
        rlon0=-70.75
        rearth=6367.5
c   rotation of rotdeg degrees about the origin (xorg,yorg)
        rotdeg=0.
        rot=rotdeg*degrad
        xorg=0.
        yorg=0.
      endif
      nn=1
c-----conversion to kilometers
      xp=rearth*cos(degrad*rlat)*degrad*(rlon-rlon0)
      yp=rearth*degrad*(rlat-rlat0)
c-----coordinate rotation-----------
      r=sqrt((xp-xorg)**2.+(yp-yorg)**2.)
      th=atan2(yp,xp)
      th=th-rot
      xp=r*cos(th)+xorg
      yp=r*sin(th)+yorg
      return
      end

      subroutine zgrid(z,nxsize,nysize,nx,ny,x1,y1,dx,dy,xp,yp,
     &   zp,n,cayin,nrng)               
c====================================================================           
c                                                                   i           
c     sets up square grid for contouring , given arbitrarily placed i           
c     data points. laplace interrolation is used.                   i           
c     the method used here was lifted directly from notes left by   i           
c     mr ian crain formerly with the comp.sc ence iv.               i           
c     info on relaxation soln of laplace eqn supplied by dr t murty.i           
c     fortran ii  oceanography/emr   dec/68    jdt                  i           
c                                                                   i           
c     z = 2-d array of hgts to be set up. points outside region to  i           
c     be contoured should be initialized to 10**35. you might set   i           
c     the rest of z to 0.0                                          i           
c     nxsize,nysize = dimensioned size of z(i,j) in main program    i
c     nx,ny = size of z(i,j) actually used                          i
c     x1,y1 = coordinates of z(1,1)                                 i           
c     dx,dy = x and y increments.                                   i           
c     xp,yp,zp = arrays giving position and hgt of each data point. i           
c     n = size of arrays xp,yp and zp.                              i           
c                                                                   i           
c     modification feb,69 to get smoother results a portion of the  i           
c     beam eqn was added to the laplace eqn  iving                  i           
c     delta2x(z)+delta2y(z) - k(delta4x(z)+delta4y(z)) = 0.         i           
c     cayin = k = amount of spline eqn (between 0 and inf.)         i           
c     k=0 gives pure laplace solution. k=inf. gives pure spline sol.i           
c     nrng  all grid points more than nrng grid spaces from the     i           
c     closest data point are set undefined (10**35).                i           
c                                                                   i           
c====================================================================           
c                                                                               
      dimension z(nxsize,ny)                                                      
      dimension imnew(1000)                                                      
      dimension xp(2),yp(2),zp(2)                                               
c      write(6,10)                                                               
c   10 format(/// 17h subroutine zgrid / )                                       
      big=.9e35                                                                 
      cay=cayin                                                                 
c                                                                               
c     get zbase which will make all zp values positive by at least              
c     .25(zmax-zmin) and fill in grid with zeros.                               
c                                                                               
      zmin=zp(1)                                                                
      zmax=zp(1)                                                                
      do 20 k=2,n                                                               
        zmin=min(zp(k),zmin)
        zmax=max(zp(k),zmax)
   20 continue                                                                  
      zrange=zmax-zmin                                                          
      zbase=-zmin+.25*zrange                                                    
      zul=zbase+zmax                                                            
      zul20=zul*20.                                                             
      zul400=zul*400.                                                           
      do 40 i=1,nx                                                              
      do 40 j=1,ny                                                              
        if(z(i,j).lt.big) z(i,j)=0.0
   40 continue                                                                  
c                                                                               
c     affix each point zp to nearest grid pt. take avg if more than             
c     one near pt. add zbase plus 10*zrange and make negative.                  
c     initially set each unset grid pt to value of nearest known pt             
c                                                                               
      do 110 k=1,n                                                              
      i=(xp(k)-x1)/dx+1.5                                                       
      if(i*(nx+1-i))70,70,60                                                    
   60 j=(yp(k)-y1)/dy+1.5                                                       
      if(j*(ny+1-j))70,70,90                                                    
70    write(6,80) k,xp(k),yp(k),zp(k)                                           
80    format(1x, 29hpoint out of range k,x,y,z = ,i5,3e15.4)                     
      go to 110                                                                 
   90 if(z(i,j)-zul400)100,110,110                                              
  100 z(i,j)=z(i,j)+zp(k)+zbase+zul20                                           
  110 continue                                                                  
c                                                                               
      npg=0                                                                     
      do 150 i=1,nx                                                             
      do 150 j=1,ny                                                             
      if(z(i,j)-big)130,150,150                                                 
  130 nij=z(i,j)/zul20                                                          
      if(nij)145,145,140                                                        
  140 z(i,j)=-z(i,j)/nij+zul20 -10.*zrange                                      
      go to 150                                                                 
  145 z(i,j)=-1.e35                                                             
      npg=npg+1                                                                 
  150 continue                                                                  
c                                                                               
      do 199 iter=1,nrng                                                        
      nnew=0                                                                    
      do 197 i=1,nx                                                             
      do 197 j=1,ny                                                             
      if(z(i,j)+big)152,192,192                                                 
  152 if(j-1)162,162,153                                                        
  153 if(jmnew)154,154,162                                                      
  154 zijn=abs(z(i,j-1))                                                        
      if(zijn-big)195,162,162                                                   
  162 if(i-1)172,172,163                                                        
  163 if(imnew(j))164,164,172                                                   
  164 zijn=abs(z(i-1,j))                                                        
      if(zijn-big)195,172,172                                                   
  172 if(j-ny)173,182,182                                                       
  173 zijn=abs(z(i,j+1))                                                        
      if(zijn-big)195,182,182                                                   
  182 if(i-nx)183,192,192                                                       
  183 zijn=abs(z(i+1,j))                                                        
      if(zijn-big)195,192,192                                                   
  192 imnew(j)=0                                                                
      jmnew=0                                                                   
      go to 197                                                                 
  195 imnew(j)=1                                                                
      jmnew=1                                                                   
      z(i,j)=zijn                                                               
      nnew=nnew+1                                                               
  197 continue                                                                  
      if(nnew)200,200,199                                                       
  199 continue                                                                  
  200 continue                                                                  
      do 202 i=1,nx                                                             
      do 202 j=1,ny                                                             
      abz=abs(z(i,j))                                                           
      if(abz-big)202,201,201                                                    
  201 z(i,j)=abz                                                                
  202 continue                                                                  
c                                                                               
c     improve the non-data points by applying point over-relaxation             
c     using the laplace-spline equation (carres method is used)                 
c                                                                               
      dzrmsp=zrange                                                             
      relax=1.0                                                                 
      eps=.01                                                                   
      itmax=100                                                                 
      do 2100 iter=1,itmax                                                      
      dzrms=0.                                                                  
      dzmax=0.                                                                  
      do 2000 i=1,nx                                                            
      do 2000 j=1,ny                                                            
      z00=z(i,j)                                                                
      if(z00-big)205,2000,2000                                                  
  205 if(z00)2000,208,208                                                       
  208 wgt=0.                                                                    
      zsum=0.                                                                   
c                                                                               
  500 im=0                                                                      
      if(i-1)570,570,510                                                        
  510 zim=abs(z(i-1,j))                                                         
      if(zim-big)530,570,570                                                    
  530 im=1                                                                      
      wgt=wgt+1.                                                                
      zsum=zsum+zim                                                             
      if(i-2)570,570,540                                                        
  540 zimm=abs(z(i-2,j))                                                        
      if(zimm-big)560,570,570                                                   
  560 wgt=wgt+cay                                                               
      zsum=zsum-cay*(zimm-2.*zim)                                               
  570 if(nx-i)700,700,580                                                       
  580 zip=abs(z(i+1,j))                                                         
      if(zip-big)600,700,700                                                    
  600 wgt=wgt+1.                                                                
      zsum=zsum+zip                                                             
      if(im)620,620,610                                                         
  610 wgt=wgt+4.*cay                                                            
      zsum=zsum+2.*cay*(zim+zip)                                                
  620 if(nx-1-i)700,700,630                                                     
  630 zipp=abs(z(i+2,j))                                                        
      if(zipp-big)650,700,700                                                   
  650 wgt=wgt+cay                                                               
      zsum=zsum-cay*(zipp-2.*zip)                                               
  700 continue                                                                  
c                                                                               
 1500 jm=0                                                                      
      if(j-1)1570,1570,1510                                                     
 1510 zjm=abs(z(i,j-1))                                                         
      if(zjm-big)1530,1570,1570                                                 
 1530 jm=1                                                                      
      wgt=wgt+1.                                                                
      zsum=zsum+zjm                                                             
      if(j-2)1570,1570,1540                                                     
 1540 zjmm=abs(z(i,j-2))                                                        
      if(zjmm-big)1560,1570,1570                                                
 1560 wgt=wgt+cay                                                               
      zsum=zsum-cay*(zjmm-2.*zjm)                                               
 1570 if(ny-j)1700,1700,1580                                                    
 1580 zjp=abs(z(i,j+1))                                                         
      if(zjp-big)1600,1700,1700                                                 
 1600 wgt=wgt+1.                                                                
      zsum=zsum+zjp                                                             
      if(jm)1620,1620,1610                                                      
 1610 wgt=wgt+4.*cay                                                            
      zsum=zsum+2.*cay*(zjm+zjp)                                                
 1620 if(ny-1-j)1700,1700,1630                                                  
 1630 zjpp=abs(z(i,j+2))                                                        
      if(zjpp-big)1650,1700,1700                                                
 1650 wgt=wgt+cay                                                               
      zsum=zsum-cay*(zjpp-2.*zjp)                                               
 1700 continue                                                                  
c                                                                               
      dz=zsum/wgt-z00                                                           
      dzrms=dzrms+dz*dz                                                         
      dzmax=amax1(abs(dz),dzmax)                                                
      z(i,j)=z00+dz*relax                                                       
 2000 continue                                                                  
      dzrms=sqrt(dzrms/npg)                                                     
      rtrms=dzrms/dzrmsp                                                        
      dzrmsp=dzrms                                                              
      dzmaxf=dzmax/zrange                                                       
c      write(6,2050) iter,relax,rtrms,dzmaxf                                     
c 2050 format(i5,4h  w=f9.6, 7h  root=f9.6, 15h  dzmax/zrange= f9.7 )            
      if(iter-20*(iter/20))2100,2060,2100                                       
 2060 wc=rtrms+1.                                                               
      if(relax-1.-rtrms)2065,2080,2080                                          
 2065 if(rtrms-.999) 2070,2100,2100                                             
 2070 tpy=(rtrms+relax-1.)/relax                                                
      rtjsq=tpy*tpy/rtrms                                                       
      den=1.+sqrt(1.-rtjsq)                                                     
      wc=2./den                                                                 
 2080 continue                                                                  
      relax=wc-.25*(2.-wc)                                                      
      if(      dzmaxf/(1.-rtrms)-eps)2120,2120,2100                             
 2100 continue                                                                  
 2120 continue                                                                  
c                                                                               
      do 2500 i=1,nx                                                            
      do 2500 j=1,ny                                                            
      if(z(i,j)-big)2400,2500,2500                                              
 2400 z(i,j)=abs(z(i,j))-zbase-10.*zrange                                       
 2500 continue                                                                  
      return                                                                    
      end                                                                       
      subroutine inside(x,y,xb,yb,nb,ind)                                       
c====================================================================           
c                                                                   i           
c     given a point x,y and the series xb(k),yb(k) (k=1...nb)       i           
c     defining vertices of a closed polygon.                        i           
c     ind is set to 1 if the point is in the polygon and 0          i           
c     if outside. each time a new set of bound points is introduced i           
c     ind should be set to 999 on input.                            i           
c     it is best to do a series of y for a single fixed x.          i           
c     method ... a count is made of the no. of times the boundary   i           
c     cuts.                                                         i           
c     the meridian thru (x,y) south of (x,y) an odd count indicates i           
c     the point is inside , even indicates outside.                 i           
c     see a long way from euclid by constance reid p 174.           i           
c     oceanography emr  oct/69                                      i           
c                                                                   i           
c====================================================================           
      dimension xb(2),yb(2),yc(20)                                              
      if(nb) 10,10,20                                                           
10    ind=1                                                                     
      return                                                                    
20    if(ind-999) 30,40,30                                                      
30    if(x-xprev) 40,300,40                                                     
c                                                                               
40    xprev=x                                                                   
      nc=0                                                                      
      do 200 k=1,nb                                                             
      kp1=k+1-k*(k/nb)                                                          
      kw=k                                                                      
      if(xb(k)-xb(kp1)) 60,200,50                                               
50    kw=kp1                                                                    
60    ke=k+kp1-kw                                                               
      if(x-xb(ke))80,90,200                                                     
80    if(x-xb(kw)) 200,200,90                                                   
90    nc=nc+1                                                                   
      slope=(yb(ke)-yb(kw))/(xb(ke)-xb(kw))                                     
      yc(nc)=yb(kw)+(x-xb(kw))*slope                                            
200   continue                                                                  
c                                                                               
300   ind=0                                                                     
      if(nc) 340,340,310                                                        
310   do 330 k=1,nc                                                             
      if(yc(k)-y) 320,330,330                                                   
320   ind=1-ind                                                                 
330   continue                                                                  
340   return                                                                    
      end                                                                       


       subroutine getfname(filename,ext)
*
*  returns the name of a file with the default extent appended if not
*  supplied in the input from the screen. 
*
      character*4  ext
      character*40 filename, prefix
*
*
**********************************************************************
* initially make all chars in filename blank ...
*
      filename= '                                        '
*
      if(iflag.eq.0) then
         iflag=1
         write(6,1000) ext
 1000    format(' enter name of file ... default extent = ',a4,':  ')
         read(5,1005) prefix
 1005    format(a40)
      endif
*
*  check input file prefix for an extent.  if not present, add the
*    default file extent.  
*
      do 20 j=1,40
*        
        if(prefix(j:j) .eq. '.')then    
          filename= prefix
          return
*
        else if(prefix(j:j) .eq. ' ')then  
            i= j
            do 10 k=1,4
              filename(i:i)= ext(k:k)
              i= i+1
   10         continue
            return
*
        else
          filename(j:j)= prefix(j:j)
        end if
   20 continue
*
      write(6,1020) filename
 1020 format(' filename too long: ',a40/' process stopped in 
     + subroutine getfname')
*
      stop 
      end

  
