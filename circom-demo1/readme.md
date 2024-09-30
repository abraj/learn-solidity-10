# circom-demo1

## Initial setup (one-time)

```bash
make setup
```

This is one-time process. For each circuit, we can keep the `setup1` directory, where
the trusted setup data is stored. So, `make clean` does not delete the `setup1` directory.

## Generate Prover key and Verification key (per circuit)

```bash
make build
```

The _prover key_ and _verification key_ are _**circuit_final.zkey**_ and _**verification_key.json**_ respectively,
and are present in the `setup2` directory.

## Generate Beacon hash

```bash
openssl rand -hex 32
```

The _beacon hash_ used in `snarkjs powersoftau beacon ..` and `snarkjs zkey beacon ..`
commands are generated using the above command.

## Proof generation

```bash
make proof
```

In the `proof` directory, _**input.json**_ contains the user inputs, and _**proof.json**_ contains the
actual **proof** (which would be submitted to the _verifier_).

**NOTE 1:** The _input.json_ file is created at _run-time_ using the contents provided in
the `input.sh` file.
**NOTE 2:** By default, the **plonk** ZKP protocol is used, which can be changed to **groth16**
or **fflonk** (beta).

## Proof verification

```bash
make verify
```

## Deploy on testnet (Sepolia)

```bash
source /Users/abraj/dev/archive/learn-solidity/env/.env
forge create src/verifier.sol:Groth16Verifier --rpc-url $SEPOLIA_RPC_URL --account $ACCOUNT3 --password-file $PWD_FILE3 --verify --etherscan-api-key $ETHERSCAN_API_KEY
# Deployed to: 0x0f08d736CA56ADF6cF681393aFAb629fa908D2f9
```

## Call `verifyProof()` function (Sepolia)

```bash
cast call 0x0f08d736CA56ADF6cF681393aFAb629fa908D2f9 "verifyProof(uint[2],uint[2][2],uint[2],uint[1])" \
"[1899140503197054503381891601567174001985320723178494005329472530987088680991,10768360388176573691599985361088423243379149241689486556031514949852660137002]" \
"[[7555195985569386072529255586479261021550516357667731379698281936933160729820,19612063625073762886803320692172098757249729939757908412020472146537833915573],[14873258277875468781761232924650766724660812722345975242393515177956738667332,12348923145151822065510007195163955515867020373568749022635133858452358615016]]" \
"[3775372478546619598717395588368604555750630755588388844948978815472279081237,17520935207057145255449959698879644706180295613824811006260963580042465634291]" \
"[12]" \
--rpc-url $SEPOLIA_RPC_URL
```

## Convert hex string to decimal (`uint256`)

```shell
cast to-dec 0x2787b4933f5e59d4bf918238b5a48435e49f5d4448d4ce9c266a498c74262355
>> 17879971732620541488824076873575174506594306971313800038696472868180302635861
```
