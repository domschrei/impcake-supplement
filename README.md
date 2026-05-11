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

A simple smoke test is in `demo/`. Run:

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

## Full Review

TODO ImpCake full review

## Formalization

The HOL and CakeML formalization relevant are pre-built.

The easiest way to browse the theories is to run:

  ```bash
  cd /app/cakeml/examples/cnf/dist/array/compilation/proofs
  /app/HOL/bin/hol < scripts/theories.txt
  ```

This will insert you into an interactive HOL session and pre-load all of the relevant formalized theories files.

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
  Holmake cleanAll
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

