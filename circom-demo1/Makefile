.PHONY: test deploy

clean:; rm -rf build

build:
	mkdir -p build
	circom multiplier2.circom --r1cs --c -o build
