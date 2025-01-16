function [listvars, x_init, paramUbounds, paramLbounds, Int_listvars] = ...
    defineOptParamsBounds(fileName_simInput, fileName_optBounds)
% Setting the optimisation boundaries.
    %   The optimiation boundaries are imported from provide yaml file
    %
    % Args:
    %     fileName_simInput (char): Simulation input yaml filename.
    %     fileName_optBounds (char): Optimiation variables yaml filename.
    %
    % Returns:
    %     listvars (mx1 cell): Variable names that can vary during optimisation.
    %     x_init (mx1 double): Initial values corresponding to listvars.
    %     paramUbounds (mx1 double): Optimisation upper boundaries corresponding to listvars.
    %     paramLbounds (mx1 double): Optimisation lower boundaries corresponding to listvars.
    %     Int_listvars (?x1 cell): Variable names which corresponding values have to be converted to discrete values (integers).
    %
    % Author:
    %      Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
    %
    % Date:
    %     2024-10-31

    simInput = yaml.ReadYaml(fileName_optBounds,false,true);
    
    % Get all field names of the structure
    fieldNames = fieldnames(simInput);
    listvars = {};
    Int_listvars = {};
    paramLbounds=[];
    paramUbounds=[];
    % Loop through the field names
    for i = 1:length(fieldNames)
        % Get the field name as a string
        field = fieldNames{i};

        % Dynamically create the variable with the field name
        eval([field ' = simInput.' field ';']);
        
        value = getfield(simInput, field); %#ok<*GFLD>
        newfieldnames = fieldnames(value);
        
        for j = 1:length(newfieldnames)
            vari = [field,'.',newfieldnames{j}];
            listvars = [listvars;vari];
            bounds_i=eval(vari);
            if numel(bounds_i)>2
                Int_listvars = [Int_listvars;vari];
            end
            paramLbounds = [paramLbounds;bounds_i(1)]; %#ok<*AGROW>
            paramUbounds = [paramUbounds;bounds_i(2)];
        end

    end
    
    simInput = yaml.ReadYaml(fileName_simInput,false,true); %#ok<NASGU>
    
    x_init = zeros(numel(listvars),1);
    for i = 1:numel(listvars)
        x_init(i,1) = eval(['simInput.',listvars{i}]); %#ok<EVLDOT>
    end
end

