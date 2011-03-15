function [res,resdataobject,resmat] = c_caa_var_get(varargin)
%C_CAA_VAR_GET(var_name)  get CAA variable (if necessary load it)
% 
% if input is cell array, output is also cell array
%
% Usage:
%  var= c_caa_var_get(varargin)
%  [var,dataobject] = c_caa_var_get(varargin)
%  [var,dataobject,variable_matlab_format]=c_caa_var_get(varargin)
%
% Example:
%   temp=C_CAA_VAR_GET('Data__C4_CP_PEA_PITCH_SPIN_PSD');
%   [~,~,xm]=c_caa_var_get('Differential_Particle_Flux__C3_CP_CIS_HIA_PAD_HS_MAG_IONS_PF');
% give values for each dependency and other information

jloaded=0;
flagmat=0; if nargout>2, flagmat=1;end % whether to calculate mat variable
for j=1:length(varargin),
  var_name=varargin{j};
  if ischar(var_name) && strfind(var_name,'__') % variable name specified as input
    dd=regexp(var_name, '__', 'split');
    dataobj_name=dd{end};
    dataobj_name(strfind(dataobj_name,'-'))='_'; % substitute '-' with '_'
    if evalin('caller',['exist(''' dataobj_name ''',''var'')']),
      dataobject=evalin('caller',dataobj_name);
      jloaded=jloaded+1;
      disp('Dataobj exist in memory. NOT LOADING FROM FILE!')
    else
      caa_load(dataobj_name);
      eval(['dataobject=' dataobj_name ';']);
      jloaded=jloaded+1;
    end
    var=getv(dataobject,var_name);
    if flagmat % construct also matlab format
      varmat=getmat(dataobject,var_name);
    end
    if jloaded == 1
      res=var;
      resdataobject=dataobject;
      if flagmat, resmat=varmat;end
    elseif jloaded == 2
      res={var};
      resdataobject={resdataobject,dataobject};
      if flagmat, resmat={resmat,varmat}; end
    elseif jloaded > 2
      res{jloaded}=var;
      resdataobject{j}=dataobject;
      if flagmat, resmat{j}=varmat;end
    end
  end
end