%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include "bloomFilter.h"

char* stack[3];
int stkptr=0;
bFilter arr[50];
int k=0;
void yyerror (char *s);
extern int yylex();
extern FILE *yyin;
extern FILE *yyout;
void push(char* s);
%}
%union {
    char* txt;
}
%start line
%token <txt> word
%token error
%type  <txt> line exp

%%

line    : exp ' '                {}
        | exp '\n'                {}
        | line exp ' '           {}   
        | line exp '\n'           {}   
        | error ' '             {} 
        | error '\n'             {} 
        | line error '\n'         {} 
        | line error ' '         {}
        | line error         {} 
        ;

exp     : word        {push($1);}

%%

void push(char* s){
    if(s[strlen(s)-1]=='.' || s[strlen(s)-1]==',' || s[strlen(s)-1]==':'){
        s[strlen(s)-1]='\0';
    }

    if(stkptr <3){
        stack[stkptr]=s;
        stkptr++;
    }else{
        free(stack[0]);
        stack[0]=stack[1];
        stack[1]=stack[2];
        stack[2]=s;
    }
    if(stkptr == 3){
        int len = strlen(stack[0]) + strlen(stack[1]) + strlen(stack[2]) + 10;
        char* arg = (char*)malloc(len*sizeof(char));
        strcat(arg,stack[0]);
        strcat(arg," ");
        strcat(arg,stack[1]);
        strcat(arg," ");
        strcat(arg,stack[2]);
        /*printf("%s\n",arg);*/
        insert(arg,arr[k]);
        free(arg);
    }
}


void yyerror(char* s){
    
}

int main(int argc, char *argv[]){
    char* doc[25];
    int x;
    
    DIR* dir;

    struct dirent *ent;

    if ((dir = opendir (argv[2])) != NULL) 
    {
      // print all the files and directories within directory 
      while ((ent = readdir (dir)) != NULL) 
      { 
        if ((strcmp(ent->d_name,".") != 0) && (strcmp(ent->d_name,"..") != 0) && (strstr(ent->d_name,".txt") != NULL))
        {   
                int len = strlen(ent->d_name)+ strlen(argv[2])+ 10;
                char* arg = (char*)malloc(len*sizeof(char));
                strcat(arg,argv[2]);
                strcat(arg,"/");
                strcat(arg,ent->d_name);
                arr[k] = newBloomFilter(0.3, 10000);
                yyin = fopen(arg,"r");
                doc[k]= strdup(ent->d_name);
                x=yyparse();

                stkptr=0;   
                fclose(yyin);   
                k++;    
        }

      }                         
      closedir (dir);
    } 
    else 
    {
      // could not open directory 
      perror ("could not open directory");
      return EXIT_FAILURE;
    }
    int j=k;
    arr[k] = newBloomFilter(0.3, 10000);
    yyin = fopen(argv[1],"r");

    x=yyparse();

    stkptr=0;   
    fclose(yyin); 

    for(int i=0;i<k;i++){
        float f = 100*cosine_sim(arr[i],arr[j]);
        printf("%s %f\n", doc[i],f);
    }

    
    return x;
}