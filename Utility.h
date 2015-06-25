//
//  Utility.h
//  telnet
//
//  Created by MITAKE on 2015/6/25.
//  Copyright (c) 2015年 mitake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (NSString *)getStringFromTelnetData:(NSData *)data;

@end
