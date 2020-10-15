function [gra, cont, bgr, fea, templt, radi] = readvector(name);
% Read granulometry features

% name is roi.18_29_45.22 without .tif
%tic
gra = [];
%rname = [];
firstnm = firstname(name);                % roi    

f1 = [name, '.close.linear.granul'];
f2 = [name, '.cont'];
%f3 = [name, '.bin.close.linear.granul'];
if exist(f1)%&exist(f2) 

	filename = [name, '.close.linear.granul'];
   load(filename);
% Modified by HuQiao   
if length(eval(firstnm))>40
	gra = [gra eval([firstnm,'(2:41)'])];
else   
  	gra = [gra eval(firstnm)];
end   
% End of Modify
	delete(filename);
%	rname = [rname,' ', filename];

	filename = [name, '.close.pseudo.granul'];
   load(filename);
% Modified by HuQiao   
if length(eval(firstnm))>40
	gra = [gra eval([firstnm,'(2:41)'])];
else   
  	gra = [gra eval(firstnm)];
end   
% End of Modify
	delete(filename);
%	rname = [rname,' ', filename];

	filename = [name, '.open.linear.granul']; 
	load(filename);
% Modified by HuQiao   
if length(eval(firstnm))>40
	gra = [gra eval([firstnm,'(2:41)'])];
else   
  	gra = [gra eval(firstnm)];
end   
% End of Modify
	delete(filename);
%	rname = [rname,' ', filename];

	filename = [name, '.open.pseudo.granul'];
	load(filename);
% Modified by HuQiao   
if length(eval(firstnm))>40
	gra = [gra eval([firstnm,'(2:41)'])];
else   
  	gra = [gra eval(firstnm)];
end   
% End of Modify
	delete(filename);
%	rname = [rname,' ', filename];

	if nargout >1
        if exist(f2),
            filename = [name, '.cont'];
            load(filename);
            cont = eval(firstnm);
            delete(filename);
        else
            cont=0
        end
%		rname = [rname,' ', filename];
	end

%	eval(['!del ' rname]);

else				% pbin failed
	disp(['Pbin failed, go on to the next image']);
	gra = 0;
	cont = 0;
	bgr = 0;
end
