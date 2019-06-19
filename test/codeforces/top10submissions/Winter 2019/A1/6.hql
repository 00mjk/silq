def arccos(q:!ℝ) lifted :!ℝ;
def sqrt(q:!ℝ) lifted :!ℝ;

def solve(q0:𝔹, q1:𝔹) {
    q0 := rotY(q0, arccos(1.0/sqrt(3.0))*2.0);
    if q0 {
        q1 := H(q1);
    }
    return (X(q0),q1);
}