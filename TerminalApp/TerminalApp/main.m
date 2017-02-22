//
//  main.m
//  TerminalApp
//
//  Created by ZhangZn on 2017/1/19.
//  Copyright © 2017年 Bizvane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSString *path = @"/Users/ZhangZn/Desktop/iShow";//文件路径
        NSString *result = @"10011cec4";//错误地址
        long int cutNum = 1052356;

        result = [result stringByReplacingOccurrencesOfString:@"0x0000000" withString:@""];
        NSString *temp = [NSString stringWithFormat:@"%lu",strtoul([result UTF8String], 0, 16)];
        
        long int baseValue = [temp longLongValue];
        
        long int errorInt = baseValue-cutNum;
        
        NSString *hexString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1lx",errorInt]];//错误基地址
        
        NSString *terminalCode = [NSString stringWithFormat:@"atos -arch armv7 -o %@ -l 0x%@ 0x%@",path,hexString,result];
        NSLog(@"%@",terminalCode);
        
        NSTask *task;
        task = [[NSTask alloc] init];
        [task setLaunchPath: @"/bin/bash"];
        
        NSArray *arguments;
        arguments = [NSArray arrayWithObjects:@"-c",terminalCode, nil];
        [task setArguments: arguments];
        
        NSPipe *pipe;
        pipe = [NSPipe pipe];
        [task setStandardOutput: pipe];
        
        NSFileHandle *file;
        file = [pipe fileHandleForReading];
        
        [task launch];
        
        NSData *data;
        data = [file readDataToEndOfFile];
        
        NSString *string;
        string = [[NSString alloc] initWithData: data
                                       encoding: NSUTF8StringEncoding];
        NSLog (@"%@", string);
    }
    return 0;
}
