function val = globvar(varname,defval)
% globvar	sets a variable to be global. If undefined, sets to defval.
% Inputs:
%    varname, the name of variable name to be declared
%    defval,  the variable's default value
% Outputs:
%    the variables value
% Usage:
%
% Created:       4/20/95,   marra
% ***************************************************************************

if exist(varname) ~= 1			% if it doesn't exist, set it
  if isstr(defval)
    fmt = ' ''%s'' ';
  else 
    fmt = '%g';
  end;
  com = ['global ',varname];
  eval(com)
  evstr = sprintf([' %s = ' fmt ';'], varname, defval);
  eval( evstr ); 
  disp(evstr);
else
  disp('global variable exist');
end
%feval('global',varname);
