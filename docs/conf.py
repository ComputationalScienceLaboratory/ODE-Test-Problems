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
    'sphinx_rtd_theme'
]

primary_domain = 'mat'
matlab_src_dir = '../src'
matlab_keep_package_prefix = False

autodoc_member_order = 'bysource'

html_theme = 'sphinx_rtd_theme'

html_theme_options = {
    'style_nav_header_background': '#861F41'
}

html_logo = '../logo.svg'
