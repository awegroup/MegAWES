classdef DateTime
    % DateTime Class for handling date and time operations
    % 
    % This program is a result of a cooperation between Energocentrum PLUS, s.r.o.
    % and Czech Technical University (CTU) in Prague.
    % Maintained by Energocentrum PLUS, s.r.o., licensed under the MIT license.
    %
    % Author(s):
    %   Jiri Cigler, Dept. of Control Engineering, CTU Prague & ETH Zurich
    %   Jan Siroky, Energocentrum PLUS s.r.o.
    %
    % Implementation and Revisions:
    %   jc    01-Mar-11   First implementation
    %   jc    30-Sep-11   Added function colon
    %   jc    07-Jan-12   Added functions addtodate, datevec, weekday

    properties
        serialDate % Stores MATLAB's serial date number
    end
    
    methods
        % Constructor
        function this = DateTime(varargin)
            if numel(varargin) == 1 && isa(varargin{1}, 'java.util.Date')
                sec = varargin{1}.getTime / 1000;
                this.serialDate = datenum(1970, 1, 1, 0, 0, sec);
            else
                this.serialDate = datenum(varargin{:});
            end
        end
        
        % Arithmetic Operations
        function this = plus(this, val)
            this = doFun(this, @plus, val);
        end
        
        function this = minus(this, val)
            this = doFun(this, @minus, val);
        end
        
        function this = times(this, val)
            this = doFun(this, @times, val);
        end
        
        function this = mtimes(this, val)
            this = doFun(this, @mtimes, val);
        end
        
        function this = rdivide(this, val)
            this = doFun(this, @rdivide, val);
        end
        
        function this = mrdivide(this, val)
            this = doFun(this, @mrdivide, val);
        end

        % Concatenation
        function this = horzcat(this, varargin)
            for i = 1:numel(varargin)
                this.serialDate = [this.serialDate, varargin{i}.serialDate];
            end
        end
        
        function this = vertcat(this, varargin)
            for i = 1:numel(varargin)
                this.serialDate = [this.serialDate; varargin{i}.serialDate];
            end
        end
        
        % Transpose
        function this = ctranspose(this)
            this.serialDate = this.serialDate';
        end
        
        function this = transpose(this)
            this.serialDate = this.serialDate';
        end
        
        % Display
        function disp(this)
            disp(this.serialDate);
        end
        
        % Conversion
        function out = double(this)
            out = this.serialDate;
        end
        
        % Basic Properties
        function out = length(this)
            out = length(this.serialDate);
        end
        
        function out = size(this, varargin)
            out = size(this.serialDate, varargin{:});
        end
        
        function out = numel(this)
            out = numel(this.serialDate);
        end
        
        % Logical Checks
        function out = isreal(this)
            out = isreal(this.serialDate);
        end
        
        function out = isnan(this)
            out = isnan(this.serialDate);
        end
        
        function out = isfinite(this)
            out = isfinite(this.serialDate);
        end

        % Relational Operations
        function out = le(this, B)
            out = compare(this, B, @le);
        end

        function out = lt(this, B)
            out = compare(this, B, @lt);
        end

        function out = gt(this, B)
            out = compare(this, B, @gt);
        end

        function out = eq(this, B)
            out = compare(this, B, @eq);
        end
        
        % Sorting
        function [this, idx] = sort(this, varargin)
            [this.serialDate, idx] = sort(this.serialDate, varargin{:});
        end
        
        % Indexing
        function this = subsref(this, S)
            if isa(S.subs{1}, 'DateTime')
                S.subs{1} = double(S.subs{1});
            end
            this.serialDate = subsref(this.serialDate, S);
        end
        
        function idx = subsindex(this)
            idx = double(this) - 1;
        end
        
        function endIdx = end(this, k, n)
            if isvector(this.serialDate)
                endIdx = numel(this.serialDate);
            else
                endIdx = size(this.serialDate, k);
            end
        end
        
        function this = subsasgn(this, S, B)
            if ~isa(B, 'DateTime')
                B = DateTime(B);
            end
            this.serialDate = subsasgn(this.serialDate, S, B);
        end
        
        % Specialized Methods
        function out = datestr(this, varargin)
            out = datestr(this.serialDate, varargin{:});
        end
        
        function out = addtodate(this, varargin)
            out = addtodate(this.serialDate, varargin{:});
        end
        
        function varargout = datevec(this, varargin)
            [varargout{1:nargout}] = datevec(this.serialDate, varargin{:});
        end
        
        function out = norm(this, varargin)
            out = norm(this.serialDate, varargin{:});
        end
        
        function out = diff(this)
            out = diff(this.serialDate);
        end
    end
    
    methods (Access = private)
        % Private utility function for arithmetic operations
        function this = doFun(this, op, val)
            if isa(val, 'DateTime')
                this.serialDate = op(this.serialDate, val.serialDate);
            else
                this.serialDate = op(this.serialDate, val);
            end
        end
        
        % Private comparison utility
        function out = compare(this, B, op)
            if isa(B, 'DateTime')
                out = op(this.serialDate, B.serialDate);
            else
                out = op(this.serialDate, B);
            end
        end
    end
end