# What is stuff this Language and TOolchain should have 

## Lexer 

### Interactive Debugging

- Like rust, zig or newer languages
- An easy to follow stack trace 
- Help with any issues that might occur

### Optimized Tokenization

- See if this can be parallellized 
- Look at how we can include files
 
## Parser

### Static Analysis 

### AST
- AST LOWERING 


## Compiling

### Special Support 

- How do we allow for C code generation to run with CUDA 
- H

### Incremental Compilation

- parallellized 
- Only look at code which was used




## Data types in General 

### SIMD 

- Have our own SIMD type would be pretty neat
- SIMD[i32]

### Cuda Types Built In

- CudaHandle
- CudaArray 
- CudaStatus
- CudaTimer 

And much more 

But the important part for cuda is to generate .cu files.
What we then want is to be able to send these over to gonflux files and work with them back at this source code after 

### Structs 
- could have builtin `destroy` function you can override potentially


## Extras

- Loop unrolling 
- Matrix libary built in 
- Borrow checker or manual memor managment.
- Defer keyword is nice to have if blocks exist




## Things that should be easy for a programmer in GonFLUX

- Create gpu source files: .cugflx that lets you write cuda code
- Write highly parallellized programs 
- Easy to learn and use Atomics, Mutexes and so on
- Spawning threads, getting info and cleaning up should be so easy 
- Same goes for spawning channels, sending and receiving
- Locks and everything shold be easy to implement and read/write
- Atomic[i32], Matrix[i32], SIMD[i32], Vector[i32], [i32], Set[i32],HashMap[i32, str], Pointer[i32] should all speak for themselves and be easy to use. 

Example: 

mut threads: Vec[Thread] = {t1, t2, t3}
threads.forEach(\t: Thread -> t.join())


