.PHONY: test deploy

clean:; rm -rf setup build proof sol

setup: setup-key

build: build-ckt gen-witness gen-key gen-proof

verify: verify-proof

setup-key:
	mkdir -p setup
	cd setup && snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
	cd setup && snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v

build-ckt:
	mkdir -p build
	circom multiplier2.circom --r1cs --c -o build
	cd build/multiplier2_cpp && make

gen-witness:
	cd build && echo '{"a": "5", "b": "7"}' > input.json
	cd build && ./multiplier2_cpp/multiplier2 input.json witness.wtns

gen-key:
	cd build && snarkjs powersoftau prepare phase2 ../setup/pot12_0001.ptau pot12_final.ptau -v
	cd build && snarkjs groth16 setup multiplier2.r1cs pot12_final.ptau multiplier2_0000.zkey
	cd build && snarkjs zkey contribute multiplier2_0000.zkey multiplier2_0001.zkey --name="1st Contributor Name" -v
	cd build && snarkjs zkey export verificationkey multiplier2_0001.zkey verification_key.json

gen-proof:
	mkdir -p proof
	cd build && snarkjs groth16 prove multiplier2_0001.zkey witness.wtns proof.json public.json
	cd build && mv verification_key.json public.json proof.json ../proof/

verify-proof:
	cd proof && snarkjs groth16 verify verification_key.json public.json proof.json

gen-sol:
	mkdir -p sol
	cd proof && snarkjs zkey export solidityverifier ../build/multiplier2_0001.zkey verifier.sol
	cd proof && snarkjs generatecall > verifier_args.txt
	cd proof && mv verifier.sol verifier_args.txt ../sol/
