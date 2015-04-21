//
// Created by Jiaxin.Li on 2/10/15.
// Copyright (c) 2015 Cunqi Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DocumentHelper : NSObject

+ (NSString *)getHomeDirectory;

+ (NSString *)getDocumentDirectory;

+ (NSString *)getCacheDirectory;

+ (NSString *)getTempPathDirectory;

+ (NSString *) createDirectoryByName:(NSString *) name parentDir:(NSString *) parent;
+ (BOOL) createDirectoryAtPath:(NSString *) path;

+ (BOOL) saveFileByName:(NSData *) data fileName:(NSString *) name parentDir:(NSString *) parent;
+ (BOOL) saveFileAtPath:(NSData *) data filePath:(NSString *) path;

+ (BOOL) deleteFileAtPath:(NSString *) path;

+ (BOOL) deleteDirectoryAtPath:(NSString *) path withCasecade:(BOOL) withCasecade;

+ (NSString *) getFilePathWithName:(NSString *)name atRootDirectory:(NSString *)from;

+ (NSData *) readFileAtPath:(NSString *) path;

+ (NSString *) backToParentPath:(NSString *) path;

+ (NSString *) forwardToSubPath:(NSString *) path subPath:(NSString *) subPath;

+ (BOOL)removeFileAtPath:(NSString *) path;

@end