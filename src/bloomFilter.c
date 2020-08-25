#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "murmur3.h"
#include <math.h>

struct bloomFilter
{
    int size;
    float false_prob;
    int exp_n;
    int hash_count;
    int* arr;
    int count;
};
typedef struct bloomFilter* bFilter;

bFilter newBloomFilter(float fp, int exp_n){
    bFilter b = (bFilter)malloc(sizeof(struct bloomFilter));
    
    b->false_prob = fp;
    b->exp_n = exp_n;
    float x = ((-1)*exp_n)*log(fp);
    x=x/(log(2)*log(2));
    b->size = x;
    float y = (1.0*b->size) / (1.0*b->exp_n);
    y=y*log(2);
    b->hash_count = y;
    b->arr = (int*) malloc(b->size * sizeof(int));
    for(int i=0;i<b->size;i++){
        b->arr[i]=0;
    }
    b->count =0;
    return b;
}

uint32_t hashing(char* s, int seed){
    uint32_t hash[4];
    MurmurHash3_x86_32(s,strlen(s),seed,hash);
    return hash[0];
}

void insert(char* s, bFilter b){
    for(int i=0;i<b->hash_count;i++){
        int hash = (hashing(s,i) % b->size);
        b->arr[hash]=1;
    }
    b->count++;
}

int has(char* s, bFilter b){
    for(int i=0;i<b->hash_count;i++){
        int hash = hashing(s,i) % b->size;
        if(b->arr[hash]==0){
            return 0;
        }
    }
    return 1;
}

void show_bloom(bFilter b){
    for(int i=0;i<b->size;i++){
        printf("%d ",b->arr[i]);
    }
    printf("\n");
}

float cosine_sim(bFilter b1, bFilter b2){
    float sum =0;
    float s1=0;
    float s2=0;
    for(int i=0;i<b1->size;i++){
        sum += (b1->arr[i]*b2->arr[i]);
        s1+=b1->arr[i];
        s2+=b2->arr[i];
    }
    s1=sqrt(s1);
    s2=sqrt(s2);
    sum = sum / (s1*s2);
    return sum;
}

void free_bloom(bFilter b){
    free(b->arr);
    free(b);
}