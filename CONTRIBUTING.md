# Contributing Guide

This guide provides instructions for submitting and formatting new code in `OTP`. 

## Submitting Changes

Changes to `OTP` should be proposed as a pull request and undergo a review process before being merged. New code must be free of warnings and errors and adhere to the style guidelines (see also [The style guidelines](## Style guidelines)).

## Creating a Problem

Each problem defines a package under `+otp` that contains all files used by the problem. To add a new test problem follow these steps:

1. Check out the latest version of `OTP`:

```bash
git clone https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems.git
cd ODE-Test-Problems/
```

2. Create a new folder in the `src/+opt/` directory. Follow the same naming conventions as the existing problems. Start the name with `+` to maintain the structure of the Matlab/Octave package. Also create a subfolder named `+presets` in the new problem folder:

```bash
mkdir src/+opt/+newtest
mkdir src/+opt/+newtest/+presets
cd src/+opt/+newtest/
```

3. The minimal set of files needed inside the problem folder to set up a new test problem are:
  *  The right-hand-side function named as `f.m` 
  *  The problem class to initialize problem objects and its methods and properties
  *  The parameters class defines the parameters of the new problem
  *  A `Canonical.m` preset inside the `+presets` subfolder to set the initial condition and parameters in your case

 ```bash
    touch f.m
    touch NewTestProblem.m
    touch NewTestParameters.m
    touch +presets/Canonical.m
``` 

## The Right-hand-side Structure

The right-hand-side structure provides various derivatives of the problem. They are implemented in separate function files. The right-hand-side function `f.m`, which is the time-derivative of the state `y` is defined as a function with at least two arguments `f(t,y)`. If the right-hand-side function needs other parameters they can also be passed to this function:

```Matlab

function dy = f(t, y, Param1, ...)
  dy  = ... 
end

```

For more information about this formulation please refer to our [paper](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/blob/master/paper/paper.md).

## The Problem Class 

A problem package must contain a class named `<Name>Problem.m` that is a subclass of `otp.Problem`. There are two
methods that must be implemented: the constructor and `onSettingsChanged`. Optionally, one can override functions such as `internalPlot` and `internalSolve` to provide problem-specific defaults. Partitioned problems can add custom right-hand-side functions
as class properties with private write access. The property name should start with `RHS`, e.g., `RHSStiff`.

The template for a new class of problems called `NewTest` looks like:

```Matlab

classdef NewTestProblem < otp.Problem

    methods
        function obj = NewTestProblem(timeSpan, y0, parameters)
            obj@otp.Problem('New Test', [], timeSpan, y0, parameters);
        end
    end
    
    methods (Access=protected)        
        function onSettingsChanged(obj)

            % parameters are stored in the obj.Parameters structure 
            % We can assign them to individual variables 
            % to be used in function calls

            Param1 = obj.Parameters.Param1; % ...


            % set up the right-hand-side function wrapper
            obj.RHS = otp.RHS(@(t, y) otp.newtest.f(t, y, Param1), 1:obj.NumVars);
        end
        
        % set up internal plot function
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, ...
                'xscale', 'log', 'yscale', 'log', varargin{:});
        end
        
        % set up internal movie function
        function mov = internalMovie(obj, t, y, varargin)
            mov = internalMovie@otp.Problem(obj, t, y, ...
                'xscale', 'log', 'yscale', 'log', varargin{:});
        end
        
        % set up internal solver 
        function sol = internalSolve(obj, varargin)
            % Set tolerances due to the very small scales
            sol = internalSolve@otp.Problem(obj, ...
                'AbsTol', 1e-50, varargin{:});
        end
    end
end

```

## The Parameters Class 

A problem package must also contain a class named `<Name>Parameters.m`. It only needs to provide public properties for each of the problem parameters; no constructor or methods are needed. Note that property validation is currently not supported in Octave. Therefore, we use a custom comment syntax that is parsed by the installer to optionally include validation. The following is an example of a parameter class with property validation:


```Matlab

classdef NewTestParameters

    %NewTestParameters
    properties
        Param1 %MATLAB ONLY: (1,1) {mustBeNumeric, mustBeReal, mustBeNonnegative}
    end
end

```

## Adding presets

Within a problem package, there should be a subpackage named `+presets`. This contains subclasses of `<Name>Problem`
that specify the timespan, initial conditions, and parameters. Typically, only the constructor needs to be implemented
in a preset class.

In our example, we add the `Canonical.m` preset inside the  `+presets` subfolder containing:

```Matlab

classdef Canonical < otp.newtest.NewTestProblem

    methods
        function obj = Canonical
            params = otp.newtest.NewTestParameters;
            params.Param1 = ...

            y0 = ... 
            tspan = ...

            obj = obj@otp.newtest.NewTestProblem(tspan, y0, params);
        end
    end
end


```
## Copying the Problem Template 

When creating a new problem, we
recommend duplicating an existing problem package, then renaming and editing the contents as needed.

 [This is a minimal example of](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/tree/81cf4e473c34fe04d70280d0a78222a4c75fd775/src/%2Botp/%2Bnewtest) the completed test problem started in this tutorial. It implements the trivial ODE $y'(t) = 1, y(0) = 1$ and can be used as a template to implement simple test problems.


An example of a more sophisticated problem with implemented Jacobians is the [Lorenz63 problem](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/blob/master/src/+otp/+lorenz63). For an example of split right-hand-side PDE, see [the Brusselator problem]( https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/blob/master/src/+otp/+brusselator).


## Style Guidelines

In order for this project to maintain a consistent coding style, the following conventions should be used. These
standards match those most commonly used in MATLAB's code and documentation.

### Line Formatting

Four spaces are used for indentation. A line should be kept to 120 characters or less.

### Variables

Variable names should be written in camel case.

```matlab
% Examples
data = 4;
maxEigenvalue = eigs(rand(4), 1);
fun = @(t, y) y + sin(t);
```

### Functions

Functions should be completely alphanumeric and written in camel case. No special character is used to distinguish
between words.

```matlab
% Example
function r = depthFirstSearch(tree)
    ...
end
```

### Structures

Structures should have camel case property names.

```matlab
% Example
car = struct('make', 'Ford', 'modelYear', 2020);
```

### Packages

Package names should be completely lowercase and start with a plus symbol. No capitalization or special character is
used to distinguish between words.

```matlab
% Example
% Path: +otp/+utils/PhysicalConstants.m
help otp.utils.PhysicalConstants
```

### Classes

Class names and properties should be written in Pascal case. When the name contains an acronym, all letters should be
capitalized. Methods should be written in camel case.

```matlab
% Examples
classdef Employee
    properties
        FirstName
        LastName
        Salary
    end

    methods
        function p = calculatePay(hours)
            ...
        end
    end
end

classdef ODETestProblems
    ...
end
```


## Creating Documentation

