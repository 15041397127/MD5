//
//  NSString+MD5.m
//  MD5
//
//  Created by 杨修涛 on 16/2/22.
//  Copyright © 2016年 googosoft. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation NSString (MD5)


#pragma mark - MD5加密

/**
 *  MD5 Encription
 *
 *  @param input NSString
 *
 *  @return MD5 NSString
 */

+ (NSString *)md5Encryption:(NSString *)input{
    

    const char *cStr = [input UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
    NSString *md5String = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5String;
}


#pragma mark - DES 加密和解密

/**
 *  DES Encryption
 *
 *  @param input  need encrypt string
 *  @param key    encrypted key
 *  @param vector encrypted vector
 *
 *  @return enctypted string
 */

+ (NSString *)encryptWithText:(NSString *)input key:(NSString *)key vector:(NSString *)vector{
    //kCCEncrypt 加密
    return [self encrypt:input encryptOrDecrypt:kCCEncrypt key:key vector:vector];
}

/**
 *  DES Encryption
 *
 *  @param input  need decrypt string
 *  @param key    decrypted key
 *  @param vector decrypted vector
 *
 *  @return decrypted string
 */

+ (NSString *)decryptWithText:(NSString *)input key:(NSString *)key vector:(NSString *)vector{
    //kCCDecrypt 解密
    return [self encrypt:input encryptOrDecrypt:kCCDecrypt key:key vector:vector];
}


/**
 *  Des Encryption and Decryption
 *
 *  @param input            need encrypt or decrypt string
 *  @param encryptOperation encryptOperation description
 *  @param key              secret key
 *  @param vector           vector
 *
 *  @return encrypted or decrypted string
 */

+ (NSString *)encrypt:(NSString *)input encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key vector:(NSString *)vector{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[input dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [input dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    

    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [vector UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithm3DES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySize3DES,//   DES 密钥的大小（kCCKeySize3DES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {       
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    
    return result;
}


#pragma mark - 对Url进行编码和解码

/**
 *  URL encoding on a input string
 *
 *  @param input A string(need encoding) input
 *
 *  @return A string after URL encoded
 */

+ (NSString *)encodeToPercentEscapeString: (NSString *) input{
    
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)input, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    return outputStr;
}

/**
 *  URL decoding on a input string
 *
 *  @param input A string(need decoding) input
 *
 *  @return decoding String
 */

+ (NSString *)decodeFromPercentEscapeString: (NSString *)input{
    
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    
    [outputStr replaceOccurrencesOfString:@"+"  withString:@" " options:NSLiteralSearch  range:NSMakeRange(0,[outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
