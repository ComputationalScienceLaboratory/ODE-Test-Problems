# Available test problems

You can use any of the problems using the template command

`model = otp.{problem name}.presets.{Preset name};`

Here is a table of test problems currently implemented in `OTP`. A default `{Preset name}` for all implemented problems is `Canonical`. Other presets are specific to each test problem.

| Test Problem       | Description                                                                                         |
|--------------------|-----------------------------------------------------------------------------------------------------|
| allencahn          | The Allen-Cahn equation models phase separation and pattern formation.                               |
| ascherlineardae    | A linear advection-diffusion equation used to study numerical stability.                            |
| arenstorf          | The Arenstorf orbit problem models a spacecraft's trajectory around the moon.                        |
| bouncingball       | A simple bouncing ball model used to study event detection and simulation.                           |
| brusselator        | The Brusselator is a simple model for chemical reactions that exhibits oscillatory behavior.         |
| cusp               | The cusp equation models a system with a fold bifurcation.                                           |
| e5                 | A set of differential equations describing a predator-prey model with spatial interactions.         |
| hires              | A set of differential equations used to study high-dimensional chaos and long-term integration.     |
| inverterchain      | A chain of inverters used to study coupled oscillators.                                              |
| kpr                | The KPR model is used to study pattern formation in chemical reactions.?                              |
| lienard            | The Lienard equation models a system with a Hopf bifurcation.                                        |
| lorenz63           | The Lorenz 63 system is a simple model for atmospheric convection that exhibits chaotic behavior.    |
| lorenz96           | A set of differential equations used to study atmospheric dynamics and chaos.                       |
| lotkavolterra      | A set of differential equations modeling population dynamics in predator-prey systems.             |
| nbody              | A set of differential equations describing the motion of N interacting point masses.               |
| oregonator         | The Oregonator model is a set of differential equations used to study oscillatory behavior.         |
| pendulum           | The simple pendulum equation models the motion of a swinging pendulum.                               |
| protherorobinson   | The Prothero-Robinson system is used to study the stability of numerical schemes.                   |
| quadratic          | A simple quadratic model used to study numerical methods for ODEs.                                   |
| robertson          | The Robertson reaction model is a set of differential equations used to study chemical kinetics.     |
| sanzserna          | A set of differential equations used to study numerical methods for DAEs.                           |
| torus              | The torus equation models the motion of a point on a torus.                                           |
| transistoramplifier | A set of differential equations modeling the behavior of a common emitter transistor amplifier circuit. |
| trigonometricdae   | A set of differential-algebraic equations used to study numerical methods for DAEs.                 |
| vanderpol          | The van der Pol oscillator models the behavior of an electronic oscillator.                          |