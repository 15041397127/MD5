//
//  NSURL+MD5.m
//  MD5
//
//  Created by 杨修涛 on 16/2/22.
//  Copyright © 2016年 googosoft. All rights reserved.
//

#import "NSURL+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSURL (MD5)

- (NSString *)md5{
  
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    NSData *data = [self.absoluteString dataUsingEncoding:NSUTF8StringEncoding];
    CC_MD5_Update(&md5, data.bytes, (CC_LONG)data.length);
    unsigned char digest [CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",digest[0],digest[1],digest[2],digest[3],digest[4],digest[5],digest[6],digest[7],digest[8],digest[9],digest[10],digest[11],digest[12],digest[13],digest[14],digest[15]];
    
    return md5String;
}

@end
