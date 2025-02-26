#include "kernel/types.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char *argv[]){
    char buf[512];
    char *x_argv[MAXARG];
    int x_argc = argc - 1;
    char *arg_s, *arg_e;
    char ch;
    int read_bytes, has_arg = 0, child_pid;

    for(int i = 1; i < argc; i++){
        x_argv[i - 1] = argv[i];
    }

    arg_s = arg_e = buf;

    while((read_bytes = read(0, &ch, sizeof(char))) == 1){
        if(arg_e >= buf + 512 - 1){
            fprintf(2, "xargs: argument too long\n");
            arg_s = arg_e = buf; // reset buffer
            continue;
        }
        if(ch == '\n' || ch == ' '){
            if(has_arg){
                *arg_e = '\0';
                if(x_argc >= MAXARG - 1){
                    fprintf(2, "xargs: too many arguments\n");
                    x_argc = argc - 1;
                    arg_s = arg_e = buf;
                    continue;
                }
                x_argv[x_argc++] = arg_s;
                has_arg = 0;
            }
            arg_e++;

            if(ch == '\n'){
                if(x_argc > argc - 1){
                    x_argv[x_argc] = 0;
                    if((child_pid = fork()) < 0){
                        fprintf(2, "xargs: fork failed\n");
                        exit(1);
                    } else if(child_pid == 0){
                        for(int i = 0; i < x_argc; i++){
                            fprintf(2, "xargs: arg[%d] = %s\n", i, x_argv[i]);
                        }
                        exec(x_argv[0], x_argv);
                        fprintf(2, "xargs: exec failed\n");
                        exit(1);
                    }
                }
                x_argc = argc - 1; // reset arg list
                arg_s = arg_e = buf;
            }
        } else{
            *arg_e++ = ch;
            has_arg = 1;
        }
    }

    // execute the last command if input does not end with '\n'
    if(has_arg){
        *arg_e = '\0';
        if(x_argc >= MAXARG - 1){
            fprintf(2, "xargs: too many arguments\n");
            exit(1);
        }
        x_argv[x_argc++] = arg_s;
        x_argv[x_argc] = 0;

        if((child_pid = fork()) < 0){
            fprintf(2, "xargs: fork failed\n");
            exit(1);
        } else if(child_pid == 0){
            exec(x_argv[0], x_argv);
            fprintf(2, "xargs: exec failed\n");
            exit(1);
        }
    }

    while(wait(0) > 0);

    exit(0);
}