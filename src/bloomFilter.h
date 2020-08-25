#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "murmur3.h"

struct bloomFilter;
typedef struct bloomFilter* bFilter;

bFilter newBloomFilter(float fp, int exp_n);

uint32_t hashing(char* s, int seed);

void insert(char* s, bFilter b);

int has(char* s, bFilter b);
void show_bloom(bFilter b);
float cosine_sim(bFilter b1, bFilter b2);
void free_bloom(bFilter b);
