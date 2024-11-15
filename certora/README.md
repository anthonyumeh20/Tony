# Morpho token contract formal verification

This folder contains the [CVL](https://docs.certora.com/en/latest/docs/cvl/index.html) specification and verification setup for the [MorphoTokenEthereum](../src/MorphoTokenEthereum.sol) and  [MorphoTokenOptimism](../src/MorphoTokenOptimism.sol) contracts.

## Getting started

This project depends on [Solidity](https://soliditylang.org/) which is required for running the verification.
The compiler binary should be available in the path:

- `solc-0.8.27` for the solidity compiler version `0.8.27`.

To verify a specification, run the command `certoraRun Spec.conf` where `Spec.conf` is the configuration file of the matching CVL specification.
Configuration files are available in [`certora/confs`](confs).
Please ensure that `CERTORAKEY` is set up in your environment.

## Overview

These Morpho token is an ERC20 token with support for delegation of voting power, upgradeability and cross-chain interactions.
Despite the contract being upgradeable, we verify however that the implementation doesn't perform delegate calls, which implies that the implementation is immutable.

Note: the compiled contracts may include loops related to handling strings from the EIP712, for this reason the verification is carried with the option `optimistic_loop` set to `true` in order to avoid related counterexamples.

### External calls

This is checked in [`ExternalCalls.spec`](specs/ExternalCalls.spec).

## Verification architecture

### Folders and file structure

The [`certora/specs`](specs) folder contains the following files:

- [`ExternalCalls.spec`](specs/Reentrancy.spec) checks that the Morpho token implementation is reentrancy safe by ensuring that no function is making and external calls and, that the implementation is immutable as it doesn't perform any delegate call.

The [`certora/confs`](confs) folder contains a configuration file for each corresponding specification file for both the Ethereum and the Optimism version.
