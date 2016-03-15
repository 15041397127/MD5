//
//  ViewController.m
//  MD5
//
//  Created by 杨修涛 on 16/2/22.
//  Copyright © 2016年 googosoft. All rights reserved.
//

#import "PLBViewController.h"
#import "NSString+MD5.h"

@interface PLBViewController ()

@end

@implementation PLBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //md5加密
    
//    MAC=MD5(MERCHANTID=WQLJ37100000001BRANCHID=371000000MER_CHANNEL=1DATE=20150817TIME=151430+双方协定的保密字符串，例如保密字符串为12345，则加密串为MERCHANTID=WQLJ37100000001BRANCHID=371000000MER_CHANNEL=0DATE=20150817TIME=15143012345
    NSString *MAC =[NSString md5Encryption:@"MERCHANTID=WQLJ37100000001BRANCHID=371000000MER_CHANNEL=0DATE=20150817TIME=15143012345"];
    
    NSLog(@"mac  ===  %@",MAC);
    
    //example1
    NSString *encrypt = [NSString encryptWithText:@"1111" key:@"EBSEBSEBSEBSEBSEBSEBSEBS" vector:@"31313131"];
    
    NSLog(@"encrypt code string === %@",encrypt);
    
    NSString *encryptURLcode = [self encodeToPercentEscapeString:encrypt];
    
    NSLog(@"encrypt URL code === %@",encryptURLcode);
    
    NSString *decodeURL = [self decodeFromPercentEscapeString:encryptURLcode];
    
   
    
    NSString *decrypt = [NSString decryptWithText:decodeURL key:@"EBSEBSEBSEBSEBSEBSEBSEBS" vector:@"31313131"];
    
     NSLog(@"decrypt code string === %@",decrypt);
    
    
    //example2
    NSString *encrypt2 = [NSString encryptWithText:@"1111+2222:!2222+3333:!4444" key:@"EBSEBSEBSEBSEBSEBSEBSEBS" vector:@"31313131"];
    
    NSLog(@"encrypt2 code string === %@",encrypt2);
    
    NSString *encryptURLcode2 = [self encodeToPercentEscapeString:encrypt2];
    
    NSLog(@"encrypt2 URL code === %@",encryptURLcode2);
    
    NSString *decodeURL2 = [self decodeFromPercentEscapeString:encryptURLcode2];
    
    NSLog(@"decrypt2 URL code ====  %@",decodeURL2);
    
    NSString *decrypt2 = [NSString decryptWithText:decodeURL2 key:@"EBSEBSEBSEBSEBSEBSEBSEBS" vector:@"31313131"];
    
    NSLog(@"decrypt2 code string === %@",decrypt2);
    

}


- (NSString *)encodeToPercentEscapeString: (NSString *) input{
    
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)input, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);

    return outputStr;
}


- (NSString *)decodeFromPercentEscapeString: (NSString *) input{
    
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    
    [outputStr replaceOccurrencesOfString:@"+"  withString:@" " options:NSLiteralSearch  range:NSMakeRange(0,[outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
