// TODO: add lifted annotation

// Node := Int(bits=n)
// Node := 𝔹[];
// // TODO: edgeOracle lifted?
// edgeOracle_spec := !((const Node x const Node x 𝔹) -> 𝔹);
// QWTFP_spec := !Int x !Int x edgeOracle_spec;
// GCQWRegs := Int[] x Int x Int x 𝔹[] x Int x 𝔹;


// def a1(oracle:QWTFP_spec) : !𝔹 x !Node x !Int[n]^rr x !𝔹[][] {
// 	n, r, edgeOracle = oracle;

// 	// nn := 2^n; not used 
// 	rr := 2^r;
// 	// rbar := max([2*r / 3, 1]); not used
// 	// rrbar := 2^rbar; 
// 	tm := 2^(n-r);
// 	tw := floor(sqrt(rr));

// 	testTEdge := False;

// 	tt := a4_HADAMARD_Array_Array(array(rr,array(n,False))); // a4_HADAMARD( array(rr,0:Int[n]) );
// 	i := a4_HADAMARD_Array(0:Int[r]);
// 	v := a4_HADAMARD_Array(array(n,False));

// 	ee := a5_SETUP(oracle, tt);

// 	for _ in [0..tm) {
// 		w, triTestT, triTestTw := a15_TestTriangleEdges(oracle, tt, ee);
// 		if !(triTestT == 0 && triTestTw == 0) { 
// 			phase(pi); 
// 		}
// 		reverse(a15_TestTriangleEdges)(w, triTestT, triTestTw);

// 		for _ in [0..tw) {
// 			tt, i, v, ee := a6_QWSH(oracle, tt, i, v, ee)
// 		}	
// 	}

// 	//triTestT gets set to true, if triangle found within tt
// 	//triTestTw gets set to true, if a pair of nodes formes a 
// 	//triangle with anode from w
// 	w, triTestT, triTestTw = a15_TestTriangleEdges(oracle, tt, ee);

// 	// ToDo: rewrite this here to qor(testTEdge, [triTestT, triTestTw], [True, True])
// 	// Todo: high-level should have testTEdge as a return only
// 	testTEdge := qor(testTEdge, [(triTestT, True), (triTestTw, True)]);

// 	testTMeasure := Measure(testTEdge);
//   	wMeasure := Measure(w); //wMeasure contains a node of the triangle
//   	ttMeasure := Measure(tt); //other two nodes in TMeasure
//   	eeMeasure := Measure(ee);
//   	// delete(i, v, triTestT, triTestTw);
//   	return testTMeasure, wMeasure, ttMeasure, eeMeasure;
// }

// // ToDo: discuss this. maybe introduction of read only references. 
// def allEqual(cs:const (𝔹, !𝔹)^k) : 𝔹 {
// 	cs0 = [];
// 	cs1 = [];
// 	for l in [0..k) {
// 		cs0~cs[k][0];
// 		cs1~cs[k][1];
// 	}
// 	return cs0 == cs1;
// }

// // can be made lifted
// def qor[k:!Int](q: 𝔹, cs:const (𝔹, !𝔹)^k) : 𝔹 {
// 	q := !q;
// 	if allEqual(cs) { q := !q; }
// 	return q;
// }


// // Currently not needed
// // in current impl not used
// // def a2_ZERO(b:classical Int) : Int {
// // 	q := b:Int[];
// // 	return q;
// // }

// // in current impl not used
// // def a3_INITIALIZE(reg:classical Int) : Int {
// // 	zreg := a2_Zero(reg);
// // 	hzreg := a4_Hadamard(zreg);
// // 	return hzreg;
// // }

def a4_HADAMARD_Array[k:!N](q:𝔹^k) : 𝔹^k {
	for j in [0..k) { q[j] := H(q[j]); }
	return q;
}

def a4_HADAMARD_Array_Array[k:!N,l:!N](q:(𝔹^k)^l) : (𝔹^k)^l {
	for i in [0..l) {
		q[i] := a4_HADAMARD_Array(q[i]);
	}
	return q;
}

//def a5_SETUP(oracle:!QWTFP_spec, tt:const Node[]) : 𝔹[][] {
def a5_SETUP[n:!N, rr:!N](edgeOracle:((const int[n] x const int[n] x 𝔹) !-> 𝔹), 
	const tt:int[n]^rr) : (𝔹^rr)^rr {

	ee := vector(rr,vector(rr,false)):(B^rr)^rr;

	for k in [0..rr) {
		for j in [0..k) {
			ee[k][j] := edgeOracle(tt[j], tt[k], ee[k][j]);
	}	}

	return ee;
}

// // // TODO: make high level, ttd, eed allocated in f. 
// // def a6_QWSH(oracle:!QWTFP_spec, tt: Node[], 
// // 	i: Int, v: Node, ee: 𝔹[][]) : Node[] x Int x v x 𝔹[][] {
// def a6_QWSH[n:!N, rr:!N](edgeOracle:((const int[n] x const int[n] x 𝔹) !-> 𝔹), 
// 	tt:int[n]^rr, i: Int, v:int[n], 
// 	ee:(𝔹^rr)^rr) : int[n]^rr x Int x int[n] x (𝔹^rr)^rr {

// 	//todo check if capturing here is enough
// 	f := lambda (i:const Int, tt:Node[], ee:𝔹[][]) . {
// 		eed := array(2^r,False);
// 		ttd := tt[i]; //qram_fetch_Array(i, tt);
// 		(ee, eed) := a12_FetchStoreE(i, ee, eed);
// 		eed := a13_UPDATE(oracle, tt, ttd, eed);
// 		tt := qram_store_Array(i, tt, ttd);
// 		// tt[i] := ttd;
// 		return ttd, ee, eed, tt;
// 	};
	
// 	i, v := a7_DIFFUSE_Int_Array([i, v]);
// 	ttd,ee,eed,tt := f(i,tt,ee);
// 	ttd, v := v, ttd;
// 	tt,ee := reverse(f)(i,ttd,ee,eed,tt);

// 	return tt, i, v, ee;
// // }


def a7_Diffuse_Array[k:!N](q:𝔹^k) : 𝔹^k {
	q := a4_HADAMARD_Array(q);
	if q == array(k,false) { phase(π); }
	q := a4_HADAMARD_Array(q);
	return q;
}

def a7_Diffuse_Array_Array[k:!N,l:!N](q:(𝔹^k)^l) : (𝔹^k)^l {
	q := a4_HADAMARD_Array_Array(q);
	if q == array(l,array(k,false)) { phase(π); }
	q := a4_HADAMARD_Array_Array(q);
	return q;
}

def a7_Diffuse_Pair[k:!N, l:!N](p:int[k], q:int[l]) : int[k] x int[l] {
	p := a4_HADAMARD_Array(p:B^k):int[k];
	q := a4_HADAMARD_Array(q:B^l):int[l];
	if q == 0 && p==0 { phase(π); }
	p := a4_HADAMARD_Array(p:B^k):int[k];
	q := a4_HADAMARD_Array(q:B^l):int[l];
	return (p,q);
}


def flipWith_Array[l:!N](const p:𝔹^l, q:𝔹^l) mfree : 𝔹^l {
	for i in[0..l) {
		if p[i] { q[i] := X(q[i]); }
	}
	return q;
}

// // Currently not needed
// // def flipWith_Array_Array[k:!Int,l:!Int](p:!Bool^l^k, q:consumed Bool^l^k) {
// // 	for j in [0,k) {
// // 		q[j] := flipWith_Array(p[j], q[j]);
// // 	}
// // 	return q;
// // }

// // questions to original Code, ttj?
def a8_FetchT[n:!N, rr:!N, r:!N](const i:int[r], const tt:𝔹^rr) :  𝔹 {
	ttd := false:B;
	for j in [0..rr) {
		if tt[j] && i == j {
			ttd_ := !ttd;
			forget(ttd = !ttd_);
			ttd := ttd_;
	}	}	
	return ttd;
}

// todo: realize as lifted:
// def a8_FetchT_Array[k:!Int, l:!Int](i:const Int[k], tt:const Node[l][]) lifted : Node[l] {
def a8_FetchT_Array[n:!N, rr:!N, r:!N](const i:int[r], const tt:int[n]^rr) : int[n] {
	ttd := 0:int[n];
	for j in [0..rr) {
		if i == j {
			ttd := flipWith_Array(tt[j]:B^n, ttd:B^n):int[n];
	}	}	
	return ttd;
}

// // Currently not needed
// // def a9_StoreT[k:!Int](i:Int[k], tt: consumed 𝔹[], ttd:𝔹) : 𝔹[] {
// // 	for j in [0, 2^k) {
// // 		if ttd && i == j {
// // 			tt[j] := !tt[j];
// // 	}	}
// // 	return tt;
// // }

// // todo same as for a8_FetchT
// def a9_StoreT_Array[k:!Int](i:const Int[k], tt: Node[], ttd:const Node) : Node[] {
def a9_StoreT_Array[n:!N, rr:!N, r:!N](const i:int[r], tt: int[n]^rr, const ttd:int[n]) : int[n]^rr {
	for j in [0..rr) {
		if i==j {
			tt[j] := flipWith_Array(ttd:B^n, tt[j]:B^n):int[n];
	}	}
	return tt;
}

// def a10_FetchStoreT[k:!Int](i:const Int[k], tt:𝔹[], ttd:𝔹) : 𝔹[] x 𝔹 {
def a10_FetchStoreT[rr:!N, r:!N](const i:int[r], tt:B^rr, ttd:𝔹) : 𝔹^rr x 𝔹 {
	for j in [0..rr) {
		if i == j {
			(tt[j], ttd) := (ttd, tt[j]);
		}
	}
	return (tt, ttd);
}

// todo: check if ok!
def a11_FetchE[rr:!N,r:!N](const i:int[r], const qs:(𝔹^rr)^rr) lifted : 𝔹^rr {
	ps := vector(rr,false);
	for j in [0..rr) {
		for k in [0..j) {
			if qs[j][k] && i == j { ps[k] = !ps[k]; }
			if qs[j][k] && i == k { ps[j] = !ps[j]; }
	}	}
	return ps;
}


def a12_FetchStoreE[rr:!N,r:!N](const i:int[r], qs: (𝔹^rr)^rr, 
	ps: 𝔹^rr) : (𝔹^rr)^rr x 𝔹^rr {

	for j in [0..rr) {
		for l in [0..j) {
			if i == j { (qs[j][l], ps[l]) := (ps[l], qs[j][l]); }
			if i == l { (qs[j][l], ps[j]) := (ps[j], qs[j][l]); }
		}
	}
	return (qs, ps);
}


// def a13_UPDATE(oracle:!QWTFP_spec, tt:const Node[], ttd:const Node, eed:𝔹[]) : 𝔹[] {
def a13_UPDATE[n:!N, rr:!N](edgeOracle:((const int[n] x const int[n] x 𝔹) !-> 𝔹), 
	const tt:int[n]^rr, const ttd:int[n], eed:𝔹^rr) : 𝔹^rr {

	//n, r, edgeOracle := oracle;
	for j in [0..rr) {
		eed[j] := edgeOracle(tt[j], ttd, eed[j]);
	}
	return eed;
}

// // Currently not needed. 
// // def a14_SWAP[k:!Int](q: consumed Int[k], p: consumed Int[k]) : Int x Int {
// // 	for j in [0, m) {
// // 		p[j], q[j] = q[j], p[j]; //Swap(p[j], q[j]);
// // 	}
// // 	return q, p;
// // }

// // standard_qram :: Qram
// // standard_qram = Qram {
// //   qram_fetch = a8_FetchT,
// //   qram_store = a9_StoreT,
// //   qram_swap = a10_FetchStoreT
// // }

// def a15_TestTriangleEdges(oracle:!QWTFP_spec, tt:const Node[], ee:const 𝔹[][]) : Node x 𝔹 x 𝔹 {

// 	triTestT := a16_TriangleTestT(ee);
// 	w := a18_TriangleEdgeSearch(oracle, tt, ee, triTestT);
// 	triTestTw := a17_TriangleTestTw(oracle, tt, ee, w);

// 	return w, triTestT, triTestTw;
// }

def choose(n:!N, k:!N) lifted : !N;
def logBase(n:!N, a:!N) lifted : !R;
def ceiling(r:!R) lifted : !N;
def floor(r:!R) lifted : !N;

// // Todo: implement choose
// def a16_TriangleTestT[rr:!N](const ee:(𝔹^rr)^rr) : 𝔹 {
	
// 	m := ceiling(logBase(2,choose(rr, 3)));

// 	f := lambda (const ee:(𝔹^rr)^rr) . {
// 		cTri := 0:int[m];
// 		for i in [0..rr) {
// 			for j in [i+1..rr) {
// 				for k in [j+1..rr){
// 					if ee[j][i] && ee[k][i] && ee[k][j] {
// 						cTri += 1;
// 		}	}	}	}
// 		return cTri;
// 	};

// 	cTri := f(ee);

// 	triTestT := true;
// 	if cTri == 0 { triTestT = !triTestT; }
	
// 	reverse(f)(ee, cTri);

// 	return triTestT;
// }



// // 
// def a17_TriangleTestTw(oralce:!QWTFP_spec, tt:const Node[], ee:const 𝔹[][], w:const Node) lifted : 𝔹 {
// def a17_TriangleTestTw[n:!N, rr:!N](edgeOracle:((const int[n] x const int[n] x 𝔹) !-> 𝔹),
// 	const tt:int[n]^rr, const ee:(𝔹^rr)^rr, const w:int[n]) : 𝔹 {

// 	//rr = ee.length;
// 	m := ceiling(logBase(2,choose(rr,2)));


// 	f := lambda(const tt:int[n]^rr, const ee:(𝔹^rr)^rr, const w:int[n]) . {
// 		eed := vector(rr,false):B^rr;
// 		for k in [0..rr) {
// 			eed[k] := edgeOracle(tt[k], w, eed[k]);
// 		}

// 		cTri := 0:int[m]; 

// 		for i in [0..rr) {
// 			for j in [i+1..rr) {
// 				if ee[j][i] && eed[i] && eed[j] {
// 					cTri += 1;
// 		}	}	}
// 		return (eed, cTri);
// 	};

// 	(eed, cTri) := f(tt, ee, w);

// 	triTestTW := true:B;
// 	if cTri == 0 { triTestTW := X(triTestTW); }

// 	reverse(f)(tt,ee,w,eed,cTri);

// 	return triTestTW;
// }

// //CHECK for Consumed and so on
// def a18_TriangleEdgeSearch(oracle:!QWTFP_spec, tt:const Node[], ee:const 𝔹[][], triTestT:const 𝔹) : Node {
// def a18_TriangleEdgeSearch[n:!N, rr:!N](edgeOracle:((const int[n] x const int[n] x 𝔹) !-> 𝔹),
// 	const tt: int[n]^rr, const ee:(𝔹^rr)^rr, const triTestT:𝔹) : int[n] {
	
// 	//n, r, edgeOracle := oracle;
// 	tG := floor(pi/4 * sqrt(2^n));

// 	w := 0:int[n]; //array(n,False);//0:Node[n];
// 	w := a4_HADAMARD_Array(w);

// 	for _ in [0..tG) {
// 		cTri := a19_GCQWalk(oracle, tt, ee, w, triTestT);

// 		if triTestT == 0 && !(cTri == 0) { phase(π); }

// 		reverse(a19_GCQWalk)(oracle, tt, ee, w, triTestT, cTri);
// 		w := a7_DIFFUSE(w);
// 	}
// 	return w;
// }


// // triTestT needs to be consumed
// // or break up the tuple structure -> maybe even lifted
// def a19_GCQWalk(oracle:!QWTFP_spec, tt:const Node[], ee:const 𝔹[][], 
// 	w:const Node, triTestT:const 𝔹) : Int {
	
// 	n, r, edgeOracle = oracle;

// 	// nn = 2^n;
// 	rr = 2^r;
// 	rbar = max([2 * r / 3, 1]);
// 	rrbar = 2^rbar;
// 	tbarm = max([rr / rrbar, 1]);
// 	tbarw = floor(sqrt(rrbar));

// 	cTri := 0:Int[rrbar];

// 	tau := array(rrbar,0:Int[r]);
// 	iota := 0:Int[rbar];
// 	sigma := 0:Int[r];
// 	eew := array(rrbar,False);

// 	tau := a4_Hadamard_Array_Array(tau);
// 	iota := a4_HADAMARD_Array(iota);
// 	sigma := a4_HADAMARD_Array(sigma);

// 	for j in [0..eew.length) {
// 		eew[j] := edgeOracle(tt[tau[j]], w, eew[j])
// 	}

// 	for j in [0..rrbar) {
// 		for k in [j+1..rrbar) {
// 			if ee[tau[j]][tau[k]] && eew[j] && eew[k] {
// 				cTri += 1;
// 	}	}	}

// 	for _ in [0..tbarm) {
// 		if triTestT == 0 && !(cTri == 0) { phase(pi); }

// 		gcqwRegs := (tau, iota, sigma, eew, cTri, triTestT);

// 		for _ in [0..tbarw) {
// 			gcqwRegs := a20_GCQWStep(tt, ee, w, gcqwRegs);
// 		}
// 	}

// 	// Todo: Clarify this
// 	// Why is this forget here valid? deleted in with the reverse in a18?
// 	forget(tau = array(rrbar,0:Int[r]));
// 	forget(iota = array(rbar,False));
// 	forget(sigma = array(r,False));
// 	forget(eew = array(rrbar,False));

// 	return cTri;
// }

// def a20_GCQWStep(oracle:!QWTFP_spec, tt:const Node[], ee:const 𝔹[][], w:const Node, 
// 	gcqwRegs:GCQWRegs) : GCQWRegs {
def a20_GCQWStep[n:!N, rr:!N, r:!N, rbar:!N, rrbar:!N](edgeOracle:((const int[n] x const int[n] x 𝔹) !-> 𝔹), 
	const tt: int[n]^rrbar, const ee:(𝔹^rr)^rr, const w:int[n], 
	gcqwRegs:(int[r]^rrbar x int[rbar] x int[r] x 𝔹^rrbar x int[rrbar] x 𝔹)
	      ) : int[r]^rrbar x int[rbar] x int[r] x 𝔹^rrbar x int[rrbar] x 𝔹 {

	(tau, iota, sigma, eew, cTri, triTestT) := gcqwRegs;

	(iota, sigma) := a7_Diffuse_Pair(iota, sigma);

	(tau, taud, eewd, cTri, eew) := help_a20_2(edgeOracle, w, tau, iota, eew, cTri, tt, ee);

	(taud, sigma) := (sigma, taud); //a14_SWAP(taud, sigma);

	(eew, cTri) := reverse(help_a20_2)(edgeOracle, tau, iota, tt, ee, tau, taud, eewd, cTri, eew);

	return (tau, iota, sigma, eew, cTri, triTestT);
}


// // todo: add w
// def help_a20_2(tau:const Int[], iota:const Int, eew: 𝔹[],
// 	cTri: Int, tt:const Node[], ee:const 𝔹[][], r:!Int, 
// 	rr:!Int, rrbar:!Int, n:!Int) :
// 	Node x 𝔹[] x Int x 𝔹 x 𝔹[] {

def help_a20_2[n:!N, r:!N, rr:!N, rbar:!N, rrbar:!N](
	edgeOracle:((const int[n] x const int[n] x 𝔹) !-> 𝔹), 
	const w:int[n], tau:int[r]^rrbar, 
	const iota:int[rbar], eew:𝔹^rrbar,
	cTri:int[rrbar], const tt:int[n]^rr, const ee:(𝔹^rr)^rr) :
	int[r]^rrbar x int[r] x 𝔹 x int[rrbar] x 𝔹^rrbar {

	eewd := false:B;

	taud := tau[iota]; 
	(eew, eewd) := a10_FetchStoreT(iota, eew, eewd);

	for k in [0..rrbar) {
		if ee[taud][tau[k]] && eewd && eew[k] {
			cTri -= 1;
	}	}

	eewd := edgeOracle(tt[taud], w, eewd);
	tau := a9_StoreT_Array(iota, tau, taud);

	return (tau, taud, eewd, cTri, eew);
}