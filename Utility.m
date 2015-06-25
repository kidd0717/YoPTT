//
//  Utility.m
//  telnet
//
//  Created by MITAKE on 2015/6/25.
//  Copyright (c) 2015年 mitake. All rights reserved.
//

#import "Utility.h"
#import "Encoding.h"

@implementation Utility

+ (NSString *)getStringFromTelnetData:(NSData *)data
{
    const uint8_t *bytes = [data bytes];
    
    int textLength = 0;
    unichar unicharBuf[4096];
    
    for (int i = 0; i < [data length] ; i++)
    {
        unichar ch = bytes[i];
        
        if(ch < 0x007f) // is ASCII
        {
            unicharBuf[textLength] = ch;
            textLength++;
        }
        else // is over ASCII (BIG5-AUO?)
        {
            unichar big5Char = (ch << 8) + bytes[i+1] ; // 把兩個bytes合併成一個
            unichar unicodeChar = B2U[big5Char - 0x8000]; // 查表把big5轉成unicode
            unicharBuf[textLength] = unicodeChar;
            textLength++;
            i++;
        }
    }
    
    NSString *s = [[NSString alloc]initWithCharacters:unicharBuf length:textLength];
    return s;
}
@end
