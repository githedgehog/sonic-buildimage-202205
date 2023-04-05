#!/usr/bin/python3

import os
import os.path
import yaml
import re

RULES_CFG_PATH = 'rules/config'
RULES_CFG_USER_PATH = 'rules/config.user'
IMG_METADATA_FILE = 'build_metadata.yml'

#
# Helper functions
#

# Get header info (version, date/time, commit/branch, kernel/distro)

def get_header_info():
    hdr_data = {}
    hdr_data ['SONiC_Software_Version'] = os.environ.get('build_version')
    hdr_data['distribution'] = os.environ.get('debian_version')
    hdr_data['kernel'] = os.environ.get('kernel_version')
    hdr_data['build_date'] = os.environ.get('build_date')

    return hdr_data

# Get git related info (remote repository, branch name, commit)

def get_git_info():
    git_data = {}
    git_data ['repo'] = os.environ.get('git_remote')
    git_data['branch'] = os.environ.get('branch')
    git_data['ref'] = os.environ.get('commit_id')

    return git_data

# Get image spec info (platform, arch, usecase, options)

def get_spec_info():
    spec_data = {}
    spec_data ['platform'] = os.environ.get('configured_platform')
    spec_data['arch'] = os.environ.get('configured_arch')
    spec_data['usecase'] = os.environ.get('image_usecase')
    usecase = os.environ.get('image_options')

    spec_data['options'] = usecase.split()

    return spec_data

# Read config file by a given path, create dictionary

def read_cfg_file(cfg_path:str, cfg_dict:dict):
    if os.path.exists(cfg_path) is False:
        return

    #read config file
    with open(cfg_path) as cfg_fp:
        cfg_lines = cfg_fp.readlines()
        for line in cfg_lines:
            line = line.strip()
            if line.startswith('#') or re.search("^\s*$", line):
                #skip comments or empty lines
                continue
            else:
                #strip spaces, for pairs with ?= remove '?'
                key = line.split('=')[0].rstrip('?').strip()
                value = line.split('=')[1].strip()
                cfg_dict[key] = value

# Get build configuration
# read build configuration from config and config.user files
# config.user overwrites options from config, see slave.mk

def get_bld_config():
    bld_config = {}

    read_cfg_file(RULES_CFG_PATH, bld_config)
    read_cfg_file(RULES_CFG_USER_PATH, bld_config)

    return bld_config

# Write build metadata into yaml file

def write_matadata(path:str):
    bld_metadata = {}

    bld_metadata['id'] = os.environ.get('build_id')
    bld_metadata['date'] = int(os.environ.get('build_timestamp'))
    bld_metadata['channel'] = os.environ.get('base_branch_channel')

    bld_metadata['git'] = get_git_info()
    bld_metadata['spec'] = get_spec_info()
    bld_metadata['version'] = get_header_info()
    bld_metadata['configuration'] = get_bld_config()

    with open(path, 'w') as file:
        yaml.dump(bld_metadata, file, sort_keys=False)

def build_metadata():
    write_matadata(IMG_METADATA_FILE)

if __name__ == '__main__':
    build_metadata()
