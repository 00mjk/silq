https://codeforces.com/contest/1002/problem/A4
def solve(k:!ℕ){
	i:=0:int[k];
	for j in [0..k){ i[j]:=H(i[j]); }
	qs:=vector(2^k,0:𝔹);
	qs[i]=X(qs[i]);
	forget(i=lambda(const qs:𝔹^(2^k))lifted{
		i:=0:int[k];
		for j in [0..2^k){ if qs[j]{ i=j:int[k]; } }
		return i;
	}(qs));
	return qs;
}
