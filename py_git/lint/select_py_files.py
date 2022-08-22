import sys


def process_line(line: str):
    line = line.strip()
    if line.startswith('D'):
        return
    if not line.endswith(".py"):
        return
    return line.split(" ")[-1]

text_to_process = sys.stdin.read()

lines = [process_line(line) for line in text_to_process.splitlines()]
lines = [line for line in lines if line is not None]

for line in lines:
    sys.stdout.write(line + "\n")
