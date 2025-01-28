Project Structure
=================

The ODE Test Problems API resides under the ``otp`` namespace. At the top level of this namespace, there are three
classes that serve as the foundation for all problem implementations:

.. toctree::
   
   problem
   rhs
   parameters

Each problem in OTP defines a sub-namespace of ``otp`` with a standard structure:

::

   otp.<problemname>
   ├─ <ProblemName>Problem.m
   ├─ <ProblemName>Parameters.m
   └─ presets
      ├─ Canonical.m
      ├─ <PresetName>.m
      ├─ <AnotherPresetName>.m
      └─ ...

This allows a problem to be manually instantiated with

>>> timeSpan = ...
>>> y0 = ...
>>> parameters = otp.<problemname>.<ProblemName>Parameters('<Param1>', value1, ...);
>>> problem = otp.<problemname>.<ProblemName>Problem(timeSpan, y0, parameters);

In most cases, it is easier to use a preset instead. A preset is a subclass of ``<ProblemName>Problem.m`` which
specifies values for the problem time span, initial conditions, and parameters, typically using values proposed in the
literature. Every problem has a preset named ``Canonical`` which can be constructed with

>>> problem = otp.<problemname>.presets.Canonical;

Constructors for presets can be called without arguments like the code above, but many presets also accept optional
name-value pairs to override default values. Regardless, parameters can always be modified after instantiating a
problem:

>>> problem.Parameters.<Param1> = 1234;
