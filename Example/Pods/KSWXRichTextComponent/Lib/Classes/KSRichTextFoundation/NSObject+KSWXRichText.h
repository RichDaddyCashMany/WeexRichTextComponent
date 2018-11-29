//
//  NSObject+KSWXRichText.h
//  kaiStart
//
//  Created by HJaycee on 2018/11/9.
//  Copyright © 2018 KaiShiZhongChou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (KSWXJSON)

- (NSString *)jsonString;

@end

@interface NSString (KSWXJSON)

- (NSDictionary *)jsonObject;

@end

NS_ASSUME_NONNULL_END
