# Adding new problems to `OTP`

To add a new test problem to `ODE Test Problems` follow these steps. 

1. Check out the latest version of `OTP` from Github

```bash
git clone https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems.git
cd ODE-Test-Problems/
```

2. Create a new folder in the `src/+opt/` directory. Follow the same naming conventions as the existing problems. Start the name with `+` to maintain the structure of the Matlab/Octave package. Also create a subfolder named `+presets` in the new problem folder:

```bash
cdf

```

3. The minimal set of files needed inside the problem folder to set up a new test problem are:
  *  The right-hand-side function named as `f.m` 
  *  The problem class to initialize problem objects and its methods adn properties
  *  The parameters class define the parameters of the new problem
  *  A `Canonical.m` preset inside the `+presets` subfolder to set the initial condition and parameters for your case

## The right-hand-side function

The right-hand-side function defines the time-derivative of the state-variable `y` for your problem. It is defined as a function with at least two arguments `f(t,y)`. If the problem has other parameters they can be passed to the function `f`:

```Matlab

function dy = f(t, y, param1, ...)
  dy  = ... 
end

```
For more information about this formulation please refer to ()

## The problem class 
The problem class is used to set up the problem object and default solvers and plotting methods.
The template for this class looks like:

```Matlab

classdef SimpleProblem < otp.Problem
    methods
        function obj = SimpleProblem(timeSpan, y0, parameters)
            obj@otp.Problem('New Test Problem', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access=protected)        
        function onSettingsChanged(obj)
            param1 = obj.Parameters.param1;

            ...

            obj.RHS = otp.RHS(@(t, y) otp.newtest.f(t, y, param1), 1:obj.NumVars);
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, ...
                'xscale', 'log', 'yscale', 'log', varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = internalMovie@otp.Problem(obj, t, y, ...
                'xscale', 'log', 'yscale', 'log', varargin{:});
        end
        
        function sol = internalSolve(obj, varargin)
            % Set tolerances due to the very small scales
            sol = internalSolve@otp.Problem(obj, ...
                'AbsTol', 1e-50, varargin{:});
        end
    end
end

```

## The parameters class 

```Matlab

classdef SimpleParameters
    %NewTestParameters
    properties
        param1 %MATLAB ONLY: (1,1) {mustBeNumeric, mustBeReal, mustBeNonnegative}
    end
end

```

## Adding presets

In the `+presets` subfolder add the `Canonical.m` preset and set up the specific initial condition and time span for this preset:

```Matlab

classdef Canonical < otp.newtest.SimpleProblem
    methods
        function obj = Canonical
            params = otp.newtest.SimpleParameters;
            params.param1 = ...

            y0 = ... 
            tspan = ...

            obj = obj@otp.newtest.SimpleProblem(tspan, y0, params);
        end
    end
end


```

## (Optional) updating the documentation


