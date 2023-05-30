from datetime import datetime
from yaml import safe_load

with open('../DESCRIPTION') as stream:
    otp = safe_load(stream)

project = otp['Name']
copyright = f'{datetime.now().year} {otp["Author"]}'
author = otp['Author']
version = otp['Version']
release = version

extensions = [
    'sphinxcontrib.matlab',
    'sphinx.ext.autodoc',
    'sphinx.ext.mathjax',
    'sphinx.ext.napoleon',
    'sphinx_math_dollar',
    'sphinx_rtd_theme'
]

primary_domain = 'mat'
matlab_src_dir = '../src'
matlab_keep_package_prefix = False

autodoc_default_options = {
    'member-order': 'bysource',
    'show-inheritance': True
}

html_theme = 'sphinx_rtd_theme'
