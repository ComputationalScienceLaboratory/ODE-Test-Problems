# Running Octave Notebooks locally

You will need an environment with `octave`, `jupyterlab`, and `octave_kernel` packages. Once successfully installed, run Jupyter and open the `quick-start.ipynb` notebook.

## Check out the repository 

```bash 
git clone https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems.git
cd ODE-Test-Problems/notebooks
```

## Install using Anaconda

```bash 
conda env create -f environment.yml
conda activate jupyter-octave
```

## Install using package managers and pip 
Alternatively you can install `Octave` and `jupyter` seperately:
```
sudo apt install octave python3
pip install jupyterlab octave_kernel
```

## Verify that Octave-Kernel is installed

Check to see if octave-kernel is in the list of jupyter kernels:

```
jupyter kernelspec list
```

>  octave     /Users/user/.pyenv/versions/octave/share/jupyter/kernels/octave
>  
>   python3    /Users/use/.pyenv/versions/octave/share/jupyter/kernels/python3
  
 

## Run Jupyter 
Run `jupyterlab` and open the `quick-start.ipynb` notebook. If asked for a kernel, select `octave`:

`jupyterlab`
