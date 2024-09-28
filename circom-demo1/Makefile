# -include .env
# include .env

.PHONY: test deploy

clean:; rm -rf build setup2 proof sol

setup: setup-key

build: build-ckt setup-ckt-key key-export gen-sol
proof: gen-witness gen-proof gen-sol-args
verify: verify-proof

setup-key:
	mkdir -p setup1
	cd setup1 && snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
	cd setup1 && snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v -e="$$(openssl rand -base64 30)"
	# cd setup1 && snarkjs powersoftau contribute pot12_0001.ptau pot12_0002.ptau --name="Second contribution" -v -e="$$(openssl rand -base64 30)"
	# cd setup1 && snarkjs powersoftau verify pot12_0001.ptau
	cd setup1 && snarkjs powersoftau beacon pot12_0001.ptau pot12_beacon.ptau b7d9a1fc78ded404cd11fb4cc5187fc3b29483ab30fae426ff3953553e0b764c 10 -n="Final Beacon"
	# cd setup1 && snarkjs powersoftau verify pot12_beacon.ptau
	# --------- prepare for phase 2 ---------
	cd setup1 && snarkjs powersoftau prepare phase2 pot12_beacon.ptau pot12_final.ptau -v
	cd setup1 && snarkjs powersoftau verify pot12_final.ptau

build-ckt:
	mkdir -p build
	# circom circuit.circom --r1cs --c -o build
	circom circuit.circom --r1cs --wasm --c --sym --inspect -o build
	cd build && snarkjs r1cs info circuit.r1cs
	# cd build && snarkjs r1cs print circuit.r1cs circuit.sym
	# cd build && snarkjs r1cs export json circuit.r1cs circuit.r1cs.json
	cd build/circuit_cpp && make

setup-ckt-key:
	mkdir -p setup2
	# ------ circuit-specific (phase 2) trusted ceremony ------
	# cd setup2 && snarkjs groth16 setup ../build/circuit.r1cs ../setup1/pot12_final.ptau circuit_0000.zkey
	# cd setup2 && snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v -e="$$(openssl rand -base64 30)"
	# # cd setup2 && snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="2nd Contributor Name" -v -e="$$(openssl rand -base64 30)"
	# cd setup2 && snarkjs zkey beacon circuit_0001.zkey circuit_final.zkey 4d6ffc28cf029b15686e864aa8d6cefb373498124cee0628e89b43f5c5bf62e0 10 -n="Final Beacon phase2"
	# ------------------
	cd setup2 && snarkjs plonk setup ../build/circuit.r1cs ../setup1/pot12_final.ptau circuit_final.zkey
	# cd setup2 && snarkjs fflonk setup ../build/circuit.r1cs ../setup1/pot12_final.ptau circuit_final.zkey

key-export:
	cd setup2 && snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

gen-witness:
	mkdir -p proof
	cd proof && sh ../input.sh
	cd proof && ../build/circuit_cpp/circuit input.json witness.wtns
	# cd proof && snarkjs wtns calculate ../build/circuit_js/circuit.wasm input.json witness.wtns
	# cd proof && node ../build/circuit_js/generate_witness.js ../build/circuit_js/circuit.wasm input.json witness.wtns
	cd proof && snarkjs wtns check ../build/circuit.r1cs witness.wtns

gen-proof:
	# cd proof && snarkjs groth16 prove ../setup2/circuit_final.zkey witness.wtns proof.json public.json
	cd proof && snarkjs plonk prove ../setup2/circuit_final.zkey witness.wtns proof.json public.json
	# cd proof && snarkjs fflonk prove ../setup2/circuit_final.zkey witness.wtns proof.json public.json

verify-proof:
	# cd proof && snarkjs groth16 verify ../setup2/verification_key.json public.json proof.json
	cd proof && snarkjs plonk verify ../setup2/verification_key.json public.json proof.json
	# cd proof && snarkjs fflonk verify ../setup2/verification_key.json public.json proof.json

gen-sol:
	mkdir -p sol
	cd sol && snarkjs zkey export solidityverifier ../setup2/circuit_final.zkey verifier.sol

gen-sol-args:
	mkdir -p sol
	# cd proof && snarkjs generatecall public.json proof.json > verifier_args.txt
	cd proof && snarkjs zkey export soliditycalldata public.json proof.json > verifier_args.txt
	mv proof/verifier_args.txt sol/
