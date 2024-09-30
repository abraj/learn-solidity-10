pragma circom 2.0.0;

/* This circuit template checks that c is the multiplication of a and b. */
template Multiplier2(N) {
  // Declaration of signals
  signal input in1;
  signal input in2;
  signal output out;

  // Constraints
  out <== in1 * in2;
  out === N;
}

component main = Multiplier2(12);
