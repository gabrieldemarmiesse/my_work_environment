import sys
from subprocess import CalledProcessError
from working_with_github.utils import run
import os


def checkout_pr():
    user, branch = sys.argv[1].split(":")
    _checkout_pr(user, branch)


def _checkout_pr(user, branch):
    run(f"git remote add {user} git@github.com:{user}/addons.git", fail_ok=True)
    run(f"git fetch {user}")
    try:
        run(f"git checkout -b {user}_{branch} {user}/{branch}")
    except CalledProcessError:
        run(f"git checkout {user}_{branch}")
        run(f"git pull")
    run(f"git branch --set-upstream-to {user}/{branch}", fail_ok=True)


def setup_oss():
    repo = sys.argv[1]
    assert '/' in repo
    org, repo = repo.split('/')

    url_upstream = f"https://github.com/{org}/{repo}.git"
    url_origin = f"git@github.com:gabrieldemarmiesse/{repo}.git"

    run(f'git clone {url_origin}')
    os.chdir(f'./{repo}')
    run(f'git remote add upstream {url_upstream}')
    run('git fetch upstream')
    run('git branch --set-upstream-to upstream/master')
    run('git pull')
    run('git push origin master')



def update_pr():
    user, branch = sys.argv[1].split(":")
    _checkout_pr(user, branch)
    run("git merge master")
    run(f"git push {user} HEAD:{branch}")
