pragma circom 2.0.0;

// Ref: https://docs.circom.io/circom-language/basic-operators/#bitwise-operators

template Num2Bits(n) {
  signal input in;
  signal output out[n];

  var lc1 = 0;
  var e2 = 1;

  for (var i = 0; i < n; i++) {
    out[i] <-- (in >> i) & 1; // get the binary digit at ith index
    out[i] * (out[i] -1) === 0; // ensure that out[i] is a boolean value
    lc1 += out[i] * e2; // maintain the running value
    e2 *= 2; // update/prepare binary exponent for (i+1)th index
  }
  lc1 === in; // ensure that the conversion is well done
}

component main {public [in]}= Num2Bits(3);
