#include <iostream>
#include <unordered_map>
#include <chrono>

class DLL {
public:
    int key;
    int val;
    DLL* prev;
    DLL* post;

    DLL(int key, int val) : key(key), val(val), prev(nullptr), post(nullptr) {}
};

DLL* head = nullptr;
DLL* tail = nullptr;
int count = 0;
int capacity = 0;
std::unordered_map<int, DLL*> m;

void remove_node(DLL* node) {
    if (node == nullptr) {
        std::cerr << "Error: Attempting to remove a null node" << std::endl;
        return;
    }
    DLL* prev = node->prev;
    DLL* post = node->post;
    prev->post = post;
    post->prev = prev;
    delete node;
}

void add_node(DLL* node) {
    if (node == nullptr) {
        std::cerr << "Error: Attempting to add a null node" << std::endl;
        return;
    }
    node->post = head->post;
    head->post->prev = node;
    head->post = node;
    node->prev = head;
}

void move_to_front(DLL* node) {
    if (node == nullptr) {
        std::cerr << "Error: Attempting to move a null node to front" << std::endl;
        return;
    }
    add_node(node);
    remove_node(node);
}

DLL* pop_tail() {
    if (tail->prev == nullptr) {
        std::cerr << "Error: Attempting to pop tail from an empty list" << std::endl;
        return nullptr;
    }
    DLL* tail_node = tail->prev;
    remove_node(tail_node);
    return tail_node;
}

void put(int key, int val) {
    DLL* node = m[key];
    if (node == nullptr) {
        count++;
        while (count > capacity) {
            DLL* popped = pop_tail();
            if (popped == nullptr)
                break;
        }
        node = new DLL(key, val);
    } else {
        move_to_front(node);
        node->val = val;
    }
}

int get(int key) {
    DLL* node = m[key];
    if (node == nullptr) {
        std::cerr << "Error: Key not found in cache" << std::endl;
        return -1;
    } else {
        move_to_front(node);
        return node->val;
    }
}

int main() {
    // Example usage
    capacity = 2;

    // Put some values into the cache
    put(1, 10);
    put(2, 20);

    // Retrieve values from the cache
    std::cout << "Retrieved value: " << get(1) << std::endl;
    std::cout << "Retrieved value: " << get(2) << std::endl;
    std::cout << "Retrieved value: " << get(3) << std::endl;

    return 0;
}
