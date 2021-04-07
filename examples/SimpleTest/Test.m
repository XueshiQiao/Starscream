//
//  Test.m
//  SimpleTest
//
//  Created by joey on 2021/4/4.
//  Copyright © 2021 vluxe. All rights reserved.
//

#import "Test.h"
#import "fishhook.h"

static int (*orig_close)(int);
static int (*orig_open)(const char *, int, ...);
 
int my_close(int fd) {
  printf("Calling real close(%d)\n", fd);
  return orig_close(fd);
}
 
int my_open(const char *path, int oflag, ...) {
  va_list ap = {0};
  mode_t mode = 0;
 
  if ((oflag & O_CREAT) != 0) {
    // mode only applies to O_CREAT
    va_start(ap, oflag);
    mode = va_arg(ap, int);
    va_end(ap);
    printf("Calling real open('%s', %d, %d)\n", path, oflag, mode);
    return orig_open(path, oflag, mode);
  } else {
    printf("Calling real open('%s', %d)\n", path, oflag);
    return orig_open(path, oflag, mode);
  }
}

static int (*orig_mptcp_session_create)(struct mppcb *mppcb);

int my_mptcp_session_create(struct mppcb * mppcb) {
    printf("------my_mptcp_session_create----");
    return orig_mptcp_session_create(mppcb);
}

@implementation Test

+ (void)load {
     
    @autoreleasepool {
        rebind_symbols((struct rebinding[3]){
            {"close", my_close, (void *)&orig_close},
            {"open", my_open, (void *)&orig_open},
            {"mptcp_session_create", my_mptcp_session_create, (void *)&orig_mptcp_session_create }
        }, 3);

        // Open our own binary and print out first 4 bytes (which is the same
        // for all Mach-O binaries on a given architecture)
        int fd = open("", O_RDONLY);
        uint32_t magic_number = 0;
        read(fd, &magic_number, 4);
        printf("Mach-O Magic Number: %x \n", magic_number);
        close(fd);
    }
}

@end
