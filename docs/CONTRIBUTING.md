# Contributing to ODE Test Problems

This guide provides instructions for submitting and formatting new code in OTP.

## Submitting Changes

Changes to OTP should be proposed as a pull request and undergo a review process
before being merged into master. New code must be free of warnings and errors
and adhere to the style guidelines.

## Creating a Problem

Each problem defines a package under `+otp` that contains all files used by the
problem. When creating a new problem, we recommend duplicating an existing
problem package, then renaming and editing the contents as needed.

### Problem Class

A problem package must contain a class named `<Name>Problem.m` that is a
subclass of `otp.Problem`. There are two methods that must be implemented: the
constructor and `onSettingsChanged`. Optionally, one can override functions such
as `internalPlot` and `internalSolve` to provide problem-specific defaults.
Partitioned problems can add custom `RHS`'s as class properties with private
write access. The property name should start with `RHS`, e.g., `RHSStiff`.

### Parameters

A problem package must also contain a class named `<Name>Parameters.m`. It only
needs to provide public properties for each of the problem parameters; no
constructor or methods are needed. Property validation is currently not
supported in Octave. Therefore, we use a custom comment syntax that is parsed by
the installer to optionally include validation.

```matlab
% Example
properties
    MyProp %MATLAB ONLY: (1,1) {mustBeInteger, mustBePositive}
end
```

### Functions for `RHS`

Functions provided through a problem's `RHS` are implemented in function files.
The names should match (up to capitalization) the `RHS` property names, e.g.,
`jacobianVectorProduct.m`. Functions for custom `RHS`'s should include a
descriptor at the end, e.g., `jacobianStiff.m`.

### Presets

Within a problem package, there should be a subpackage named `+presets`. This
contains subclasses of `<Name>Problem` that specify the timespan, initial
conditions, and parameters. Typically, only the constructor needs to be
implemented in a preset class.

## Style Conventions

In order for this project to maintain a consistent coding style, the following
conventions should be used. These standards match those most commonly used in
MATLAB's code and documentation.

### Line Formatting

Four spaces are used for indentation. A line should be kept to 80 characters or
less.

### Variables

Variable names should be written in camel case.

```matlab
% Examples
data = 4;
maxEigenvalue = eigs(rand(4), 1);
fun = @(t, y) y + sin(t);
```

### Functions

Functions should be completely alphanumeric and written in camel case. No
special character is used to distinguish between words.

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

Package names should be completely lowercase and start with a plus symbol. No
capitalization or special character is used to distinguish between words.

```matlab
% Example
% Path: +otp/+utils/PhysicalConstants.m
help otp.utils.PhysicalConstants
```

### Classes

Class names and properties should be written in Pascal case. When the name
contains an acronym, all letters should be capitalized. Methods should be
written in camel case.

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

### Documentation

All non-private variables, classes, and functions should provide documentation.
The first line, known as H1, should start with the name of the function in
uppercase followed by a brief, one-line descriptions. Subsequent lines start
with three spaces (single tab press) and give additional details and usage info.
For problems, the documentation should provide the governing ODE. Original and
supporting sources should be listed at the end of documentation (but before "See
also") in MLA format.

```matlab
% Example
classdef MyProblem < otp.Problem
%MYPROBLEM A simple test problem
%   This problem models the ODE
%
%   y' = cos(y)
%
%   Sources:
%   Doe, John, and Jane Doe. "Title." Journal of Testing 123.4 (2021): 10-20.
%
%   See also ANOTHERPROBLEM
end
```
