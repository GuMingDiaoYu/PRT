function output = prtOptionsGet(subOptionsName, paramName, varargin)
% prtOptionsGet Returns the current PRT options
%   PRT options are MATLAB classes that reside in the +prtOptions package
%
%   output = prtOptionsGet()
%       Returns all prtOptions as a structure with field names equivalent
%       to the class names.
%
%   output = prtOptionsGet(subOptionsName);
%       Returns an instatiation of the class subOptionsName
%       This is useful to obtain only a subset of options
%           Example: output = prtOptionsGet('prtOptionsRvPlot')
%
%   output = prtOptionsGet(subOptionsName, paramName);
%       Returns the parameter paramName from the class subOptionsName
%       This is useful to obtain only a specific value
%           Example: output = prtOptionsGet('prtOptionsComputation','largestMatrixSize')
%
%   Additional options can be added to the PRT by adding additional classes
%   to the prtOptions package.
%
%   The default PRT options are saved in the .mat file with a location
%   given as output of the function prtOptionsFileName().
%
% See also. prtOptionsSet, prtOptionsGetDefault prtOptionsSetDefault







persistent options

if ~exist('options','var')
    options = [];
end

if isempty(options) % Options is not currently persistant in this funciton
    options = prtOptionsGetDefault();
end

%At this point we can assume that we have the variable options which is
%the full structure of all of the options
switch nargin
    case 0
        output = options;
    case 1
        if ~isfield(options,subOptionsName)
            error('prt:prtOptionsGet','There is no prtOptions class named %s',subOptionsName);
        end
        output = options.(subOptionsName);
        
    case 2
        if ~isfield(options,subOptionsName)
            error('prt:prtOptionsGet','There is no prtOptions class named %s',subOptionsName);
        end
        
        % If the property name doesn't exist we let MATLAB throw the
        % standard bad property name for this class error.
        output = options.(subOptionsName).(paramName);
        
    otherwise
        % This additional input is used only by prtOptionsSet
        % It should not be used by the user.
        assert(isempty(subOptionsName) && isempty(paramName),'Invalid use of prtOptionsGet');
        assert(mod(length(varargin),3)==0,'Invalid use of prtOptionsGet.');
        
        subOptionsNames = varargin(1:3:end);
        paramNames = varargin(2:3:end);
        paramValues = varargin(3:3:end);
        
        assert(iscellstr(subOptionsNames),'Invalid use of prtOptionsGet.');
        assert(iscellstr(paramNames),'Invalid use of prtOptionsGet.');
        
        for iParam = 1:length(subOptionsNames)
            
            % Note that in these error checks we say prtOptionsSet because
            % that is where you called this from right?
            if ~isfield(options,subOptionsNames{iParam})
                error('prt:prtOptionsSet','There is no prtOptions class named %s',subOptionsNames{iParam});
            end
            % If the property name doesn't exist we let MATLAB throw the
            % standard bad property name for this class error.
            % All enforcements of parameter values must be done at the
            % options class level.
            
            options.(subOptionsNames{iParam}).(paramNames{iParam}) = paramValues{iParam};
        end
        output = options;
        
        % At this point we changed some options. 
        clear prtAction prtClass prtRegress prtPreProc prtCluster ...
              prtDataSetStandard prtDataSetClass prtDataSetRegress
end


end
