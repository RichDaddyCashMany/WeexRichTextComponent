//
//  NSCharacterSet+KSWXRichText.h
//
//
//  Created by HJaycee on 2018/11/2.

//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCharacterSet (KSWXRichText)

+ (NSCharacterSet *)quoteCharacterSet;
+ (NSCharacterSet *)cssStyleAttributeNameCharacterSet;

@end

NS_ASSUME_NONNULL_END
