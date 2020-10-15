function col=cmap4(type,n);
% CMAP4    various (quantized) spectrum colormaps.
%          CMAP4(TYPE) where TYPE=1-4 is a particular colormap.
%          CMAP4(TYPE,N) gives the colormap N quantized levels
%          (default N=16);
%
%          The quantization means that farly nice contouring can
%          be done using the interpolated shading in pcolor
%
%          See also SHADING, PCOLOR
%
if (nargin==0), type=1; n=16;
elseif (nargin==1), n=16; 
end;

if (type==1),

  w=[0:n-1]'/(n-1)*2*pi;
  we=w;
  we(w>3*pi/2)=3*pi/2*ones(sum(w>3*pi/2),1);

  col=(0.5*(1+[ sin(flipud(we)) -cos(w) sin((we)) ]));

elseif (type==2),

  w=[0:n-1]'/(n-1)*pi;
  col=max(0,[ sin(w-pi/4) abs(sin(w+pi/2)) sin(w+pi/4) ]);

elseif (type==3),

  w=[0:n-1]'/(n-1)*pi;
  col=max(0,[ sin(w-pi/4) (sin(w)) sin(w+pi/4) ]);

elseif (type==4),

  w=[0:n-1]'/(n-1);
  col=[w w w];

end;
