#!/usr/bin/python3

import os
import subprocess

def get_branch_by_hash():
    try:
        branch = os.environ.get('branch', "HEAD")
        commit = os.environ.get('commit_id')

        # get HEAD commit hash if no var commit_id
        if commit is None:
            commit = subprocess.check_output(['git', 'rev-parse', '--short', 'HEAD']).decode("utf-8").replace("\n", "")

        # Skip. No reason to find branch if repo is already on it
        if branch != "HEAD":
            print(branch)

        contains = subprocess.check_output(['git', 'branch', '-a', '--contains', commit])

        # bytes -> str -> list
        contains_lst = contains.decode("utf-8").split('\n')
        # get pure branch names
        contains_lst = [elem.replace("remotes/origin/", "").replace("*", "").strip() for \
                        elem in contains_lst if (elem != "") and ("HEAD" not in elem)]

        # remove duplicates
        contains_lst = list(dict.fromkeys(contains_lst))

        if len(contains_lst) == 1:
            branch = contains_lst[0]

        # print except return is to catch output by a bash script
        print(branch)
    except:
        print("HEAD")

if __name__ == '__main__':
    get_branch_by_hash()
