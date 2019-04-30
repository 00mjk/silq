// https://codeforces.com/contest/1115/problem/G3
def solve[n:!ℕ](x:𝔹^n){
	y:=1:𝔹;
	for i in [0..n/2){
		y&=x[i]==x[n-1-i];
	}
	return y;
}
