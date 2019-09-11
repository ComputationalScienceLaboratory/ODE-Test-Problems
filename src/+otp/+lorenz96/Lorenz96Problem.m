classdef Lorenz96Problem <  otp.Problem
    % Lorenz96Problem  The Lorenz 96 model is a classic model for testing data assimilation techniques.
    % The specifics of this model can be found elsewhere. I will discuss the implementation details.
    % Here we have an implementation of a Parametres.numVars variable Lorenz 96 system 
    
    properties
        DistanceFunction
    end
    
    methods
        function obj = Lorenz96Problem(timeSpan, y0, parameters)

            obj@ otp.Problem('Lorenz-96 Problem', [], timeSpan, y0, parameters);

        end
        
%         function mov = movie(obj, t, y, varargin)
%             
%             numVars = obj.NumVars;
%             
%             ymin = 1.1*min(y(:));
%             ymax = 1.1*max(y(:));
%             plotBounds = [0, numVars+1, ymin, ymax];
%             
%             function plotMovieFrame(ax, curT, curY, ~)
%                 plot(ax, 1:numVars, curY, '-O');
%                 axis(ax, plotBounds, 'square');
%                 title(ax, sprintf('Time = %f', curT));
%                 xlabel('Variable Index');
%                 ylabel('Magnitude');
%             end
%             
%             mov = csl.odeutils.moviemaker(t, y, @plotMovieFrame, ...
%                 varargin{:});
%             
%         end
    end

    methods (Access=protected)
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            
            validateNewState@otp.Problem(obj, ...
                newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('forcingFunction', @(x) isnumeric(x) || isa(x, 'function_handle'));
            
        end
        
        function obj = onSettingsChanged(obj)
            
            N        = obj.NumVars;
            f        = obj.Parameters.forcingFunction;
            
            % We include all the derivatives in all their relevant forms.
            % Other derivatives are zero everywhere.
            
            if isa(f, 'function_handle')
                obj.Rhs = otp.Rhs(@(t, y) ...
                    otp.lorenz96.f(t, y, f), ...
                    otp.Rhs.FieldNames.Jacobian, ...
                    @(t, y) otp.lorenz96.jac(t, y), ...
                    otp.Rhs.FieldNames.JacobianVectorProduct, ...
                    @(t, y, u) otp.lorenz96.jvp(t, y, u), ...
                    otp.Rhs.FieldNames.JacobianAdjointVectorProduct, ...
                    @(t, y, u) otp.lorenz96.javp(t, y, u), ...
                    otp.Rhs.FieldNames.HessianVectorProduct, ...
                    @(t, y, u, v) otp.lorenz96.hvp(t, y, u, v), ...
                    otp.Rhs.FieldNames.HessianAdjointVectorProduct, ...
                    @(t, y, u, v) otp.lorenz96.havp(t, y, u, v));
            else
                obj.Rhs = otp.Rhs(@(t, y) ...
                    otp.lorenz96.fconst(t, y, f), ...
                   otp.Rhs.FieldNames.Jacobian, ...
                    @(t, y) otp.lorenz96.jac(t, y), ...
                    otp.Rhs.FieldNames.JacobianVectorProduct, ...
                    @(t, y, u) otp.lorenz96.jvp(t, y, u), ...
                    otp.Rhs.FieldNames.JacobianAdjointVectorProduct, ...
                    @(t, y, u) otp.lorenz96.javp(t, y, u), ...
                    otp.Rhs.FieldNames.HessianVectorProduct, ...
                    @(t, y, u, v) otp.lorenz96.hvp(t, y, u, v), ...
                    otp.Rhs.FieldNames.HessianAdjointVectorProduct, ...
                    @(t, y, u, v) otp.lorenz96.havp(t, y, u, v));
            end
            
            
            % We also provide a canonical distance function as is standard for
            % localisation in Data Assimilation. This is heavily tied to this
            % problem.
            
            obj.DistanceFunction               = ...
                @(t, y, i, j) otp.lorenz96.distfn(t, y, i, j, N);
            
        end
    end
end
