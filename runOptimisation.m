% runOptimisation Optimisation execution script based on given yaml inputs (Lib)
%
% Returns:
%     list_old_individuals.mat (file): CMAES optimisation history
%
% Author:
%      Dylan Eijkelhof (d.eijkelhof@tudelft.nl)
%
% Date:
%     2024-10-31

%% Set folder dependencies

directoriesToAdd = {'Lib','Src','Optimisation'};
initialiseWorkspaceAndFolders(directoriesToAdd,{'numProcs'})
%%
global runID
global listvars paramUbounds model Int_listvars
global fileName_simInput fileName_kite
runID = 0;

if ~exist('numProcs','var')
    numProcs=4;
end

c = parcluster('local');
c.NumWorkers = numProcs;
if ~exist('tmpStorage',"dir")
    mkdir('tmpStorage')
end
c.JobStorageLocation = 'tmpStorage';
parpool(c, c.NumWorkers);

if exist('list_old_individuals.mat','file')
    movefile('list_old_individuals.mat',sprintf('%s_list_old_individuals.mat',datetime('today')))
end
delete('outcmaes*.dat')
delete('variablescmaes.mat')

%% Importing input parameters
model = 'simL0_multiPath';
fileName_simInput = 'circle_simInput.yaml';
fileName_optBounds = 'circle_opt_params_limits.yaml';
fileName_kite = 'MegAWESkite.yaml';

[listvars, x_init, paramUbounds, paramLbounds, Int_listvars] = ...
    defineOptParamsBounds(fileName_simInput, fileName_optBounds);

%% Set initial optimization parameters

paramsFull = x_init./paramUbounds; % normalisation
paramLbounds = paramLbounds./paramUbounds; % normalisation
paramSigma = (paramUbounds./paramUbounds - paramLbounds) * 0.3;

opts = cmaes('defaults');
opts.EvalParallel = 'yes'; % objective function FUN accepts NxM matrix, with M>1?
opts.EvalInitialX = 'yes'; % evaluation of initial solution
opts.PopSize = 100;%50; % (4 + floor(3*log(N)))  % population size, lambda
opts.Resume = 'no'; % resume former run from SaveFile
opts.DiagonalOnly = 0; % OPTS.DiagonalOnly > 1 defines the number of initial iterations, where the covariance matrix remains diagonal
opts.LBounds = paramLbounds;
opts.UBounds = paramUbounds./paramUbounds; % normalisation
opts.CMA.active = 1; % active CMA 1: neg. updates with pos. def. check, 2: neg. updates
opts.StopOnStagnation = 0;
opts.StopOnWarnings = 0;
opts.StopOnEqualFunctionValues = 0; 
opts.TolHistFun = 1e-20;

XMIN = cmaes('runOneGeneration2', paramsFull, paramSigma, opts);
% delete(gcp());
exit
