from pathlib import Path
from re import search

cwd = Path(__file__).resolve().parent
for problem in cwd.glob('../src/+otp/*/*Problem.m'):
    with problem.open() as stream:
        problem_name = search("@otp\\.Problem\\('(.+)',",
                              stream.read()).groups()[0]

    with cwd.joinpath(f'build/problems/{problem.stem}.rst').open('w') as stream:
        stream.write(f'''
{problem_name}
================================================================================
.. automodule:: +otp.{problem.parent.name}
.. autoclass:: {problem.stem}
    :show-inheritance:
    :members:

Parameters
--------------------------------------------------------------------------------
.. autoclass:: {problem.stem[:-7]}Parameters
    :members:

Presets
--------------------------------------------------------------------------------
.. automodule:: +otp.{problem.parent.name}.+presets
''')

        for preset in problem.parent.glob('+presets/*.m'):
            stream.write(f'''
.. autoclass:: {preset.stem}
    :show-inheritance:
    :members:
''')
