//
//  NSMutableAttributedString+KSWXRichText.h
//  kaiStart
//
//  Created by HJaycee on 2018/11/2.
//  Copyright © 2018 KaiShiZhongChou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (KSWXRichText)

+ (instancetype)attributedStringOfImage:(UIImage *)image lineHeight:(CGFloat)lineHeight descender:(CGFloat)descender;

@end

NS_ASSUME_NONNULL_END
