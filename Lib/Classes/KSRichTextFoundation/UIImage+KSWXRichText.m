//
//  UIImage+KSWXRichText.m
//
//
//  Created by HJaycee on 2018/11/2.

//

#import "UIImage+KSWXRichText.h"
#import "NSString+KSWXRichText.h"
#import <WeexSDK/WeexSDK.h>
#import "UIColor+KSWXRichText.h"

@implementation UIImage (KSWXRichText)

+ (UIImage *)createTagImageWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color width:(CGFloat)width height:(CGFloat)height lineHeight:(CGFloat)lineHeight padding:(UIEdgeInsets)padding margin:(UIEdgeInsets)margin gradientDirection:(KSWXRichTextGradientDirection)gradientDirection backgroundColors:(NSArray *)backgroundColors borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius textAlign:(KSWXRichTextTextAlign)textAlign lineBreakMode:(KSWXRichTextLineBreakMode)lineBreakMode {
    
    // 文字大小
    CGRect textRect = [text rectWithFont:font];
    
    CGFloat canvasWidth;
    if (width != NSNotFound) {
        canvasWidth = width + padding.left + padding.right + borderWidth * 2 + margin.left + margin.right;
    } else {
        canvasWidth = textRect.size.width + padding.left + padding.right + borderWidth * 2 + margin.left + margin.right;
    }
    
    CGFloat canvasHeight;
    if (height != NSNotFound) {
        canvasHeight = height + padding.top + padding.bottom + borderWidth * 2 + margin.top + margin.bottom;
    } else if (lineHeight != NSNotFound) {
        canvasHeight = lineHeight + padding.top + padding.bottom + borderWidth * 2 + margin.top + margin.bottom;
    } else {
        canvasHeight = textRect.size.height + padding.top + padding.bottom + borderWidth * 2 + margin.top + margin.bottom;
    }
    
    // 画布大小
    CGSize canvasSize = CGSizeMake(canvasWidth, canvasHeight);
    
    // 边框
    CGRect borderRect = CGRectMake(margin.left, margin.top, canvasWidth - margin.left - margin.right, canvasHeight - margin.top - margin.bottom);
    
    // 背景
    CGRect backgroundRect = CGRectMake(borderRect.origin.x + borderWidth, borderRect.origin.y + borderWidth, borderRect.size.width - borderWidth * 2, borderRect.size.height - borderWidth * 2);
    
    UIImage *_image;
    
    {
        UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0);
        
        UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, canvasSize.width, canvasSize.height)];
        [[UIColor clearColor] setFill];
        [path fill];
        
    }
    
    // border
    {
        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:borderRect cornerRadius:cornerRadius];
        [borderColor setFill];
        [path fill];
    }
    
    // 背景
    {
        NSMutableArray *arr = [NSMutableArray array];
        for (UIColor *c in backgroundColors) {
            [arr addObject:(id)c.CGColor];
        }
        if (arr.count == 1) {
            [arr addObject:[arr firstObject]];
        }
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:backgroundRect cornerRadius:cornerRadius];
        CGContextAddPath(context, path.CGPath);
        CGContextClip(context);
        
        CGContextSaveGState(context);
        CGColorSpaceRef colorSpace = CGColorGetColorSpace([[backgroundColors lastObject] CGColor]);
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)arr, NULL);
        CGPoint start;
        CGPoint end;
        
        switch (gradientDirection) {
            case KSWXRichTextGradientDirectionLeftRight:
                start = backgroundRect.origin;
                end = CGPointMake(backgroundRect.origin.x + backgroundRect.size.width, backgroundRect.origin.y);
                break;
            case KSWXRichTextGradientDirectionRightLeft:
                start = CGPointMake(backgroundRect.origin.x + backgroundRect.size.width, backgroundRect.origin.y);
                end = CGPointMake(margin.left, margin.top);
                break;
            case KSWXRichTextGradientDirectionTopBottom:
                start = backgroundRect.origin;
                end = CGPointMake(backgroundRect.origin.x, backgroundRect.origin.y + backgroundRect.size.height);
                break;
            case KSWXRichTextGradientDirectionBottomTop:
                start = CGPointMake(backgroundRect.origin.x, backgroundRect.origin.y + backgroundRect.size.height);
                end = backgroundRect.origin;
                break;
        }
        
        CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        
        CGFloat containerWidth = backgroundRect.size.width - padding.left - padding.right;
        CGFloat textX = backgroundRect.origin.x + padding.left;
        CGFloat realWidth = .0;
        NSString *mostText = [text mostStringWithFont:font canShowInWidth:containerWidth realWidth:&realWidth ellipsis:lineBreakMode == KSWXRichTextLineBreakByTruncatingTail];
        
        if (realWidth < containerWidth) {
            if (textAlign == KSWXRichTextTextAlignRight) {
                textX = textX + containerWidth - realWidth;
            } else if (textAlign == KSWXRichTextTextAlignCenter) {
                textX = textX + (containerWidth - realWidth) / 2.0;
            }
        }
        
        CGFloat textY = backgroundRect.origin.y + padding.top + (lineHeight - textRect.size.height) / 2.0;
        
        [mostText drawAtPoint:CGPointMake(textX, textY) withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: color}];
        
        _image = UIGraphicsGetImageFromCurrentImageContext();
        CGGradientRelease(gradient);
        CGContextRestoreGState(context);
        CGColorSpaceRelease(colorSpace);
        UIGraphicsEndImageContext();
    }
    
    return _image;
}

+ (UIImage *)createTagImageWithStyles:(NSDictionary *)styles {
    CGFloat scaleFactor = [WXSDKInstance new].pixelScaleFactor;
    
    NSString *text = styles[@"text"] ? : @"";
    
    CGFloat fontSize = styles[@"font-size"] ? [WXConvert WXPixelType:styles[@"font-size"] scaleFactor:scaleFactor] : 12;
    
    CGFloat lineHeight = styles[@"line-height"] ? [WXConvert WXPixelType:styles[@"line-height"] scaleFactor:scaleFactor] : fontSize;
    
    UIFont *font = styles[@"font-family"] ? [UIFont fontWithName:styles[@"font-family"] size:fontSize] : [UIFont systemFontOfSize:fontSize];
    
    UIColor *color = styles[@"color"] ? UIColorCreateWithHTMLName(styles[@"color"]) : [UIColor blackColor];
    
    UIEdgeInsets padding = ({
        CGFloat paddingTop = 0;
        CGFloat paddingLeft = 0;
        CGFloat paddingBottom = 0;
        CGFloat paddingRight = 0;
        if (styles[@"padding-top"]) {
            paddingTop = [WXConvert WXPixelType:styles[@"padding-top"] scaleFactor:scaleFactor];
        }
        if (styles[@"padding-left"]) {
            paddingLeft = [WXConvert WXPixelType:styles[@"padding-left"] scaleFactor:scaleFactor];
        }
        if (styles[@"padding-bottom"]) {
            paddingBottom = [WXConvert WXPixelType:styles[@"padding-bottom"] scaleFactor:scaleFactor];
        }
        if (styles[@"padding-right"]) {
            paddingRight = [WXConvert WXPixelType:styles[@"padding-right"] scaleFactor:scaleFactor];
        }
        
        UIEdgeInsetsMake(paddingTop, paddingLeft, paddingBottom, paddingRight);
    });
    
    UIEdgeInsets margin = ({
        CGFloat marginTop = 0;
        CGFloat marginLeft = 0;
        CGFloat marginBottom = 0;
        CGFloat marginRight = 0;
        if (styles[@"margin-top"]) {
            marginTop = [WXConvert WXPixelType:styles[@"margin-top"] scaleFactor:scaleFactor];
        }
        if (styles[@"margin-left"]) {
            marginLeft = [WXConvert WXPixelType:styles[@"margin-left"] scaleFactor:scaleFactor];
        }
        if (styles[@"margin-bottom"]) {
            marginBottom = [WXConvert WXPixelType:styles[@"margin-bottom"] scaleFactor:scaleFactor];
        }
        if (styles[@"margin-right"]) {
            marginRight = [WXConvert WXPixelType:styles[@"margin-right"] scaleFactor:scaleFactor];
        }
        
        UIEdgeInsetsMake(marginTop, marginLeft, marginBottom, marginRight);
    });
    
    NSArray *backgroundColors = ({
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *colorString in styles[@"gradient-colors"]) {
            [arr addObject:UIColorCreateWithHTMLName(colorString)];
        }
        arr;
    });
    
    KSWXRichTextGradientDirection gradientDirection = ({
        KSWXRichTextGradientDirection direction;
        if ([styles[@"gradient-to"] isEqualToString:@"right"]) {
            direction = KSWXRichTextGradientDirectionLeftRight;
        } else if ([styles[@"gradient-to"] isEqualToString:@"left"]) {
            direction = KSWXRichTextGradientDirectionRightLeft;
        } else if ([styles[@"gradient-to"] isEqualToString:@"top"]) {
            direction = KSWXRichTextGradientDirectionBottomTop;
        } else {
            direction = KSWXRichTextGradientDirectionTopBottom;
        }
        direction;
    });
    
    CGFloat cornerRadius = styles[@"border-radius"] ? [WXConvert WXPixelType:styles[@"border-radius"] scaleFactor:scaleFactor] : 0;
    
    CGFloat width = styles[@"width"] ? [WXConvert WXPixelType:styles[@"width"] scaleFactor:scaleFactor] : NSNotFound;
    
    CGFloat height = styles[@"height"] ? [WXConvert WXPixelType:styles[@"height"] scaleFactor:scaleFactor] : NSNotFound;
    
    CGFloat borderWidth = styles[@"border-width"] ? [WXConvert WXPixelType:styles[@"border-width"] scaleFactor:scaleFactor] : 0;
    
    UIColor *borderColor = styles[@"border-color"] ? UIColorCreateWithHTMLName(styles[@"border-color"]) : [UIColor clearColor];
    
    KSWXRichTextTextAlign textAlign = ({
        KSWXRichTextTextAlign textAlign = KSWXRichTextTextAlignLeft;
        if ([styles[@"text-align"] isEqualToString:@"right"]) {
            textAlign = KSWXRichTextTextAlignRight;
        } else if ([styles[@"text-align"] isEqualToString:@"center"]) {
            textAlign = KSWXRichTextTextAlignCenter;
        }
        textAlign;
    });
    
    KSWXRichTextLineBreakMode lineBreakMode = ({
        KSWXRichTextLineBreakMode lineBreakMode = KSWXRichTextLineBreakByClipping;
        if ([styles[@"text-overflow"] isEqualToString:@"ellipsis"]) {
            lineBreakMode = KSWXRichTextLineBreakByTruncatingTail;
        }
        lineBreakMode;
    });
    
    UIImage *image = [UIImage createTagImageWithText:text
                               font:font
                              color:color
                              width:width
                             height:height
                         lineHeight:lineHeight
                            padding:padding
                             margin:margin
                  gradientDirection:gradientDirection
                   backgroundColors:backgroundColors
                        borderWidth:borderWidth
                        borderColor:borderColor
                       cornerRadius:cornerRadius
                          textAlign:textAlign
                      lineBreakMode:lineBreakMode];
    
    return image;
}

@end
