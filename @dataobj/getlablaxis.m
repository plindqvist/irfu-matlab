function res = getlablaxis(dobj,var_s)
%GETLABAXIS(dobj, var_s)  get axis label for a variable
%
% $Id$

% ----------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <yuri@irfu.se> wrote this file.  As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return.   Yuri Khotyaintsev
% ----------------------------------------------------------------------------

error(nargchk(2,2,nargin))

res = findva(dobj,'LABLAXIS',var_s);