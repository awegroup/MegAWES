function [ newModelNames , changeStatus ] = Replace_MdlRef_SubSys( varargin )
%Replace_MdlRef_SubSys will replace all model reference blocks at all levels
% within the top level model with SubSystems having the same contents as
% the referenced model.
% Syntax: Replace_MdlRef_SubSys( modelName )

% Fixes:
% 1 October 2020: Filepath separation fixed, independent of operating system now (D. Eijkelhof)
% 21 October 2020: Referenced subsystems are replaced as well (D. Eijkelhof)

% D. Eijkelhof
% Delft University of Technology
% email address: d.eijkelhof@tudelft.nl  
%% Verify Input Argument:
topLevelModel = varargin{1};

if( nargin == 1 )               % First call to the function will contain only the top level model name
    newModelNames = cell(0);    % Initialize the list of new models created using this function
end

if( nargin == 2 )
    newModelNames = varargin{2};
end

if( nargin > 2 )
    error( 'Invalid number of arguments' );
end

if( exist( topLevelModel , 'file' ) == 4 )  % Check whether the model exists on the MATLAB path
    if( ~bdIsLoaded( topLevelModel ) )
        load_system( topLevelModel );   % If Model is not already loaded, load it
    end
else
    error( 'Model does not exist on MATLAB path' );
end


%% Find Model Reference Blocks in the top level model:
topLevelModelHandle = get_param( topLevelModel , 'Handle' );
mdlRefsHandles = find_system( topLevelModelHandle , 'findall' , 'on' , 'blocktype' , 'ModelReference' );
mdlRefsHandles2 = find_system( topLevelModelHandle , 'findall' , 'on' ,...
    'RegExp','on', 'blocktype' ,'SubSystem','ReferencedSubsystem', '.');
mdlRefsHandles = [mdlRefsHandles;mdlRefsHandles2];

if( ~isempty( mdlRefsHandles ) )   % If the model contains model references
    %% Create new model:
    % Create a new mdl file and make changes in it. Always leave the source intact.
    newTopLevelModel = [ topLevelModel '_new' ];
    srcFilename = which( topLevelModel );
    [~,~,ext]=fileparts(srcFilename);
    dstFilename = [ pwd filesep newTopLevelModel ext ];
    newModelNames = [ newModelNames ; newTopLevelModel ];
    
    % Delete an existing file
    if( exist(  newTopLevelModel , 'file' ) == 4 )
        if( bdIsLoaded( newTopLevelModel ) )
            bdclose( newTopLevelModel );   % Close the old model if its open before attempting to delete it
        end
        delete( dstFilename );
    end
    
    copyfile( srcFilename , dstFilename ,'f' );
    
    bdclose( topLevelModel );   % Close original model
    topLevelModel = newTopLevelModel;
    load_system( topLevelModel );
    
    % The following two lines are necessary because we are using a new
    % model now:
    topLevelModelHandle = get_param( topLevelModel , 'Handle' );
    mdlRefsHandles = find_system( topLevelModelHandle , 'findall' , 'on' ,...
        'blocktype' , 'ModelReference' );
    mdlRefsHandles2 = find_system( topLevelModelHandle , 'findall' , 'on' ,...
        'RegExp','on', 'blocktype' ,'SubSystem','ReferencedSubsystem', '.');
    mdlRefsHandles = [mdlRefsHandles;mdlRefsHandles2];
    ref_block_path = getfullname(mdlRefsHandles);
    %% Replace Model References with Sub-Systems:
    
    for k = 1 : length( mdlRefsHandles )
        if strcmp(get_param( mdlRefsHandles(k) , 'BlockType' ),'SubSystem')
            mdlRefName = get_param( mdlRefsHandles(k) , 'ReferencedSubsystem' );
        else
            mdlRefName = get_param( mdlRefsHandles(k) , 'ModelName' );
        end
        
        % Recursive searching of nested model references:
        [ newModelNames , changeStatus ] = Replace_MdlRef_SubSys( mdlRefName , newModelNames );
        
        % Use the new referenced model which has gone through the
        % conversion:
        if( changeStatus )
            mdlRefName = [ mdlRefName '_new' ]; %#ok<AGROW>
        end
        
        % Create a blank subsystem, fill it with the modelref's contents:
        blockPosition = get_param( mdlRefsHandles(k) , 'Position' );
        
        % ssName = [ topLevelModel filesep mdlRefName '_SS_' num2str(k) ];
        ssName = [ ref_block_path{k} '_SS_' num2str(k) ];
        ssHandle = add_block( 'built-in/SubSystem' , ssName );  % Create empty SubSystem
        
        slcopy_mdl2subsys( mdlRefName , ssName );   % This function copies contents of the referenced model into the SubSystem
        
        delete_block( mdlRefsHandles(k) );
        
        % Setting the SubSystems position to the same position as the
        % referenced model automatically connects the corresponding in and
        % out ports
        if strcmp(mdlRefName,'Environment')
            set_param( ssHandle ,'Orientation','left');
        end
        set_param( ssHandle , 'Position' , blockPosition );
        
        % Assigning Model Reference Callbacks to the new subsystem:
%         Replace_Callbacks( mdlRefName , ssHandle );
        
    end
    
    save_system( topLevelModel );
    changeStatus = true;    % Model has been changed.
    bdclose( topLevelModel );
else
    changeStatus = false;    % Model did not have any model references, so there were no changes.
end

end


function Replace_Callbacks( mdlRefName , ssHandle ) %#ok<DEFNU>
%Replace_Callbacks Copies the callbacks of the referenced model to the
% callbacks of the Subsystem:

preLoadFcn = get_param( mdlRefName , 'PreLoadFcn' );
postLoadFcn = get_param( mdlRefName , 'PostLoadFcn' );
loadFcn = sprintf( [ preLoadFcn '\n' postLoadFcn ] );

initFcn = get_param( mdlRefName , 'InitFcn' );
startFcn = get_param( mdlRefName , 'StartFcn' );
pauseFcn = get_param( mdlRefName , 'PauseFcn' );
continueFcn = get_param( mdlRefName , 'ContinueFcn' );
stopFcn = get_param( mdlRefName , 'StopFcn' );
preSaveFcn = get_param( mdlRefName , 'PreSaveFcn' );
postSaveFcn = get_param( mdlRefName , 'PostSaveFcn' );
closeFcn = get_param( mdlRefName , 'CloseFcn' );


set_param( ssHandle , 'LoadFcn' , loadFcn );
set_param( ssHandle , 'InitFcn' , initFcn );
set_param( ssHandle , 'StartFcn' , startFcn );
set_param( ssHandle , 'PauseFcn' , pauseFcn );
set_param( ssHandle , 'ContinueFcn' , continueFcn );
set_param( ssHandle , 'StopFcn' , stopFcn );
set_param( ssHandle , 'PreSaveFcn' , preSaveFcn );
set_param( ssHandle , 'PostSaveFcn' , postSaveFcn );
set_param( ssHandle , 'ModelCloseFcn' , closeFcn );
end