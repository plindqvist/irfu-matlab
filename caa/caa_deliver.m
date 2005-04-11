function caa_deliver(sp)
%CAA_DELIVER  deliver CEF files to the CAA
%
% caa_deliver([sp])
%   sp - storage path
%	compress and deliver CEF files to the CAA
%
% $Id$

if nargin<1, sp=pwd; end

old_pwd = pwd;
cd(sp);
dname = pwd;
ii = find(dname=='/');

fname = [dname(ii(end)+1:end) '.tgz'];
fmask = 'C[1-4]_CP_EFW_L[1-3]_*_V*.cef';
irf_log('proc',['compressing ' fname])
[s,w] = unix(['tar zcvf ' fname ' ' fmask],'-echo');

if s~=0, irf_log('save',['problem compressing ' fname]),cd(old_pwd),return, end

irf_log('proc',['uploading ' fname ' to the CAA'])
[s,w] = unix(...
	['echo "put ' fname '"| sftp -b - efw@caa.estec.esa.int:/c/data-20/EFW/'],...
	'-echo');
if s~=0, irf_log('save',['problem uploading ' fname]),cd(old_pwd),return, end

irf_log('proc',['moving ' fname ' to storage'])
[s,w] = unix(['mv ' fname ' /data/caa/delivered'],'-echo');

if s~=0, irf_log('save',['problem moving ' fname]),cd(old_pwd),return, end

irf_log('proc','cleaning up')
[s,w] = unix(['rm ' fmask],'-echo');

cd(old_pwd)
