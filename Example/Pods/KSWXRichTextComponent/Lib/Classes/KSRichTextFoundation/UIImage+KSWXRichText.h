//
//  UIImage+KSWXRichText.h
//  kaiStart
//
//  Created by HJaycee on 2018/11/2.
//  Copyright © 2018 KaiShiZhongChou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 渐变方向
typedef enum : NSUInteger {
    KSWXRichTextGradientDirectionLeftRight,
    KSWXRichTextGradientDirectionRightLeft,
    KSWXRichTextGradientDirectionTopBottom,
    KSWXRichTextGradientDirectionBottomTop
} KSWXRichTextGradientDirection;

// 文字水平对齐方式
typedef enum : NSUInteger {
    KSWXRichTextTextAlignLeft,
    KSWXRichTextTextAlignCenter,
    KSWXRichTextTextAlignRight,
} KSWXRichTextTextAlign;

// 文字裁剪模式
typedef enum : NSUInteger {
    KSWXRichTextLineBreakByClipping,        // Simply clip
    KSWXRichTextLineBreakByTruncatingTail,  // Truncate at tail of line: "abcd..."
} KSWXRichTextLineBreakMode;

@interface UIImage (KSWXRichText)

/**
 创建一个支持圆角、边框、渐变色的图片
 */
+ (UIImage *)createTagImageWithText:(NSString *)text
                               font:(UIFont *)font
                              color:(UIColor *)color
                              width:(CGFloat)width
                             height:(CGFloat)height
                         lineHeight:(CGFloat)lineHeight
                            padding:(UIEdgeInsets)padding
                             margin:(UIEdgeInsets)margin
                  gradientDirection:(KSWXRichTextGradientDirection)gradientDirection
                   backgroundColors:(NSArray *)backgroundColors
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor
                       cornerRadius:(CGFloat)cornerRadius
                          textAlign:(KSWXRichTextTextAlign)textAlign
                      lineBreakMode:(KSWXRichTextLineBreakMode)lineBreakMode;

+ (UIImage *)createTagImageWithStyles:(NSDictionary *)styles;

@end

NS_ASSUME_NONNULL_END
