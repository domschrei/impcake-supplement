# ImpCake Supplement

Supplementary data and information for ImpCake submission.

## Content

This artifact contains the following files/folders:

* README.md : The documentation you are currently reading
* LICENSE : MIT license
* impcake-fmcad26-img.tar.gz : A Docker image you can readily import.
* experimental-data : Logs from our experiments.

### Docker Image Content

The Docker image comes with the following, all pre-built:

* mallob : A snapshot of the [Mallob](https://github.com/domschrei/mallob) project
* impcake : A checkout of our ImpCake implementation
* polyml : A checkout of Poly/ML (used to build HOL/CakeML)
* HOL : A checkout of the HOL theorem prover (used to build CakeML)
* cakeml : A checkout of the CakeML formalization

## Setup

We assume that [Docker is properly installed on your system](https://get.docker.com/).

- Import the docker image from `impcake-fmcad26-img.tar.gz`:

  ```bash
  docker load -i impcake-fmcad26-img.tar.gz
  ```
  This will import the docker image named `impcake-fmcad26`, which can take a few moments.

- Start a docker container:
  
  ```bash
  mkdir -p ./share
  docker run -v ./share:/app/share -it --rm impcake-fmcad26:latest
  ```
  This will spin up a new docker container in which all subsequent steps should be executed. You can now reproduce the tests and experiments as explained below.
  
  Result files will be exported to your host machine's directory `./share` (relative to from where you executed the `docker run` command).

- Execute the command `exit` to leave the shell and exit the image at any point.

## Smoke Test

A very simple first smoke test is in `demo/`. Run:

  ```bash
  cd demo ; ./run.sh
  ```

You should see output like this (exact order may differ):

  ```bash
  + ../impcake/build/impcheck_check -directives=directives.0.impcheck -feedback=out.impcheck -key-seed=13805254743912277295
  c [TRUSTED_CORE 18] cpu:0.847 prod:114672 imp:867 del:100213 maxid=19020
  + ../impcake/build/impcheck_check -directives=directives.1.impcheck -feedback=out.impcheck -key-seed=13805254743912277295
  c [TRUSTED_CORE 19] UNSAT validated
  c [TRUSTED_CORE 19] cpu:0.894 prod:122735 imp:1023 del:111384 maxid=18886
  + ../impcake/build/impcheck_check -directives=directives.2.impcheck -feedback=out.impcheck -key-seed=13805254743912277295
  c [TRUSTED_CORE 20] cpu:0.794 prod:111925 imp:1066 del:99703 maxid=20714
  + ../impcake/build/impcheck_check -directives=directives.3.impcheck -feedback=out.impcheck -key-seed=13805254743912277295
  c [TRUSTED_CORE 21] cpu:0.742 prod:107805 imp:810 del:94610 maxid=20169
  ```

For the second part of the smoke test, which involves running Mallob, run:

```
scripts/run-test-smoke.sh
```

which should, at the end, print a line as follows:
```
####################################################################################
All runs done. Find output at /app/share/mallob-123456789abc-123456789
####################################################################################
```

Evaluate the test with:
```
scripts/eval-test-smoke.sh /app/share/mallob-123456789abc-123456789
```
(replace the directory according to the output of the test run).
This first creates raw data files, which form the basis for plots and tables, and then produces said plots and tables.

The output should end like this:
```
####################################################################################
All output written to /app/share/mallob-123456789abc-123456789/output-987654321/
####################################################################################
```

As a basic sanity check, you can read the basic performance table gathered for SAT solving and should get output like this (numbers not accurate):

```
$ cat /app/share/mallob-123456789abc-123456789/output-987654321/table-sat.txt
_                   overall  _        satisf.  _         unsatisf.  _
Run                 #solved  PAR2     #solved  avgtime   #solved    avgtime
c1-sat-mixed        11       4.51659  4        0.040775  7          0.0241091
c1-sat-monolproof   11       4.54403  4        0.107934  7          0.0641143
c1-sat-rtcheck      8        6.03196  3        0.14766   5          0.039245
...
```

Similarly, if you visit the indicated output directory on your host system (i.e., outside of Docker) and open the file `sat-cdf-logscale.pdf`, you should be able to see performance lines for the same eight runs.

**Note:** The experiments of the smoke test are **not** indicative of the different approaches' performance, since the timeouts, scales, and benchmark sets are far too small/low to arrive at any meaningful data.


## Full Experimental Demonstration

The full demonstration is run just like the above smoke test (note that this may take several hours or up to two days):
```
# Full demo (60s time limit per input, full benchmark sets)
scripts/run-test-demo.sh
scripts/eval-test-demo.sh /app/share/mallob-123456789abc-123456789
```

The produced output contains the following files:

* table-sat.txt : Basic performance measures for the different setups.
* sat-cdf.pdf : Performance curves for the different setups (linear scale).
* sat-cdf-logscale.pdf : Performance curves for the different setups (logarithmic scale).
* 1v1-overhead-over-mixed-*.pdf : Per-instance performance comparison of monolithic proof production with unchecked, mixed-portfolio solving.
* 1v1-overhead-*-rtcheck.pdf : Per-instance performance comparison of solving including fast (unverified) real-time proof checking with unchecked, mixed-portfolio solving.
* 1v1-overhead-*-impcake.pdf : Per-instance performance comparison of solving including ImpCake's real-time proof checking with unchecked, mixed-portfolio solving.
* 1v1-overhead-solve-vs-check-*.pdf : Per-instance performance comparison of solving time vs. checking time with monolithic proof production.
* 1v1-overhead-*-impcake-over-rtcheck.pdf : Per-instance performance comparison of solving with ImpCake's real-time proof checking with solving with fast (unverified) real-time proof checking.

In each output, "c1" represents single-core runs, "c8" eight-core runs, etc.


## Formalization

The HOL and CakeML formalization relevant are pre-built.

The easiest way to browse the theories is to run:

  ```bash
  cd /app/cakeml/examples/cnf/dist/array/compilation/proofs
  cat /app/scripts/theories.txt - | /app/HOL/bin/hol
  ```

This will insert you into an interactive HOL session and pre-load all of the relevant formalized theories files.

The load takes a while, you should see some output like this:

  ```bash
  ---------------------------------------------------------------------
       HOL4 [Trindemossen 2 (stdknl, built Mon May 11 15:49:56 2026)]

       For introductory HOL help, type: help "hol";
       To exit type <Control>-D
  ---------------------------------------------------------------------
  ...
  Load completed.
  ```


You can then read a proved theorem by sending its name to the HOL terminal, e.g.:

  ```bash
  distInferTheory.step_sound;

  Output:
  val it =
   ⊢ (reduce infer)꙳ st st' ∧
     (∀name facts.
        FLOOKUP st.procs name = SOME (SOME facts) ⇒ FRANGE facts ⊆ oprems) ∧
     set st.facts ⊆ oprems ∧ st.validated = ∅ ∧ fact ∈ st'.validated ∧
     monotonic infer ∧ cut_elimination infer ∧ assumption infer ⇒
     infer oprems fact: thm
  ```

  ```bash
  distrupProofTheory.compiled_code_produces_events_ok;

  Output:
  val it =
   ⊢ compiled_code_installed mc ms ⇒
     ∀inputs. ∃events.
       machine_sem mc (custom_ffi inputs) ms ⊆
       extend_with_resource_limit {Terminate Success events} ∧
       full_events_ok init_st events: thm
  ```

To do a rebuild of the relevant files, you can first delete the prebuilt theories, then run `Holmake`:

  ```bash
  cd /app/cakeml/examples/cnf/dist
  /app/HOL/bin/Holmake cleanAll
  /app/HOL/bin/Holmake
  cd array; /app/HOL/bin/Holmake
  cd compilation; /app/HOL/bin/Holmake
  cd proofs; /app/HOL/bin/Holmake
  ```

You should see output like this (some lines omitted). The "OK" indicates that the proofs were checked with no errors/omissions.

  ```bash
  ...
  distInferTheory                                              (2s)     OK
  distrupTheory                                                (4s)     OK
  distInferRefineTheory                                        (2s)     OK
  distInferHashTheory                                          (5s)     OK
  ...
  distrup_listTheory                                          (21s)     OK
  distrup_arrayProgTheory                                     (98s)     OK
  distrup_fullProgTheory                                     (299s)     OK
  distrup_globalTheory                                        (79s)     OK
  ...
  distrupCompileTheory                                        (63s)     OK
  ...
  distrupProofTheory                                          (92s)     OK
  ```

### Formalization (glossary)

The relevant contributions are all in the `cakeml/examples/cnf/dist/` directory and its subdirectories.

In the `dist/` folder:

- `distrupScript.sml` Defines a basic specification of a local LRUP checker process and its event handling.

- `distInferScript.sml` is the abstract specification and soundness of distributed inference, culminating in a proof of Theorem 1, which we call `step_sound` in the formalisation.

- `distInferRefineScript.sml` instantiates `step_sound` to entailment of CNF formulas, theorem `sat_step_sound`.

- `distInferHashScript.sml` contains the model referenced in Section III-C, along with a proof of protocol soundness in the presence of a Dolev-Yao attacker.

In the `dist/array` folder:

- `distrup_listScript.sml` Refines the local LRUP checker backend specification from `distrupScript.sml` to a list-based representation.

- `distrup_arrayProgScript.sml` Refines the list-based local checker backend representation from `distrup_listScript.sml` into an array-based CakeML program, but without adding the I/O interface yet.

- `distrup_fullProgScript.sml` Extends `distrup_arrayProgScript.sml` with I/O for interacting with the other parts of the ImpCheck framework, and proves that the resulting CakeML program's I/O traces satisfy `events_ok`. The main result here is `semantics_prog_distrup_prog` stating that the CakeML program terminates successfully after having produced a trace of events; `full_events_ok_main_events` then proves that this trace satisfies `events_ok`.

- `distrup_globalScript.sml` Lifts `events_ok` to a concurrent setting and ultimately proves Corollary 2 (in the formalisation, `sat_step_sound_spec`).

In the `dist/array/compilation` and `dist/array/compilation/proofs` folder:

- `distrupCompileScript.sml` compiles the distrup example by (verified) evaluation inside the logic of HOL.

- `distrupProofScript.sml`  compose the semantics theorem and the compiler correctness theorem with the compiler evaluation theorem to produce an end-to-end correctness theorem for local checkers that reaches the final machine code.
  The relevant theorem statement is `compiled_code_produces_events_ok`.

