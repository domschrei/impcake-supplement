NOTE: These instructions are for BUILDING the artifact. It is NOT the artifact itself!

## Docker Image

The Docker image is built by running `./prepare-artifact.sh` from the [repository](https://github.com/domschrei/impcake-supplement).

It assumes that all of the submodules are loaded.

## Obtaining and Installing ImpCake

ImpCake is available as a submodule in the [`impcake`](impcake) folder.

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

The CakeML backend for ImpCake is built using the following HOL and CakeML
commits, which are also included as submodules:

```
HOL: 60700bdf7cbbfca4f59cf0a84c07c2ce018801cc

CakeML: d472c73076c082391d91d2f3b87687f720322840
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


## Integration in Mallob

We used [this commit of Mallob](https://github.com/domschrei/mallob/tree/a0f5c087f2c7b9041700d085f54a13eaadb988e3) for experiments. Build Mallob normally and move the binaries `impcheck_{parse,check,confirm}` to Mallob's `build/` directory. You can then use verified real-time checking via the Mallob options `-otfc=1 -otfcm=0`.


## Experimental data

All relevant experimental data surrounding the paper can be found at `experimental-data/`.

