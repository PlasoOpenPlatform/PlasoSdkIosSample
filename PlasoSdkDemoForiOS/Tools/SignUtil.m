//
//  SignUtil.m
//  PlasoStyleUpimeDemo
//
//  Created by 袁鑫 on 2020/10/31.
//

#import "SignUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation SignUtil

+ (NSString *)calBase64Sha1WithData:(NSString *)string withSecret:(NSString *)key {
    NSData *secretData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t input[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], input);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", input[i]];
    }
    return [result uppercaseString];
}

@end
