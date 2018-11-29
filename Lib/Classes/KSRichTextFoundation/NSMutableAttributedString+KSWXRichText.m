//
//  NSMutableAttributedString+KSWXRichText.m
//
//
//  Created by HJaycee on 2018/11/2.

//

#import "NSMutableAttributedString+KSWXRichText.h"

@implementation NSMutableAttributedString (KSWXRichText)

+ (instancetype)attributedStringOfImage:(UIImage *)image lineHeight:(CGFloat)lineHeight descender:(CGFloat)descender {
    
    NSTextAttachment *attachment = [NSTextAttachment new];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, descender, image.size.width, image.size.height);
    
    NSMutableAttributedString *imageAttrString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    
    style.minimumLineHeight = lineHeight;
    style.maximumLineHeight = lineHeight;
    
    [imageAttrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [imageAttrString length])];
    
    [imageAttrString addAttribute:NSBaselineOffsetAttributeName value:@((lineHeight - image.size.height) / 2.0) range:NSMakeRange(0, imageAttrString.length)];
    
    return imageAttrString;
}

@end
