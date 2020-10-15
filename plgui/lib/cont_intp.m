function [dist, cont] = cont_intp(x, num);

cont = zeros(num, 2);
mrow = mean(x(:,2));
mcol = mean(x(:,1));
x(:,1) = x(:,1) - mcol; x(:,2) = x(:,2) - mrow;

len = length(x);
ang1 = [0:len-1]'/(len-1);
ang2 = [0:num-1]'/(num-1);
cont(:,1) = interp1(ang1, x(:,1), ang2, 'linear');
cont(:,2) = interp1(ang1, x(:,2), ang2, 'linear');

dist = sqrt(cont(:,1).^2 +cont(:,2).^2);

  
