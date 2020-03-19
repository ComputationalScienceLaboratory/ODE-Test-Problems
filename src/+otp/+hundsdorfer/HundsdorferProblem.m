classdef HundsdorferProblem < otp.Problem
  methods
    function obj = HundsdorferProblem(timeSpan, y0, parameters)
      obj@otp.Problem('Hundsdorfer PDE Problem',numel(y0), timeSpan, y0 , parameters);
    end
  end
  
  methods (Access = protected)
    function onSettingsChanged(obj)
      np = obj.Parameters.np;
      alpha = obj.Parameters.alpha;
      k = obj.Parameters.k;
      s = obj.Parameters.s;
      bval = obj.Parameters.bfun;
      x = obj.Parameters.x;
      dx = x(2)-x(1);
      
      D1x = sparse(np-1,np-1);
      
      D1x(1,1:4) =  ...
        1/(12*dx)*[-10,18,-6,1];
      
      D1x(2,1:4) = ...
        1/(12*dx)*[-8,0,8,-1];
      
      for i = 3:np-3
        D1x(i,i-2:i+2) = ...
          1/(12*dx)*[1,-8,0,8,-1];
      end
      
      D1x(np-2,np-5:np-1) = ...
        1/(12*dx)*[-1,6,-18,10,3];
      
      D1x(np-1,np-5:np-1) = ...
        1/(12*dx)*[3,-16,36,-48,25];
      
      boundaryVec = @(bcval) [bcval.*[-3,1]/(12*dx), zeros(1,np-3)]';
      
      obj.Rhs = otp.Rhs(@(t, y) otp.hundsdorfer.f(t, y,alpha, D1x, k, s ,bval, boundaryVec), ...
      otp.Rhs.FieldNames.Jacobian, @(t, y) otp.hundsdorfer.jac(t, y,alpha, D1x, k, s ,bval, boundaryVec));
      
    end
    
    function validateNewState(obj, newTimeSpan, newY0, newParameters)
                 otp.utils.StructParser(newParameters) ...
                .checkField('k', 'numeric', 'real', 'finite') ...
                .checkField('s', 'numeric', 'real', 'finite') ...
                .checkField('bfun', 'function') ...
                .checkField('alpha', 'numeric', 'real', 'finite');
    end
    
    function sol = internalSolve(obj, varargin)
      sol = internalSolve@otp.Problem(obj, 'Method', @ode15s, ...
        'AbsTol', 1e-10, 'RelTol', 1e-9, 'Jacobian', obj.Rhs.Jacobian ,varargin{:});
    end
  end
end

