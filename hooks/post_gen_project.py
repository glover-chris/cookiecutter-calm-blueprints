# Cookiecutter post and pre hooks working directory is the root of the generated project, e.g., {{cookiecutter.blueprints_folder_name}}.
# Author: Chris Glover <chris.glover@nutanix.com>
# Date Created: 07/02/2021

import os
from os import listdir

# get current working directory and remove all .jinja2 template files from the generated cookiecutter project.
cwd = os.getcwd()
for file_name in listdir(cwd):
    if file_name.endswith('.jinja2'):
        os.remove(file_name)