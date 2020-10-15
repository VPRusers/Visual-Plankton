function taxa_name = taxanames(taxafile)

% 11/10/96, X. Tang

numtaxa = length(find(taxafile == 10));
taxa_name = ['0123456789'];          % make sure matrix width

for t = 1:numtaxa,
  taxa_name = str2mat(taxa_name, tailname(nthfile(taxafile, t)));
end;
taxa_name = taxa_name(2:numtaxa+1,:);




