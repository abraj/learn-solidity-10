pragma circom 2.0.0;

template Multiplier2() {
  // Declaration of signals
  signal input in1;
  signal input in2;
  signal output out;

  // Constraints
  out <== in1 * in2;
}

template BinaryCheck() {
  // Declaration of signals
  signal input in;
  signal output out;

  // Constraints
  in * (in-1) === 0;
  out <== in;
}

template AndN(N) {
  // Declaration of signals and components
  signal input in[N];
  signal output out;
  component binCheck[N];
  component mult[N-1];

  // Constraints
  for (var i = 0; i < N; i++) {
    binCheck[i] = BinaryCheck();
    binCheck[i].in <== in[i];
  }

  for (var i = 0; i < N-1; i++) {
    mult[i] = Multiplier2();
  }

  mult[0].in1 <== binCheck[0].out;
  mult[0].in2 <== binCheck[1].out;
  for (var i = 0; i < N-2; i++) { 
    mult[i+1].in1 <== mult[i].out;
    mult[i+1].in2 <== binCheck[i+2].out;
  }
  out <== mult[N-2].out;
}

component main = AndN(4);
