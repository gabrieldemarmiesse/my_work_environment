from subprocess import check_call, CalledProcessError


def run(string, fail_ok=False):
    if fail_ok:
        try:
            return check_call(["bash", "-c", string])
        except CalledProcessError:
            return
    else:
        return check_call(["bash", "-c", string])
