//
//  SignUtil.h
//  PlasoStyleUpimeDemo
//
//  Created by 袁鑫 on 2020/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignUtil : NSObject

+ (NSString *)calBase64Sha1WithData:(NSString *)string withSecret:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
