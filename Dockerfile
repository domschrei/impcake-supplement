################### Build Mallob
FROM mallob-cav26:latest
USER root

WORKDIR /app

# Fetch Poly/ML
RUN git clone --branch fixes-5.9.2 --single-branch https://github.com/polyml/polyml.git

# Install it
RUN cd polyml && git checkout ccd3e3717f7238b9b5d295fea4b5426182dfc0b6 && \
  ./configure && make && make install

# Paths
RUN echo /usr/local/lib | tee /etc/ld.so.conf.d/polyml.conf && ldconfig

COPY ./HOL HOL
COPY ./cakeml cakeml
COPY ./impcake impcake
COPY ./demo demo

# Build ImpCake (demo)
RUN cd impcake ; mkdir -p build ; cd build ; \
cmake .. -DCMAKE_BUILD_TYPE=RELEASE -DIMPCHECK_WRITE_DIRECTIVES=0 \
  -DIMPCHECK_FLUSH_ALWAYS=1 -DIMPCHECK_OVERRIDE_SALT=10612107877455657503UL ; \
make ; cd ..

# Up to here, we can run demo/run.sh

# Build HOL
RUN cd HOL && poly < tools/smart-configure.sml && ./bin/build

# Build CakeML (relevant folders only)
RUN cd cakeml/examples/cnf/dist && /app/HOL/bin/Holmake
RUN cd cakeml/examples/cnf/dist/array && /app/HOL/bin/Holmake
RUN cd cakeml/examples/cnf/dist/array/compilation/proofs && /app/HOL/bin/Holmake

COPY ./scripts/theories.txt scripts/theories.txt
