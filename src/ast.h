#include <vector>
#include "pch.h"
#include "token.h"

union NodeTypes {
        short F32;
        int INT;
};

template <typename T> struct AstNode {
        T value;
        TokenType type;
        Location location;
        struct AstNode *parent;
        std::vector<struct AstNode *> children; // or **Node
};

typedef struct AST {
        struct AstNode<int> *root; // Beginning of file

} AST;
