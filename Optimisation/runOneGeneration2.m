function yOUT = runOneGeneration2(xIN)
    % Execute one generation of optimization simulations.
    %
    % Args:
    %     xIN (double): Input matrix defining the parameters for the optimization individuals. 
    %         Each column corresponds to an individual.
    %
    % Returns:
    %     yOUT (double): Output array containing the final cost values for each individual in the population.
    %
    % Notes:
    %     - The function checks for previously simulated individuals to avoid redundant computations.
    %     - Simulink models are loaded and configured for each individual.
    %     - Simulation results are stored and reused if an identical individual is re-evaluated.
    %     - The cost function evaluates performance and constraint penalties for each individual.
    %     - Uses parallel simulations (`parsim`) to improve computation speed.
    %     - Global variables:
    %         - `runID`: Tracks the simulation run ID.
    %         - `listvars`: List of optimization variable names.
    %         - `paramUbounds`: Upper bounds for optimization parameters.
    %         - `model`: Name of the Simulink model.
    %         - `Int_listvars`: List of discrete (integer) optimization variables.
    %         - `fileName_simInput`: File name for simulation input configuration.
    %         - `fileName_kite`: File name for kite-specific parameters.
    %
    % Workflow:
    %     1. Checks if preveous individuals exist by loading `list_old_individuals.mat`.
    %     2. Configures simulation inputs using `runParamSim` and `initAllStructs`.
    %     3. Runs simulations using `parsim`.
    %     4. Computes cost values for each individual using `getCost_new`.
    %     5. Updates and saves the history file `list_old_individuals.mat`.
    %
    % Date:
    %     2024-10-31
    %
    % Authors:
    %     Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
    
    global runID
    global listvars paramUbounds model Int_listvars
    global fileName_simInput fileName_kite
    
    if numel(runID) == 0
        runID = 0;
    end
    
    nInd = size(xIN, 2); % number of individuals
    nRetvals = 9; % number of outputs of the cost function CHECK!!
    
    optsIN = xIN;
    
    try
        load('list_old_individuals.mat','list_old_individuals', 'listvars_copy', ...
            'Int_listvars_copy', 'paramUbounds_copy'); % [runID; parameters; retval]
        if ~isequal(listvars_copy,listvars) || ~isequal(paramUbounds_copy,paramUbounds) || ~isequal(Int_listvars_copy,Int_listvars)
            % Check if imported dataset matches the current running
            % optimisation, otherwise concatenation won't work
            error('runOneGeneration2: data in list_old_individuals.mat does not match current optimisation dataset')
        end
    catch
        list_old_individuals = ones(size(optsIN,1)+nRetvals,0);
    end
    
    szList_old_individuals = size(list_old_individuals, 2);
    list_old_individuals = [list_old_individuals, NaN(size(optsIN,1)+nRetvals, nInd)]; %%%%%%%%% Concatenation involves an empty array with an incorrect number of rows.
    
    fprintf(1, 'Adding %d jobs\n', nInd);
    lastResume = 0;
    foundMatch = [];
    
    
    for i = 1:nInd
        curResults(i).retval = [];
        stopSearching = 0;
        foundMatch(i) = 0;
        % try to figure out if that individual did already run
        for jj = 1:szList_old_individuals
            j = lastResume + jj;
            if j > szList_old_individuals
                j = j - szList_old_individuals;
            end
            if sum(optsIN(:, i) ~= list_old_individuals(1:(end-nRetvals), j)) == 0 && stopSearching == 0
                if ~isinf(list_old_individuals(end, j))
                    % if it was analyzed
                    results(i).retval = list_old_individuals((end-nRetvals+1):end, j);
                    curResults(i) = results(i);
                    foundMatch(i) = 1;
                    stopSearching = 1;
                    lastResume = j;
                    break;
                else
                    % it was never analyzed
                    foundMatch(i) = 0;
                    stopSearching = 1;
                    break;
                end
            end
        end
    end
    
    
    %% load simulink model
    model_copy        = model;
    listvars_copy     = listvars;     % suggested by matlab
    paramUbounds_copy = paramUbounds; % suggested by matlab
    Int_listvars_copy = Int_listvars; % suggested by matlab
    fileName_simInput_copy = fileName_simInput;
    fileName_kite_copy = fileName_kite;
    
    %% define sim input for optimization
    MegAWESkite = yaml.ReadYaml(fileName_kite_copy,false,true);
    
    for i = 1:size(optsIN,2)
        [simInit, ENVMT, controllerGains_traction, ... 
            controllerGains_retraction, tetherParams, pathparam, ...
            actuatorLimit, winchParameter] = ...
            runParamSim(fileName_simInput_copy, MegAWESkite, listvars_copy, ...
            optsIN(:,i), paramUbounds_copy, Int_listvars_copy);
        
        simInit.doPlot = false;
    
        % to be optimized wind speed
        simInP = initAllStructs(model_copy, simInit, ENVMT, controllerGains_traction, ... 
        controllerGains_retraction, tetherParams, pathparam, ...
        actuatorLimit, winchParameter, MegAWESkite);
        simIn(i) = simInP;
    end
    
    %% run simulations
    if sum(foundMatch) ~= nInd
        simOut = parsim(simIn);
        yOUTlog  = getCost_new(optsIN, simOut, simInit, tetherParams.forceMax, ...
          MegAWESkite.MainWing.alphaMax);   %CHECK!! -> cost fun file
    
        list_old_individuals(:, szList_old_individuals+(1:nInd)) = [optsIN; yOUTlog];
    else
        yOUTlog = list_old_individuals(end-nRetvals+1:end,runID+(1:nInd));
        list_old_individuals(:,(end-nInd+1):end) = []; % delete NaN
    end
    
    yOUT = yOUTlog(end,:);
    
    Simulink.sdi.clear
    
    save('list_old_individuals.mat', 'list_old_individuals', 'listvars_copy', ...
        'paramUbounds_copy', 'Int_listvars_copy');
    try
        parfevalOnAll(gcp,@bdclose,0,'all');
    catch
        %
    end
    runID = runID + nInd;
    fprintf(1, ' done\n');
end