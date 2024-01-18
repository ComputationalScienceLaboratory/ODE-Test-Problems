from datetime import datetime
from yaml import safe_load

import os
import shutil

def copy_webm_files(source_dir, destination_dir):
    # Get a list of all files in the source directory
    files = os.listdir(source_dir)

    if not os.path.exists(destination_directory):
        os.makedirs(destination_directory)

    # Iterate over each file
    for file in files:
        # Check if the file is a .webm file
        if file.endswith(".webm"):
            # Create the full path of the source file
            source_file = os.path.join(source_dir, file)

            # Create the full path of the destination file
            destination_file = os.path.join(destination_dir, file)

            # Copy the file to the destination directory
            shutil.copy2(source_file, destination_file)


source_directory = "../images/animations/"
destination_directory = "../docs/build/_static"
copy_webm_files(source_directory, destination_directory)

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
    'sphinxcontrib.video',
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


