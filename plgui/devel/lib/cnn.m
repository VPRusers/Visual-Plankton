function [store,class] = cnn(T,C)
% function [store,class] = cnn(T,C) provides a condensed nearest
% neighbor data set for input to the nearest neighbor classifier
% function NN.  The input training vectors (i.e. the columns of
% matrix T) and the class labels (columns of C) are analyzed to
% provide a smaller, more manageable, set of training data and
% corresponding class labels which when used in a nearest-neighbor
% classifier, provide the same classification performance as if
% the entire original data set were used.  The outputs, STORE and
% CLASS, provide the same function as the original data (T and C)
% except they are smaller (in number, not dimensionality).

% created 7/23/95  Xiaoou Tang

[m,n] = size(T);
store = T(:,1); class = C(1);
change = 1;
while change
  change = 0;
  for i=2:n
    t = T(:,i);
    c = nn(t,store,class);
    if c ~= C(i)
      store = [store t];
      class = [class C(i)];
      change = 1;
    end
  end
  if ~change; return; end
end