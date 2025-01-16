function updateYamlfromOpt(yaml_filename, list_old_individuals, listvars, ...
    Int_listvars, paramUbounds, runID, outputDir)
% This script updates a specified YAML configuration file by modifying its
% parameter values based on optimization results. The updated file is saved
% under the same name in the specified folder.
%
% Args:
%     yaml_filename (char): Name of the YAML file to be updated.
%     list_old_individuals (double): Historical optimization data, where rows correspond to variables and columns correspond to individuals.
%     listvars (cell): List of variables that can be updated.
%     Int_listvars (cell): List of integer optimization variables.
%     paramUbounds (double): Upper bounds for scaling optimization variables.
%     runID (double): Index of the individual whose parameters will be used for the update.
%     outputDir (char): Output folder for the updated yaml file
%
% Returns:
%     None: The script modifies and saves the YAML file with the updated 
%     parameters.
%
% Example:
%     outputDir = fullfile(pwd,'Lib');
%     yaml_filename = 'fig8down_simInput.yaml';
%     runID = 123;
%     load('list_old_individuals.mat', 'list_old_individuals', ...
%          'paramUbounds_copy', 'Int_listvars_copy', 'listvars_copy')
%     updateYamlfromOpt(yaml_filename, list_old_individuals, listvars_copy, ...
%          Int_listvars_copy, paramUbounds_copy, runID, outputDir)
%
% Notes:
%     - The script updates variables in a YAML file by parsing its structure.
%     - Preserves the file's structure and indentation during the update.
%     - If `runID` or input variables are incorrect, the script will fail.
%     - !! If yaml_filename is already in outputDir, the file will be overridden.
%
% Authors:
%     Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
%
% Date:
%     2024-10-31

optsIN = list_old_individuals(1:end,runID);

% Read the YAML file as text
fid = fopen(yaml_filename, 'r');
yaml_text = fread(fid, '*char')';
fclose(fid);

% Loop over each variable in listvars_copy and update its value
for j = 1:length(listvars)
    var_name = listvars{j};
    new_value = optsIN(j);
    
    parts = strsplit(var_name, '.');
    parent_key = parts{1};   % e.g., 'controllerGains_traction'
    parent_pattern = ['(\s*' parent_key ':)'];  % Pattern to locate the parent key
    [parent_start, parent_end] = regexp(yaml_text, parent_pattern, 'start', 'end', 'once');
    
    if numel(parts)>1
        child_key = parts{2};    % e.g., 'rateRoll_P'
        child_pattern = ['(\s*' child_key ':\s*)([\d.+-eE]+)'];
        [child_starts, child_ends] = regexp(yaml_text, child_pattern, 'start', 'end');

        index_realChild = find(child_starts > parent_start, 1);

        idx_start = child_starts(index_realChild);
        idx_end = child_ends(index_realChild);
        
        search_pattern = child_pattern;
    else
        idx_start = parent_start;
        idx_end = parent_end;
        search_pattern = ['(\s*' parent_key ':" ")'];  % Pattern to locate the parent key;
    end
    search_text = yaml_text(idx_start:idx_end);

%     pattern = ['(\s*' var_name ':\s*)([\d.+-eE]+|true|false|''[^'']*''|"[^"]*"|\[.*?\])'];
        % Replace the old value with the new value
        if isnumeric(new_value)
            % Convert numeric value to string
            if ismember(var_name,Int_listvars)
                rounded_value = round(new_value .* paramUbounds(j));
            else
                rounded_value = round(new_value .* paramUbounds(j), 6, 'significant');
            end
            replacement_value = num2str(rounded_value);
        elseif islogical(new_value)
            replacement_value = lower(mat2str(new_value));  % Convert boolean to 'true' or 'false'
        elseif ischar(new_value)
            replacement_value = ['"' new_value '"'];  % Handle string values
        end

        % Construct the replacement string while preserving indentation
        replacement = ['$1' replacement_value];

        % Perform the replacement in the YAML text
        search_text = regexprep(search_text, search_pattern, replacement);
        if idx_start~=1
            firstpart = yaml_text(1:idx_start-1);
        else
            firstpart = [];
        end
        if idx_end~=numel(yaml_text)
            endpart = yaml_text(idx_end+1:end);
        else
            endpart = [];
        end
        yaml_text = [firstpart,search_text,endpart];
end

% Modify the filename
% [~, name, ext] = fileparts(yaml_filename);
% new_filename = fullfile(yaml_dir, [name '_new' ext]);
new_filename = yaml_filename;

% Write the modified text back to the JSON file
fid = fopen(new_filename, 'w');
fwrite(fid, yaml_text, 'char');
fclose(fid);

movefile(new_filename,fullfile(outputDir,new_filename))

