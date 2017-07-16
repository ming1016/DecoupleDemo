//
//  main.m
//  DecoupleDemo
//
//  Created by DaiMing on 16/3/23.
//  Copyright © 2016年 Starming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//#import "SMCallTrace.h"
//
//static int (*orig_close)(int);
//static int (*orig_open)(const char *, int, ...);
//
//int my_close(int fd) {
//    printf("Call real close(%d)\n",fd);
//    return orig_close(fd);
//}
//
//int my_open(const char *path, int oflag, ...) {
//    va_list ap = {0};
//    mode_t mode = 0;
//    
//    if ((oflag & O_CREAT) != 0) {
//        va_start(ap, oflag);
//        mode = va_arg(ap, int);
//        va_end(ap);
//        printf("Calling real open('%s',%d,%d)\n", path, oflag, mode);
//        return orig_open(path, oflag, mode);
//    } else {
//        printf("Calling real open('%s', %d)\n", path, oflag);
//        return orig_open(path, oflag, mode);
//    }
//    
//}

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        smRebindSymbols((struct smRebinding[2]){{"close", my_close, (void *)&orig_close},{"open", my_open, (void *)&orig_open}}, 2);
//        
//        int fd = open(argv[0], O_RDONLY);
//        uint32_t magic_number = 0;
//        read(fd, &magic_number, 4);
//        printf("Mach-O Magic Number: %x \n", magic_number);
//        close(fd);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
