//
// Created by Jiaxin.Li on 2/10/15.
// Copyright (c) 2015 Cunqi Xiao. All rights reserved.
//

#import "DocumentHelper.h"

@implementation DocumentHelper

+ (NSString *)getHomeDirectory {
    return NSHomeDirectory();
}

+ (NSString *)getDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

+ (NSString *)getCacheDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths[0];
}

+ (NSString *)getTempPathDirectory {
    return NSTemporaryDirectory();
}

+ (NSString *)createDirectoryByName:(NSString *)name parentDir:(NSString *)parent {
    NSString *filePath = [parent stringByAppendingPathComponent:name];
    
    return filePath;
}

+ (BOOL)createDirectoryAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir = TRUE;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        return NO;
    }

    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];

    return YES;
}

+ (BOOL)saveFileAtPath:(NSData *)data filePath:(NSString *)path {
    return [data writeToFile:path atomically:YES];
}

+ (BOOL)saveFileByName:(NSData *)data fileName:(NSString *)name parentDir:(NSString *)parent {
    NSString *filePath = [parent stringByAppendingPathComponent:name];

    return [data writeToFile:filePath atomically:YES];
}

+ (BOOL)deleteDirectoryAtPath:(NSString *)path withCasecade:(BOOL)withCasecade {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    if (error == nil) {
        for (NSString *name in contents) {
            NSString *fullPath = [path stringByAppendingPathComponent:name];
            NSLog(@"%@", fullPath);
            BOOL removeSuccess = [fileManager removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
                return NO;
            }
        }
        
        [fileManager removeItemAtPath:path error:&error];
        return YES;
    }else {
        NSLog(@"%@", error);
        return NO;
    }
    
    
}

+ (BOOL)deleteFileAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = [[NSError alloc] init];
    return [fileManager removeItemAtPath:path error:&error];
}

+ (NSString *)getFilePathWithName:(NSString *)name atRootDirectory:(NSString *)from {
    return [from stringByAppendingPathComponent:name];
}

+ (NSData *)readFileAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager contentsAtPath:path];
}

+ (NSString *)forwardToSubPath:(NSString *)path subPath:(NSString *)subPath {
    return [path stringByAppendingPathComponent:subPath];
}

+ (NSString *)backToParentPath:(NSString *)path {
    return path.stringByDeletingLastPathComponent;
}

+ (BOOL)removeFileAtPath:(NSString *) path {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return [manager removeItemAtPath:path error:nil];
}

@end