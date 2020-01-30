import sys, os
from subprocess import call

def execute_bash(string):
    print(string)
    call(string.split(' '))

repo = sys.argv[1]
assert '/' in repo
org, repo = repo.split('/')

url_upstream = f"https://github.com/{org}/{repo}.git"
url_origin = f"git@github.com:gabrieldemarmiesse/{repo}.git"

execute_bash(f'git clone {url_origin}')
os.chdir(f'./{repo}')
execute_bash(f'git remote add upstream {url_upstream}')
execute_bash('git fetch upstream')
execute_bash('git branch --set-upstream-to upstream/master')
execute_bash('git pull')
execute_bash('git push origin master')
