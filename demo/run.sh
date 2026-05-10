#!/bin/bash
set -ex

tar -xzvf demo.tgz

../impcake/build/impcheck_check -directives=directives.0.impcheck -feedback=out.impcheck -key-seed=13805254743912277295
../impcake/build/impcheck_check -directives=directives.1.impcheck -feedback=out.impcheck -key-seed=13805254743912277295
../impcake/build/impcheck_check -directives=directives.2.impcheck -feedback=out.impcheck -key-seed=13805254743912277295
../impcake/build/impcheck_check -directives=directives.3.impcheck -feedback=out.impcheck -key-seed=13805254743912277295
