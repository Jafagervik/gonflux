#pragma once

#include <iostream>
#include "pch.h"

typedef enum Target { X8664, RISCV, NVIDIA, R7000 } Target;

typedef struct Args {
        bool optimize = false;
        Target target = X8664;

        /** formats a printLayout in which everyone can understand the
         * contents
         *
         *
         */
        void printHelper();
} Args;
