#!/usr/bin/python3

import os
import subprocess

def get_branch_by_hash():
    try:
        branch = os.environ.get('branch', "HEAD")
        commit = os.environ.get('commit_id')

        # Skip. No reason to find branch if repo is already on it
        if branch != "HEAD":
            print(branch)

        contains = subprocess.check_output(['git', 'branch', '--contains', commit])

        # bytes -> str -> list
        contains_lst = contains.decode("utf-8").split('\n')

        # clean elements (remove empty, remove trailing)
        contains_lst.remove("")
        for idx, _ in enumerate(contains_lst):
            contains_lst[idx] = contains_lst[idx].replace("*", "").strip()

        # Branch can be defined by commit just in case if "git branch --contains"
        # returns 2 strings: 1st is "(HEAD detached at {hash})" and 2nd is a branch name.
        # In other cases branch cannot be defined so return HEAD
        if len(contains_lst) == 2 and "(HEAD detached at " in contains_lst[0]:
            branch = contains_lst[1]

        # print except return is to catch output by a bash script
        print(branch)
    except:
        print("HEAD")

if __name__ == '__main__':
    get_branch_by_hash()
