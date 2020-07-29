classdef ArenstorfProblem < otp.Problem
  % The classic  3-body  problem with parameters from
  % Reference:  Hairer, Ernst, Syvert Paul Nørsett, and Gerhard Wanner.
  % Solving Ordinary Differential Equations I: Nonstiff Problems Springer-Verlag, 1987.
  % CH II, p. 129.
  methods
    function obj = ArenstorfProblem(timeSpan, y0, parameters)
      obj@otp.Problem('Arenstorf Orbit Problem', 4, timeSpan, y0, parameters);
    end
  end
  
  methods (Access=protected)
    
    function onSettingsChanged(obj)
      m1 = obj.Parameters.m1;
      m2 = obj.Parameters.m2;
      
      obj.Rhs = otp.Rhs( @(t, y) otp.arenstorf.f(t, y, m1, m2), ...
        otp.Rhs.FieldNames.Jacobian, @(t, y) otp.arenstorf.jac(t, y, m1, m2));
    end
    
    
    function validateNewState(obj, newTimeSpan, newY0, newParameters)
      validateNewState@otp.Problem(obj, newTimeSpan, newY0, newParameters);
      
      otp.utils.StructParser(newParameters) ...
        .checkField('m1', 'scalar', 'real', 'finite', 'positive') ...
        .checkField('m2', 'scalar', 'real', 'finite', 'positive');
    end
    
    function mov = internalMovie(obj, t, y, varargin)
      mov = otp.utils.movie.PhasePlaneMovie(obj.Name, @obj.index2label, varargin{:});
      mov.record(t, y(:,1:2));
    end
    
  end
end
