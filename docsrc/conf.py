# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'ODE Test Problems'
copyright = '2023, Steven Roberts, Andrey A Popov, Arash Sarshar, Adrian Sandu'
author = 'Steven Roberts, Andrey A Popov, Arash Sarshar, Adrian Sandu'
release = '0.1'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = ['sphinxcontrib.matlab', 'sphinx.ext.autodoc', 'sphinx.ext.mathjax']


templates_path = ['_templates']
exclude_patterns = []
primary_domain = "mat"
matlab_src_dir = "src"
matlab_keep_package_prefix = False


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

#html_theme = 'alabaster'
html_theme = 'classic'
html_static_path = ['_static']

#html_sidebars = { '**': ['globaltoc.html', 'relations.html', 'sourcelink.html', 'searchbox.html'] }

html_sidebars = { '**': ['globaltoc.html', 'searchbox.html'] }


###
# Configure the theme
###

html_theme_options = {
    "sidebarbgcolor": "#E5E1E6",
    "sidebartextcolor": "#000000",
    "sidebarlinkcolor": "#861F41",
    "relbarbgcolor": "#000",
    "linkcolor": "#861F41",
    "visitedlinkcolor": "#861F41",
    "headbgcolor": "#E5E1E6",
    "headtextcolor": "#000"
}

