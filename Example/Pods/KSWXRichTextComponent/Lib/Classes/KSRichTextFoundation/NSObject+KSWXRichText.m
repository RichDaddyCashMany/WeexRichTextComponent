//
//  NSObject+KSWXRichText.m
//  kaiStart
//
//  Created by HJaycee on 2018/11/9.
//  Copyright © 2018 KaiShiZhongChou. All rights reserved.
//

#import "NSObject+KSWXRichText.h"

@implementation NSDictionary (KSWXJSON)

- (NSString *)jsonString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end

@implementation NSString (KSWXJSON)

- (NSDictionary *)jsonObject {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if (error) {
        return nil;
    }
    return dic;
}

@end
