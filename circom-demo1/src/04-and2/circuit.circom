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

template And2() {
  // Declaration of signals and components
  signal input in1;
  signal input in2;
  signal output out;
  component binCheck[2];
  component mult = Multiplier2();

  binCheck[0] = BinaryCheck();
  binCheck[1] = BinaryCheck();

  // Constraints
  binCheck[0].in <== in1;
  binCheck[1].in <== in2;
  mult.in1 <== binCheck[0].out;
  mult.in2 <== binCheck[1].out;
  out <== mult.out;
}

component main = And2();
