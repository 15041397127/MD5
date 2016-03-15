//
//  NSString+MD5.h
//  MD5
//
//  Created by 杨修涛 on 16/2/22.
//  Copyright © 2016年 googosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

/**
 *  MD5 Encryption
 *
 *  @param input NSString Need MD5 Encryption
 *
 *  @return MD5String
 */
+ (NSString *)md5Encryption:(NSString *)input;  //md5加密


/**
 *  DES Encryption
 *
 *  @param input NSString Need DES Encryption
 *
 *  @param key NSString DES Encryption key
 *
 *  @return DES Encryption
 */
+ (NSString *)encryptWithText:(NSString *)input key:(NSString *)key vector:(NSString *)vector;//Base64(des)加密


/**
 *  DES Decryption
 *
 *  @param input NSString Need DES Decryption
 *
 *  @param key NSString DES Decryption key
 *
 *  @return DES Decryption
 */
+ (NSString *)decryptWithText:(NSString *)input key:(NSString *)key vector:(NSString *)vector;//Base64(des)解密




/**
 *  URL encoding on a input string
 *
 *  @param input A string(need encoding) input
 *
 *  @return A string after URL encoded
 */

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input; //对URL进行编码

/**
 *  URL decoding on a input string
 *
 *  @param input A string(need decoding) input
 *
 *  @return decoding String
 */

+ (NSString *)encodeToPercentEscapeString: (NSString *) input; //对URL进行解码

@end
