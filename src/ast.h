#include "pch.h"
#include "token.h"
#include <iostream>
#include <vector>

union NodeTypes {
        short F32;
        int INT;
};

template <typename T> struct AstNode {
        T value;
        TokenType type;
        Location location;
        AstNode *parent;
        std::vector<AstNode *> children; // or **Node
};

template <typename T> struct AST {
        AstNode<T> *root;
        u32 size;

        AST(AstNode<T> *root) : root{root}, size{1} {}

        void dfs();
        void bfs();

        void insert();
        void remove();
        void build();
};
