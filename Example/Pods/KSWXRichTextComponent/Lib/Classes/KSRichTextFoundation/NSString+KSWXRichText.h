//
//  NSString+KSWXRichText.h
//  kaiStart
//
//  Created by HJaycee on 2018/11/2.
//  Copyright © 2018 KaiShiZhongChou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const RICH_TAG_IDENTIFIER;

@interface NSString (KSWXRichText)

+ (NSString *)convertToRichHTMLWithString:(NSString *)string;

- (CGRect)rectWithFont:(UIFont *)font;
- (NSString *)mostStringWithFont:(UIFont *)font canShowInWidth:(CGFloat)width realWidth:(CGFloat *)realWidth ellipsis:(BOOL)ellipsis;

- (NSString *)endcodedsStylesString;
- (NSString *)decodedStylesString;

@end

NS_ASSUME_NONNULL_END
