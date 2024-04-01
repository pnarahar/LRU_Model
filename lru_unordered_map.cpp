#include <iostream>
#include <unordered_map>
#include <chrono>

class Cache {
private:
    std::unordered_map<int, std::pair<int, std::chrono::time_point<std::chrono::steady_clock>>> cache; // Key: input, Value: (result, last_access_time)
    int capacity;
    int numHits;
    int numMisses;
    double totalAccessTimeHits;
    double totalAccessTimeMisses;

public:
    Cache(int capacity) {
        this->capacity = capacity;
        numHits = 0;
        numMisses = 0;
        totalAccessTimeHits = 0;
        totalAccessTimeMisses = 0;
    }

    int get(int input) {
        auto it = cache.find(input);
        if (it != cache.end()) {
            std::cout << "Cache hit for input " << input << ": " << cache[input].first << std::endl;
            std::chrono::duration<double> accessTime = std::chrono::steady_clock::now() - cache[input].second;
            totalAccessTimeHits += accessTime.count();
            numHits++;
            return cache[input].first;
        }
        std::cout << "Cache miss for input " << input << std::endl;
        numMisses++;
        return -1; // Cache miss
    }

    void put(int input, int result) {
        if (cache.size() >= capacity) {
            // Evict the least recently used element
            auto lru_it = cache.begin();
            for (auto it = cache.begin(); it != cache.end(); ++it) {
                if (it->second.second < lru_it->second.second)
                    lru_it = it;
            }
            cache.erase(lru_it);
        }
        cache[input] = std::make_pair(result, std::chrono::steady_clock::now());
        std::cout << "Inserted input " << input << " with result " << result << " into cache" << std::endl;
    }

    double getHitRate() {
        return numHits / static_cast<double>(numHits + numMisses);
    }

    double getMissRate() {
        return numMisses / static_cast<double>(numHits + numMisses);
    }

    double getAverageAccessTimeHits() {
        return totalAccessTimeHits / numHits;
    }

    double getAverageAccessTimeMisses() {
        return totalAccessTimeMisses / numMisses;
    }
};

int main() {
    Cache cache(2); // Capacity of 2

    // Warm-up cache
    cache.put(1, 10);
    cache.put(2, 20);

    const int numIterations = 100000;
    for (int i = 0; i < numIterations; ++i) {
        cache.get(1);
        cache.get(2);
        cache.get(3);
    }

    std::cout << "Cache hit rate: " << cache.getHitRate() << std::endl;
    std::cout << "Cache miss rate: " << cache.getMissRate() << std::endl;
    std::cout << "Average access time for hits: " << cache.getAverageAccessTimeHits() << " seconds" << std::endl;
    std::cout << "Average access time for misses: " << cache.getAverageAccessTimeMisses() << " seconds" << std::endl;

    return 0;
}
