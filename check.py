#!/usr/bin/env python3
import subprocess
import sys

def run(cmd, inp=None):
    p = subprocess.run(cmd, input=inp, capture_output=True, text=True)
    if p.returncode != 0:
        print(f"FAILED: {cmd}\nstdout:\n{p.stdout}\nstderr:\n{p.stderr}")
        sys.exit(1)
    return p.stdout

# 1. Build
run(["lake", "build"])
print("build OK")

# 2. Check axioms of Submission.lean
out = run(["lake", "env", "lean", "--stdin"], inp="import Submission\n#print axioms JSP000745.jsp_000745_solved\n")
lines = [l.strip() for l in out.splitlines() if "jsp_000745_solved" in l]
if not lines:
    print(f"FAILED to parse axioms:\n{out}")
    sys.exit(1)

ax_line = lines[0]
print(ax_line)
if "sorryAx" in ax_line or "sorry" in ax_line:
    print("FAILED: contains sorry")
    sys.exit(1)

allowed = {"propext", "Classical.choice", "Quot.sound"}
if "[" in ax_line and "]" in ax_line:
    raw_axioms = ax_line[ax_line.find("[")+1:ax_line.find("]")].split(",")
    axioms = {a.strip() for a in raw_axioms if a.strip()}
    if not axioms.issubset(allowed):
        print(f"FAILED: unexpected axioms {axioms - allowed}")
        sys.exit(1)
    print(f"axioms OK: {', '.join(sorted(axioms))}")
else:
    print(f"FAILED: axiom format unexpected in {ax_line}")
    sys.exit(1)

# 3. DefEq verification
run(["lake", "env", "lean", "--stdin"], inp="import Submission\nexample : JSP000745.jsp000745Statement := JSP000745.jsp_000745_solved\n")
print("bridge OK: example : JSP000745.jsp000745Statement := JSP000745.jsp_000745_solved")
