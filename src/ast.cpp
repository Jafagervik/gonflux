#include "ast.h"

template <typename T> void AST<T>::dfs() {
    auto start = root;
    std::stack<AstNode<T> *> stack{start};

    while (!stack.empty()) {
        const auto curr_node = stack.pop();
        std::cout << curr_node->value << '\n';
        for (const auto node : curr_node->children) {
            stack.push(node);
        }
    }
    return;
}

template <typename T> void AST<T>::bfs() {
    auto start = root;
    std::queue<AstNode<T> *> queue{start};

    while (!queue.empty()) {
        const auto curr_node = queue.pop();
        std::cout << curr_node->value << '\n';
        for (const auto node : curr_node->children) {
            queue.push(node);
        }
    }
    return;
}
