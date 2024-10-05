# Running Octave Notebooks locally

You will need an environment with `octave`, `jupyterlab`, and `octave_kernel` packages. Follow these steps to install the required dependencies:

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

## Verify the installation
Make sure `Octave` is installed:
``` octave --version```

> GNU Octave, version 8.2.0
> 


and check to see if octave-kernel is in the list of jupyter kernels:

```
jupyter kernelspec list
```

>  octave     /Users/user/.pyenv/versions/octave/share/jupyter/kernels/octave
>  
>   python3    /Users/use/.pyenv/versions/octave/share/jupyter/kernels/python3
  
 
## Run Jupyter 
To interact with the notebook, run Jupyter and open the `quick-start.ipynb` notebook:

`jupyter lab quick-start.ipynb`

If asked for a kernel, select `octave`. You can also read the non-interactive github version of the [quick-start notebook](quick-start.ipynb).




