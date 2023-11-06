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
    'sphinxcontrib.bibtex',
    'sphinx_rtd_theme',
    'myst_parser'
]

exclude_patterns = ['README.md']

primary_domain = 'mat'
matlab_src_dir = '../toolbox'
matlab_keep_package_prefix = False
matlab_auto_link = 'basic'

autodoc_default_options = {
    'member-order': 'bysource',
    'show-inheritance': True
}

bibtex_bibfiles = ['references.bib']

html_theme = 'sphinx_rtd_theme'
html_logo = '../images/logo.png'
html_theme_options = {
    'logo_only': True
}
