# Contributing Guide

This guide provides instructions for submitting and formatting new code in OTP. 

## Submitting Changes

Changes to OTP should be proposed as a pull request and undergo a review process before being merged. New code must be free of warnings and errors and adhere to the [style guidelines](#style-guidelines).

## Creating a Problem

Each problem defines a package under `+otp` that contains all files used by the problem. When creating a new problem we recommend duplicating an existing problem package, e.g., [Lorenz63](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/blob/master/toolbox/+otp/+lorenz63) or [Brusselator](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/blob/master/toolbox/+otp/+brusselator), then renaming and editing the contents as needed.

To add a new test problem from scratch follow these steps:

1. Check out the latest version of OTP:

```bash
git clone https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems.git
cd ODE-Test-Problems/
```

2. Create a new folder in the `toolbox/+opt/` directory with a name that starts with `+` to indicate it is a package. Also create a subfolder named `+presets` in the new problem folder:

```bash
mkdir toolbox/+opt/+example
cd toolbox/+opt/+example
mkdir +presets
```

3. The minimal set of files needed inside the problem folder to set up a new example problem are:
  *  The right-hand side (RHS) function named as `f.m` 
  *  The problem class to specify properties, override plotting and solver options, and convert parameters into arguments for RHS functions
  *  The parameters class
  *  A `Canonical.m` preset inside the `+presets` subfolder to set standard initial condition and parameters.

```bash
touch f.m ExampleProblem.m ExampleParameters.m +presets/Canonical.m
``` 

### The RHS Function

The RHS function `f.m`, which is the time-derivative of the state `y`, is defined as a function with at least two arguments. If parameters are needed, they can be added as arguments.

```matlab
function dy = f(t, y, param1, ...)
  dy = ... 
end
```

Other functions associated with an `otp.RHS` like the Jacobian and mass matrix should be implemented in separate `.m` files with the same function signature as `f.m`.

### The Problem Class 

A problem package must contain a class named `<Name>Problem.m` that is a subclass of `otp.Problem`. There are two methods that must be implemented: the constructor and `onSettingsChanged`. Optionally, one can override functions such as `internalPlot` and `internalSolve` to provide problem-specific defaults. Partitioned problems can add custom RHS functions as class properties with private write access. The property name should start with `RHS`, e.g., `RHSStiff`.

A basic template for a new class of problems called `Example` looks like

```matlab
classdef ExampleProblem < otp.Problem
    methods
        function obj = ExampleProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Example', [], timeSpan, y0, parameters);
            % The second argument specifies the number of variables in the problem is arbitrary
        end
    end
    
    methods (Access=protected)        
        function onSettingsChanged(obj)
            % Parameters are stored in the obj.Parameters structure. We can assign them to individual variables to be
            % used in function calls
            param1 = obj.Parameters.Param1;

            % set up the RHS function wrapper
            obj.RHS = otp.RHS(@(t, y) otp.example.f(t, y, param1));
        end
        
        % set up internal plot function
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, 'xscale', 'log', 'yscale', 'log', varargin{:});
        end
        
        % set up internal movie function
        function mov = internalMovie(obj, t, y, varargin)
            mov = internalMovie@otp.Problem(obj, t, y,, 'xscale', 'log', 'yscale', 'log', varargin{:});
        end
        
        % set up internal solver 
        function sol = internalSolve(obj, varargin)
            % Set tolerances due to the very small scales
            sol = internalSolve@otp.Problem(obj, 'AbsTol', 1e-50, varargin{:});
        end
    end
end
```

### The Parameters Class 

A problem package must also contain a class named `<Name>Parameters.m` that is a subclass of `otp.Parameters`. It needs to provide public properties for each of the problem parameters and a constructor which forwards arguments to the superclass constructor; no methods are needed. Note that property validation is currently not supported in Octave. Therefore, we use a custom comment syntax that is parsed by the installer to optionally include validation. The following is an example of a parameter class with property validation:

```matlab
classdef ExampleParameters
    properties
        Param1 %MATLAB ONLY: (1,1) {mustBeReal, mustBeNonnegative}
    end

    methods
        function obj = ExampleParameters(varargin)
            obj = obj@otp.Parameters(varargin{:});
        end
    end
end
```

### Adding presets

Within a problem package, there should be a subpackage named `+presets`. This contains subclasses of `<Name>Problem` that specify the time span, initial conditions, and parameters. Typically, only the constructor needs to be implemented in a preset class.

In our example, we add a `Canonical.m` preset inside the `+presets` subfolder.

```matlab
classdef Canonical < otp.example.ExampleProblem

    methods
        function obj = Canonical(varargin)
            y0 = ... 
            tspan = ...

            % Specify a default value for Param1 which can be overridden by a name-value pair passed to this constructor
            params = otp.example.ExampleParameters('Param1', pi, varargin{:});

            obj = obj@otp.example.ExampleProblem(tspan, y0, params);
        end
    end
end
```

## Style Guidelines

In order for this project to maintain a consistent coding style, the following conventions should be used. These standards largely match those most commonly used in MATLAB's code and documentation.

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

Package names should be completely lowercase and start with a plus symbol. No capitalization or special character is used to distinguish between words.

```matlab
% Example
% Path: +otp/+utils/PhysicalConstants.m
help otp.utils.PhysicalConstants
```

### Classes

Class names and properties should be written in Pascal case. When the name contains an acronym, all letters should be capitalized. Methods should be written in camel case.

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
