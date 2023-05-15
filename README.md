# GonFLUX - A statically typed multi paradigm language

## Current status 

Read wiki :D
Other than that: Lexer parses ~4500 tokens in average 0.007 seconds


## Why do we need another statically typed imperative language  

Writing parallel, concurrent or HPC code in general is very hard at the moment,
compared to writing sequential code. Languages are great at standardizing certain keywords, 
functions or datatypes for working sequentially and homogenous, but when working outside
these areas, on standardized naming or conventions are used. Also, a lot of calls to 
e.g POSIX threads either have many weird conventions, or feels non-trivial to set up and 
communicate with. 

We want to change this by 1. making sure working with threads and processes feels easier to
get into for beginners, while giving flexibility to people with more experience. 

For the case of graphics programming, or programming on GPGPU, the way most code is written
feels bloated. A lot of status wrappers around each single function call 

We also believe that certain common operations as File and Network I/O, timing your code,
package managing and testing can all be improved, and there is a lot to be simplified in the syntax.

This language and toolchain will also be used for research on new methods to deal with race conditions,
deadlocks, livelocks, memory managment and compiler optimization.

Integrated support for vector processing is also something we may want to look into in the future



## Why did we switch from Zig to C++ 

Unstability in compiler, unfamiliarity among people on this project and young ecosystem 

ZIG is a great language, but if we want to reach interop with CUDA or do codegeneration into C or C++ 
code, using C or C++ in the first place feels natural. 
These languages are also known for performance, and this will show in the release of this toolchain.


## Main aspects of this language

- Multiparadigm
- Statically typed 
- Easy-to-learn syntax
- Built in support for concurrency and parallelism
- Process and thread managment should be more standardized, and simpler to set up
- A robust and easy to integrate standard library


## Core philosofy

This language should be able to create robust applications, while
also being one to easily teach people about aspects such as atomics, processes,
semaphores, mutexes, threads, multicore programming, distributed- and parallel programming 

## Targets

- RISC V
- X86-64
- ARM64 M2?
- Raspbery PI
- AMD graphic cards?

## How to contribute

Read `CONTRIBUTING.md`


## Creation

This project is handled by Uedalab, a computer science lab at Waseda University in
Tokyo, Japan, under the guidance of prof. UEDA, Kazunori.
