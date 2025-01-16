function initialiseWorkspaceAndFolders(directoriesToAdd, variablesToKeep)
% Initialise the MATLAB workspace and folders.
%
% This function clears the MATLAB base workspace, closes all open figures,
% clears persistent and MEX functions, and adds specified directories to the MATLAB search path.
%
% Args:
%     directoriesToAdd (cell): 
%         A cell array containing folder paths as strings to be added to the MATLAB search path.
%         If empty, no directories are added.
%     variablesToKeep (cell, optional): 
%         A list of variable names to retain in the base workspace. 
%         If not provided, all variables are cleared.
%
% Example:
%     % Add specified directories to the path and clear all variables except 'data'.
%     directories = {'folder1', 'folder2'};
%     initialiseWorkspaceAndFolders(directories, {'data'});
%
%     % Clear all variables and do not add any directories.
%     initialiseWorkspaceAndFolders({}, {});
%
% Note:
%     The function uses `evalin` to interact with the base workspace. Use with caution.
%
% Author:
%      Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
%
% Date:
%     2024-10-31
%% Input checks
narginchk(1, 2); % Check for exactly 1 input argument

if (~iscell(directoriesToAdd) && ~isempty(directoriesToAdd)) || ...
        (iscell(directoriesToAdd) && ~all(cellfun(@ischar, directoriesToAdd)))
    error('Input must be a 1xN cell array of folder strings or an empty variable.');
end

%% Clear current base workspace/command window and close all (mex)functions and files
if nargin < 2 || isempty(variablesToKeep)
    evalin('base', 'clearvars'); % Clear the base workspace
else
    evalin('base', ['clearvars -except ', strjoin(variablesToKeep, ' ')]); % Clear the base workspace
end
close all
clc
fclose('all');
clear mex %#ok<CLMEX>

%% Check if inside the correct root directory and add folders to MATLAB search path
if ~isempty(directoriesToAdd)
    for i = 1:numel(directoriesToAdd)
        directoryToCheck = directoriesToAdd{i};
        if exist(directoryToCheck, 'dir') == 7
            currentPath = path;
            pathToAdd = genpath(directoryToCheck);
            % if ~contains(currentPath, pathToAdd) % not working properly in certain cases
                addpath(pathToAdd);
                disp(['Directory "', directoryToCheck, '" has been added to the MATLAB search path.']);
            % end
        else
            error(['Directory "', directoryToCheck, '" could not be found on the current search path.']);
        end
    end
end

disp('Workspace and Folders are initialised.')

end