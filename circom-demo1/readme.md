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
forge create ..
```

## Call `verifyProof()` function (Sepolia)

```bash
cast call 0x28c3ac3B91B7857E477B1B6f3F45f5a46d659d26 "verifyProof(uint[2],uint[2][2],uint[2],uint[1])" \
"[3216373698803606519547370528919283495552496498121204751701006361046192725304,3663939795137941301283546223341562569172863082549136147345862202810188572251]" \
"[[14211784195395077882861584496983403192131719029280821316137920956591324536322,20848238449727717924710842239831824699857202099127540480877464054926128910658],[4883496965181218647482801490518689660823469320195583587616850452563283203531,16404510179484462825185958027559062238167245966780643268394459536576504247463]]" \
"[3923373300514109610253779172501870191791959304455879594867660963360639925635,15858009582295822230836095440610495293521072813785126635417839979401941106366]" \
"[33]" \
--rpc-url $SEPOLIA_RPC_URL
```

## Convert hex string to decimal (`uint256`)

```shell
cast to-dec 0x2787b4933f5e59d4bf918238b5a48435e49f5d4448d4ce9c266a498c74262355
>> 17879971732620541488824076873575174506594306971313800038696472868180302635861
```
