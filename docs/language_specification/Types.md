# Core Data Types for GonFLUX

## Integers 

i8, i16, i32, i64, i128 -12347

## Unsigned Integers 
u8, u16, u32, u64, u128 123 

## Floats 
f8, f16, f32, f64, f128 0.123

## Atomic Integers
`atomic` is a keyword which marks a variable as atomic

## Booleans
bool, true

## Strings 
str, "A string"

## Char 
char, 'a'

## Enums 
enum,

## Structs
struct 

## Option, which is basically a built in Enum 
Option[U, V] means: 
enum Option ->
    left: U,
    right: V,
end

## Array 
Array[i32]


## Vectors 
Vector[i32], dynamically sized arrays

## Ranges
Works like an iterator containing pointer to start, and how long it will be
0..10, 1..=20 

## SIMD 
SIMD[i32]
Target the specific registers to perform simd vector operations

## Sets 
Set[i32]

## CUDA Types 
CudaArray[f32]
CudaHandle
CudaStatus

## In the future: 
- Semaphores
- Mutex 
- Thread type
- Matrix


