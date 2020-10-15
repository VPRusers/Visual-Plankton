clear
count=0;
cr=setstr(13);
lf=setstr(10);
t0=clock;

%Establish the input and output files

filename1=input(['Enter filename containing list of rois:' cr lf],'s');
filename2=input(['Enter output filename' cr lf],'s');

imdir=input(['Enter path to directory containing rois, ending with a /:' cr lf],'s');

fid2=fopen(filename2,'a');
%filename1=[imdir filename1];
fid1=fopen(filename1,'r');

Q=input(['Do you want to enter calibration numbers (y or n)?' cr lf],'s');

  if Q == 'y' | Q == 'Y'

    F=input(['Are values in a file (1) or do you want to enter them on keyboard (2)?' cr lf]);
  
     if F==1
      load camfield.dat
      CAM=input(['Camera 2 (2) or Camera 4 (4)  (Enter appropriate number) ?' cr lf]);
      
      if CAM==2
        sw=camfield(1,1)/512; sh=camfield(1,2)/512;
       elseif CAM==4
        sw=camfield(2,1)/512; sh=camfield(2,2)/512;  

       end   %Loop to load data from files
 
    elseif F==2
      sw=input(['Enter WIDTH of video field of view in mm' cr lf]); sw=sw/512;
      sh=input(['Enter HEIGHT of video field of view in mm' cr lf]); sh=sh/512;
    
    end  %Loop where R=1  
  
  else           %Q does not == Y or y
     sw=6.2/512;sh=4.4/512;    %Use default values for calibration
  
 end      %Loop for whether or not enter calibration values

clg;axis off

x=ones(1,30)*512;
y=[0:1/30:29/30]*512;y=flipud(y); 

%t=[   'AVAILABLE '; 'ADD-TAXA  '; 'COMMENT   '; 'PHYTOPLANK'];
%t=[t; 'CENTROPAGE'; 'COPE-NAUP '; 'POLYCHAETE'; 'CTENOPHORE'; 'CYCLO-UID '];
%t=[t; 'DIATOM    '; 'DIAT-CHAET'; 'DIAT-CHSOC'; 'DINO-CERAT'; 'ECHINODERM'];
%t=[t; 'LARVACEAN '; 'ALGALMAT  '; 'MEDUSA-UID'; 'MEDUSA-HYD'; 'OITHWEGGS '];
%t=[t; 'OITHONA   '; 'PSEUDOWEGG'; 'COPE-UID  '; 'PSEUDOCALA'; 'PTEROPOD  '];
%t=[t; 'MARINESNOW'; 'UNIDENTIFI'; 'EUPHAUSIID'; 'CALANUS   '; 'OTHER     '];
%t=[t; 'HYDROIDS  '];

%t=[   'PHYTOPLANK'; 'ADD-TAXA  '; 'COMMENT   '; 'CENTROPAGE'];
%t=[t; 'COPE-NAUP '; 'POLYCHAETE'; 'CTENOPHORE'; 'CYCLO-UID '; 'DIATOM    '];
%t=[t; 'DIAT-CHAET'; 'DIAT-CHSOC'; 'DINO-CERAT'; 'ECHINODERM'; 'LARVACEAN '];
%t=[t; 'ALGALMAT  '; 'MEDUSA-UID'; 'MEDUSA-HYD'; 'OITHWEGGS '; 'OITHONA   '];
%t=[t; 'PSEUDOWEGG'; 'COPE-UID  '; 'PSEUDOCALA'; 'SKIP      '; 'PTEROPOD  '];
%t=[t; 'MARINESNOW'; 'UNIDENTIFI'; 'EUPHAUSIID'; 'CALANUS   '; 'OTHER     '];
%t=[t; 'HYDROIDS  '];

t=[   'PHYTOPLANK'; 'OITHONA   '; 'COMMENT   '; 'CENTROPAGE'];
t=[t; 'UNIDENTIFI'; 'POLYCHAETE'; 'CTENOPHORE'; 'CYCLO-UID '; 'DIATOM    '];
t=[t; 'DIAT-CHAET'; 'DIAT-CHSOC'; 'DINO-CERAT'; 'ECHINODERM'; 'LARVACEAN '];
t=[t; 'ALGALMAT  '; 'MEDUSA-UID'; 'MEDUSA-HYD'; 'OITHWEGGS '; 'AMPHIPODS '];
t=[t; 'PSEUDOWEGG'; 'COPE-UID  '; 'PSEUDOCALA'; 'SKIP      '; 'PTEROPOD  '];
t=[t; 'MARINESNOW'; 'PHAEOBLIMP'; 'EUPHAUSIID'; 'CALANUS   '; 'OTHER     '];
t=[t; 'HYDROIDS  '];

t=flipud(t);

button=2;
i=1;
tc=zeros(1,5);
comment='';
nblanks=3;
idflag=0;
mflag=0;
imflag=0;
initflag=0;    %Changes to 1 after view first image
yid=0;

while button ~= 3,

  if imflag==0,

%   read and display image
    fn=fscanf(fid1,'%s',1);

% Check to make sure you are not at the end of the list of rois

    if fn==[], break,end

    filename=[imdir fn];

%Determine whether image has been saved as tiff or raster

    if (fn((length(fn)-2):length(fn)) == 'ras')

%   read the Sun raster image
      fid = fopen(filename,'r');
      hdr = fread(fid,8,'uint');w1 = hdr(2);h1 = hdr(3);
      im = fread(fid,[w1,h1],'uchar');
      im=rot90(im);im=flipud(im);nr=size(im,1);nc=size(im,2);
      fclose(fid);

    else,

%  read the TIFF image
      [im,immap] = tread(filename);
      clear immap;
      h1=size(im,1);w1=size(im,2); nr = h1; nc = w1;

    end;      %If file is a raster or tiff


    b(2:2:2*nr,:)=im;
    b(1:2:2*nr-1,:)=im;
    im=b;
    clear b;

    if initflag==0,
      image(im);axis([1 512 1 512]);
      p1=3*pi/2;p3=2*pi;p2=(p3-p1)/256;map=[(p1:p2:p3)', (p1:p2:p3)', (p1:p2:p3)'];
      map=cos(map).^4;
      colormap(map);
      brighten(.8)
      text(x,y,t,'VerticalAlignment','bottom');
      h=get(gca,'children');
      initflag=1.;

    else,

       set(h(31),'cdata',im,'xdata',[(512-w1) 512],'ydata',[1 2*h1]);
 
      end;    %End if intiflag==0

    if mflag==0, title([fn 'SELECT CATEGORY']);end
    if mflag==1, title([fn '   SELECT TAXA OR COMMENT ON PREVIOUS BUG']);end

    imflag=1;
    count=count+1;

  end;   

  [x1,y1,button]=ginput(1);

   if button == 2,

      yidold=yid;
      yid=fix(y1/512*30+2);
 
      idflag=0;
      if mflag==1,
        if yid==28,
          title('ENTER COMMENT IN MATLAB WINDOW');
          clc;
          comment=input(['enter comment' cr lf],'s');
          title([fn 'SELECT CATEGORY']);
          idflag=0;
        end               % if yid==28


   fprintf(fid2,'%2.f %2.f %2.f %2.f %2.f ',tc(1),tc(2),tc(3),tc(4),tc(5));
   fprintf(fid2,'%s %7.4f %9.4f %9.4f %9.4f %9.4f %s\n',t(yidold,:),w,x1old,y1old,x2,y2,comment);

        mflag=0;
        comment='';
      end    % if mflag==1

      if yid<31 & yid ~=28

         title(t(yid,:));

%  convert time code from string filename into numeric tc array
          tc(1)=sscanf(fn(5:6),'%f');tc(2)=sscanf(fn(8:9),'%f');
          tc(3)=sscanf(fn(11:12),'%f');tc(4)=sscanf(fn(14:15),'%f');
          tc(5)=0;if fn(16)=='o',tc(5)=1;end;

          idflag=1;
      end     %End if yid<31

  end

  if button == 1,

    if idflag==0,
      imflag=0;
    end

    if idflag==1,
      [x2,y2,button] = ginput(1);
      
      if button == 1,
        x1old=x1; y1old=y1;
        w=sqrt(((x2-x1)*sw)^2+((y2-y1)*sh)^2);

      if (yid ~= 2 |  yid~=1) 
       title(sprintf([t(yid,:) '  width = %g  SELECT COMMENT OR NEW TAXA'],w))
	if yid==2
	  title('ENTER COMMENT IN MATLAB WINDOW');
         elseif yid==1
          title('ENTER # HYDRANTHS, CONDITION, FOOD IN GUT? IN MATLAB WINDOW');
            end
	  end

        idflag=0;
        mflag=1;
	imflag=0;
      if (yid==2 |  yid==1)
          clc;
          comment=input(['enter comment' cr lf],'s');
          title('SELECT NEW TAXA')
          idflag=0;
        end
     end
    end
  end
end;
if mflag==1,

  fprintf(fid2,'%2.f %2.f %2.f %2.f %2.f ',tc(1),tc(2),tc(3),tc(4),tc(5));
  fprintf(fid2,'%s %7.4f %9.4f %9.4f %9.4f %9.4f %s\n',t(yid,:),w,x1old,y1old,x2,y2,comment);

end

numided=count-1;
time=etime(clock,t0)/3600;
rate=numided/(time*60);
   if count>1,

     [s,w]=unix(['head  -',num2str(numided),' ',filename1,' >> ',filename1,'.hd']);
%    [s,w]=unix(['head  -',num2str(count),' ',filename1,' >> ',filename1,'.hd']);
 
     [s,w]=unix(['tail +',num2str(count),' ',filename1,' > temp.tail']);
     [s,w]= unix(['mv -f temp.tail ',filename1,' ']);

     [s,a]=unix(['wc ',filename1,' ']);A=sscanf(a,'%f');
     [s,b]=unix(['wc ',filename1,'.hd']);B=sscanf(b,'%f');
     [s,c]=unix(['wc ',filename2,' ']);C=sscanf(c,'%f');
     totrois=A(1)+B(1); 

     fprintf('%6.0f rois identified out of %6.0f total rois in this tow\n',B(1),totrois)
     fprintf('You identified %4.0f bugs in %f hours\n',numided,time)
     fprintf('Bug Identification Rate (BIR) is:  %f bugs per minute\n',rate)
     if rate<1
	fprintf('Too slow...you must have been daydreaming.....')
        end
     
    end

disp('done')
fclose('all');
return
