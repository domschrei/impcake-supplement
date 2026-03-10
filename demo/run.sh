#!/bin/bash
set -ex

tar -xzvf demo.tgz

../impcake/build/impcheck_check -fifo-directives=directives.0.impcheck -fifo-feedback=out.impcheck -key-seed=13805254743912277295
../impcake/build/impcheck_check -fifo-directives=directives.1.impcheck -fifo-feedback=out.impcheck -key-seed=13805254743912277295
../impcake/build/impcheck_check -fifo-directives=directives.2.impcheck -fifo-feedback=out.impcheck -key-seed=13805254743912277295
../impcake/build/impcheck_check -fifo-directives=directives.3.impcheck -fifo-feedback=out.impcheck -key-seed=13805254743912277295
