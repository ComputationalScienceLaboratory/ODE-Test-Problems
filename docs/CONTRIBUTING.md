# Contributing to ODE Test Problems

This guide provides instructions for submitting and formatting new code in OTP.

## Submitting Changes

Changes to OTP should be proposed as a pull request and undergo a review process
before being merged into master. New code must be free of warnings and errors
and adhere to the style guidelines.

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
rhsFun = @(t, y) y + sin(t);
```

### Functions

Functions should be completely alphanumeric and lowercase. No capitalization or
special character is used to distinguish between words.

```matlab
% Example
function r = depthfirstsearch(tree)
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

Class names and properties should be written in Pascal case. Methods should be
written in camel case.

```matlab
% Example
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
