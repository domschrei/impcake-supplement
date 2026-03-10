# impcake-supplement
Supplementary data and information for ImpCake submission.


# Obtaining and Installing ImpCake

The submission version of ImpCake is available as a submodule in the [`impcake`](impcake) folder.

It can also be obtained from this [release tag](https://github.com/tanyongkiam/impcheck/releases/tag/v0.0.1).

For the demo purposes, build it as follows (with a fixed salt):

```
mkdir -p build ; cd build ; \
cmake .. -DCMAKE_BUILD_TYPE=RELEASE -DIMPCHECK_WRITE_DIRECTIVES=0 \
  -DIMPCHECK_FLUSH_ALWAYS=1 -DIMPCHECK_OVERRIDE_SALT=10612107877455657503UL ; \
make ; cd ..
```

Then ImpCake can be tested locally in the [`demo`](demo) folder:

```
./run.sh
```

You should obtain output like the following, indicating that one of the threads
validated UNSAT, and reporting some additional proof statistics:

```
c [TRUSTED_CORE 1931622] cpu:0.748 prod:114672 imp:867 del:100213 maxid=19020
c [TRUSTED_CORE 1931624] UNSAT validated
c [TRUSTED_CORE 1931624] cpu:0.784 prod:122735 imp:1023 del:111384 maxid=18886
c [TRUSTED_CORE 1931645] cpu:0.699 prod:111925 imp:1066 del:99703 maxid=20714
c [TRUSTED_CORE 1931646] cpu:0.699 prod:107805 imp:810 del:94610 maxid=20169
```
 
## ImpCake verification

The CakeML backend for ImpCake is built using the following HOL and CakeML commits, which are also included as submodules:

```
HOL: e123aecd90978b618a941fe09eeead218e038a08

CakeML: 15c9772d3b382b51989734f564ee5f65bad43c9d
```

In order to build the full verification, follow the build instructions for HOL.
Then, run the following to build the main refinement proofs and including Theorem 1 / Corollary 2 inside `distrup_globalScript.sml`

```
cd cakeml/examples/cnf/dist/array/ ; Holmake
```

To obtain the machine code implementation and its proofs, further run the following.
The final theorem will be in `disrupProofScript.sml`:

```
cd cakeml/examples/cnf/dist/array/compilation/proofs ; Holmake
```

