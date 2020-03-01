from subprocess import check_call, CalledProcessError
import sys


def check_bash_call(string, fail_ok=False):
    if fail_ok:
        try:
            return check_call(["bash", "-c", string])
        except CalledProcessError:
            return
    else:
        return check_call(["bash", "-c", string])


user, branch = sys.argv[1].split(":")

check_bash_call(f"git remote add {user} git@github.com:{user}/addons.git", fail_ok=True)
check_bash_call(f"git fetch {user}")
try:
    check_bash_call(f"git checkout -b {user}_{branch} {user}/{branch}")
except CalledProcessError:
    check_bash_call(f"git checkout {user}_{branch}")
    check_bash_call(f"git pull")
check_bash_call(f"git branch --set-upstream-to {user}/{branch}", fail_ok=True)
try:
    check_bash_call(f"git merge master")
    check_bash_call(f"git push {user} HEAD:{branch}")
except CalledProcessError:
    check_bash_call(f"git add . && git commit && git push", fail_ok=True)
