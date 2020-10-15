function fd = fds(x);

% compute Fourier descriptors for each column
%>> abs(fft(rand(1,6)))
%    3.2396    1.2260    0.4631    0.3514    0.4631    1.2260
%>> abs(fft(rand(1,7)))
%    2.9122    0.5871    0.5045    0.5078    0.5078    0.5045    0.5871

m = length(x);
  if isreal(x(1))
    fd = abs(fft(x));
    fd = fd(2:floor(m/2)+1)/fd(1);  
  else
    fd = abs(fft(x));
    fd = fd(3:m)/fd(2); 
  end


