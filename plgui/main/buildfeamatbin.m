function [tr, roinames, mx, taxas] = buildfeamatbin(tows, cruise, discmat, types, taxas, domain,fea_len)
% to build training feature data matrix

% 11/13/96, X. Tang

m = size(tows, 1);			% tow number
k = size(types,1);			% feature types
t = size(taxas,1);			% taxa name
DIRLENGTH = 40;
mx = zeros(1, t);
tr = []; roinames = [];
for c = 1:t				% initialize
      fea_taxac = ['fea_taxa', num2str(c)];
      roi_taxac = ['roi_taxa', num2str(c)];
      com = [fea_taxac, '=[];'];  % stack one taxa
      eval(com);    
      com = [roi_taxac, '=[];'];  % stack one taxa
      eval(com);    
end
for i = 1:m				% for different tow #s
  cruise_i = deblank(cruise(tows(i,1), :));
%  cruise_i = deblank(cruise);
  tow = tows(i,2);
  disc = deblank(discmat(tows(i,1),:));
  fea_dir = [disc,filesep, ...
     cruise_i,filesep,'feature',filesep,'vpr',num2str(tow),filesep];
  roi_dir = [disc, filesep,...
     cruise_i,filesep,'idsize',filesep];
%  ****
  for c = 1:t				% taxa loop
    if domain(2,(i-1)*t+c) > domain(1,(i-1)*t+c)   % use the taxa in this tow
      taxa = deblank(taxas(c,:));
      clear fea_taxa; fea_taxa = [];      % start build one tow, one taxa
      for j = 1:k				%  feature types loop
        type = deblank(types(j,:));
        fea_file = [fea_dir, 'fea.', type, '.', taxa];
        if exist(fea_file)                % if the taxa exist in this tow
          fea = loadfea(fea_file, fea_len(j), domain(:, (i-1)*t+c));
          if type == 'geo'
            select =[12:20]; %[12:24, 26:28]; %[20 21 23 26 27 28];
            fea = fea(:, select);
          elseif type == 'dst'
            select =[1:64];
            fea =fea(:, select);
          end
          fea_taxa = [fea_taxa, fea];
        end
      end					% end feature types loop
      roi_file = [roi_dir, 'hid.v', num2str(tow), '.', taxa];
      if exist(roi_file)                % if the taxa exist in this tow
        roiname = loadname(roi_file, domain(:, (i-1)*t+c));
      end
      fea_taxac = ['fea_taxa', num2str(c)];
      roi_taxac = ['roi_taxa', num2str(c)];
      if exist('roiname','var'),
          com = [fea_taxac, '=[', fea_taxac, '; fea_taxa];'];  % stack one taxa
          eval(com);
          com = [roi_taxac, '=str2mat(', roi_taxac, ', roiname);'];
          eval(com);
      end
    end			% end of use this taxa in this tow
  end			% end taxa loop, one round stack individual taxa
end			% start next tow, next round stack each taxa

for c = 1:t                             % combine taxa mat into one fea mat
  taxa = deblank(taxas(c,:));
  fea_taxac = ['fea_taxa', num2str(c)];
  roi_taxac = ['roi_taxa', num2str(c)];
  if exist(fea_taxac)
    mx(c) = size(eval(fea_taxac), 1);
    com = ['tr = [tr; ', fea_taxac, '];'];
    eval(com);
    com = ['roinames = str2mat(roinames, ', roi_taxac, ');' ];
    eval(com);
  else
    disp(['no ', taxa, ' found in this training set'])
  end
end

nmx = sum(mx>0); 			% number of nunzero taxa
taxanz = zeros(nmx, size(taxas,2));
mxnz = zeros(1, nmx);

k = 1;
for c = 1:t
  if mx(c)>0
    mxnz(k) = mx(c);
    taxanz(k, :) = taxas(c, :);
    k = k+1;
  end
end
mx = mxnz; taxas = taxanz;