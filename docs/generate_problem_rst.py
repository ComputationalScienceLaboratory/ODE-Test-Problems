from pathlib import Path
from re import search

cwd = Path(__file__).resolve().parent
problem_dir = cwd.joinpath('problems')
problem_dir.mkdir(exist_ok=True)
for file in problem_dir.glob('*'):
    file.unlink()

for problem in cwd.glob('../toolbox/+otp/*/*Problem.m'):
    with problem.open() as stream:
        problem_name = search("@otp\\.Problem\\('(.+)',",
                              stream.read()).groups()[0]

    with problem_dir.joinpath(f'{problem.stem}.rst').open('w') as stream:
        stream.write(f'''
{problem_name}
================================================================================
.. automodule:: +otp.{problem.parent.name}
.. autoclass:: {problem.stem}
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
    :members:
''')
