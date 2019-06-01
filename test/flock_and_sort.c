#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/file.h>
#include <time.h>
#include <getopt.h>
#include <string.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <libgen.h>

#ifdef _MSC_VER
#include <Windows.h>
#endif

#define TIMEOUT 50000
#define MAX_WRITE_SIZE 16
#define DEBUG 1

#ifdef DEBUG
#define SLEEP_TIME 15
#endif

#ifndef SLEEP_TIME
#define SLEEP_TIME 1
#endif

#define u16 unsigned short
#define u32 unsigned int
#define u64 unsigned long long int

char *program;

typedef struct base_info{
    int fd;
    char *filepath;
    char *test_result;
} base_info;

typedef struct result_info {
    int index;
    char *result;
    base_info *bi;
} result_info;

/* functions */
static inline void usage();
static inline int f_lock(base_info *bi);
static inline int write_test_result(base_info *bi);
static inline void abrt_handler(int sig);

/* global variable */
const char *opt_string = "dhl:r:";
//volatile sig_atmic_t e_flag = 0;

void usage()
{
    fprintf(stdout, "Usage : %s filepath\n", program);
    exit(1);
}

void abrt_handler (int sig) {
}

int is_exit(char *p, size_t st)
{
    int err, ret;
    struct stat *sbuf = malloc(sizeof(stat));
    ret = stat(p, sbuf);
    err = errno;
    if (err == ENOENT) {
        perror("stat : ");
        exit(ret);
    }
    return 0;
}

void opt_perse(int argc, char **argv, base_info *bi)
{
    int opt, ret;
    u16 verbose;

    while ((opt = getopt(argc, argv, opt_string)) != -1) {
        switch (opt) {
            case 'd':
                verbose = 1;
                break;
            case 'h':
                usage();
            case 'l':
                bi->filepath = optarg;
                ret = is_exit(bi->filepath, sizeof(stat));
                break;
            case 'r':
                bi->test_result = optarg;
                break;
            default:
                usage();
                break;
          }
      }
}
void debug_msg(char *m)
{
    const time_t t = time(NULL);
    fprintf(stdout, "%s : %s\n", ctime(&t), m);
}

int f_lock(base_info *bi)
{
    int ret;

    if ((bi->fd = open(bi->filepath, O_WRONLY|O_APPEND)) != -1) {
        if (flock(bi->fd, LOCK_EX) == 0) {
#ifdef DEBUG
            debug_msg("Lock Success");
#endif
            /* This sleep is for waiting for exclusive control */
            sleep(SLEEP_TIME);
        } else {
            ret = errno;
            goto err_exit;
        }
    } else {
        ret = errno;
        goto err_exit;
    }

    // Test result
    ret = write_test_result(bi);

    return 0;

err_exit:
    perror("");
    return ret > 0 ? 0 : ret;
}

int sort_result(result_info *rs) {
    return 0;
}

int write_test_result(base_info *bi)
{
    int ret;
    char *buf = malloc(MAX_WRITE_SIZE);
    sprintf(buf, "%s\n", bi->test_result);
    ret = write(bi->fd, buf, strlen(bi->test_result)+1);

    if (ret < 0)
        printf("Error: write(%d) %s\n", errno, strerror(errno));

    return ret ? 0 : ret;
}

int main (int argc, char **argv)
{
    base_info *bi = malloc(sizeof(base_info));
    program = basename(argv[0]);

    opt_perse(argc, argv, bi);

    f_lock(bi);

    return 0;
}
