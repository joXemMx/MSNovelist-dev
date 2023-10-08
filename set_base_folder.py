# script to set base_folder in config automatically

import os

parent_folder = os.path.dirname(os.path.abspath(__file__))

# set for config.DOCKER-LIGHT.yaml
yaml_file_path = f'{parent_folder}/config.DOCKER-LIGHT.yaml'
with open(yaml_file_path, 'r') as yaml_file:
    yaml_lines = yaml_file.readlines()
yaml_lines[0] = f'base_folder: {parent_folder}/\n'
with open(yaml_file_path, 'w') as yaml_file:
    yaml_file.writelines(yaml_lines)

# set for config.yaml
yaml_file_path = f'{parent_folder}/config.yaml'
with open(yaml_file_path, 'r') as yaml_file:
    yaml_lines = yaml_file.readlines()
yaml_lines[0] = f'base_folder: {parent_folder}/\n'
with open(yaml_file_path, 'w') as yaml_file:
    yaml_file.writelines(yaml_lines)