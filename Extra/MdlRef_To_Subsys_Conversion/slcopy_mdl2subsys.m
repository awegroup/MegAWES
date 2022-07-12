function slcopy_mdl2subsys(model, subsysBlk)
%  SLCOPY_MDL2SUBSYS Copy contents of a model to a Subsystem

%  SLCOPY_MDL2SUBSYS(model, subsysBlk) deletes the Subsystem block 
%  contents, and copies the input model contents to the Subsystem block.
% 
%  Inputs:
%     model:     Model name or handle
%     subsysBlk: Subsystem block full path name or handle
%
%  Note: The Subsystem block cannot be part of the input model.
%
  
  if nargin ~= 2
    error('usage:  slcopy_mdl2subsys(model, subsysBlk)');
  end

  try
    
    % Check the first input argument
    isOk = (ischar(model) || ishandle(model));
    if ~isOk
      error('slcopy_mdl2subsys: the first input must be a model name');
    end
    
    % Check the second input argument
    if ~strcmpi(get_param(subsysBlk,'type'), 'block') || ...
          ~strcmpi(get_param(subsysBlk,'blocktype'), 'Subsystem')
      error('slcopy_mdl2subsys: the second input must be a Subsystem block');
    end
   
    % load the model if it is not loaded
    load_system(model);
    
    modelName = get_param(model, 'name');
    
    % Get the Subsystem root, and make sure the Subsystem is not 
    % inside the input model
    subsysRoot = get_subsystem_root_l(subsysBlk);
    if strcmpi(subsysRoot, modelName)
      error(['slcopy_mdl2subsys: invalid inputs. The Subsystem block ', ...
             'cannot be part of the input model']);
    end

    obj = get_param(subsysBlk,'object');
    %obj.deleteContent;
    Simulink.SubSystem.deleteContents(subsysBlk)
    obj.copyContent(modelName);
  catch
    rethrow(lasterror);
  end
  
%endfunction

  
function subsysRoot = get_subsystem_root_l(subsys)
  p1 = get_param(subsys,'parent');
  p2 = get_param(p1,'parent');
  
  while ~isempty(p2)
    p1 = p2;
    p2 = get_param(p1,'parent');
  end
  subsysRoot = p1;

%endfunction