//
//  NSString+KSWXRichText.m
//
//
//  Created by HJaycee on 2018/11/2.

//

#import "NSString+KSWXRichText.h"
#import "NSScanner+KSWXRichText.h"

#define UNUSE_CSS @"background-color:black;"
NSString *const RICH_TAG_IDENTIFIER = @"RICH_TAG:";

@implementation NSString (KSWXRichText)

- (CGRect)rectWithFont:(UIFont *)font {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    return [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL];
}

- (NSString *)mostStringWithFont:(UIFont *)font canShowInWidth:(CGFloat)width realWidth:(CGFloat *)realWidth ellipsis:(BOOL)ellipsis {
    CGRect textRect = [self rectWithFont:font];
    NSString *mostText = self;
    if (textRect.size.width > width) {
        for (NSUInteger i = self.length; i>0; i--) {
            NSString *try = [self substringToIndex:i];
            CGFloat _realWidth = [try rectWithFont:font].size.width;
            if (_realWidth <= width) {
                if (realWidth) {
                    *realWidth = _realWidth;
                }
                mostText = try;
                break;
            }
        }
    } else {
        if (realWidth) {
            *realWidth = textRect.size.width;
        }
    }
    if (*realWidth < width &&
        mostText.length != self.length &&
        ellipsis) {
        mostText = [[mostText substringToIndex:mostText.length - 1] stringByAppendingString:@"..."];
    }
    return mostText;
}

- (NSDictionary *)dictionaryOfCSSStyles {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    NSString *name = nil;
    NSString *value = nil;
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
    
    @autoreleasepool
    {
        while ([scanner _scanCSSAttribute:&name value:&value])
        {
            [tmpDict setObject:value forKey:name];
        }
    }
    
    return tmpDict;
}

- (NSString *)endcodedsStylesString {
    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

- (NSString *)decodedStylesString {
    NSString *encodedString = self;
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+ (NSString *)convertToRichHTMLWithString:(NSString *)string {
    NSRange range = [string rangeOfString:@"<\\w+[^>]*border[^>]*>.*?<\\/\\w+>" options:NSRegularExpressionSearch];
    
    if (range.location == NSNotFound) {
        return string;
    }
    
    NSString *tag = [string substringWithRange:range];
    
    NSString *style = ({
        NSRange styleRange = [tag rangeOfString:@"(?<=style=)[^>]*" options:NSRegularExpressionSearch];
        NSString *style = [tag substringWithRange:styleRange];
        style = [style substringWithRange:NSMakeRange(1, style.length - 2)];
        style;
    });
    
    NSDictionary *originalStyles = [style dictionaryOfCSSStyles];
    NSMutableDictionary *styles = [NSMutableDictionary dictionary];
    
    NSString *shortHand = [originalStyles objectForKey:@"font-size"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        [styles setObject:shortHand forKey:@"font-size"];
    }
    
    shortHand = [originalStyles objectForKey:@"font-family"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        [styles setObject:shortHand forKey:@"font-family"];
    }
    
    shortHand = [originalStyles objectForKey:@"color"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        [styles setObject:shortHand forKey:@"color"];
    }
    
    shortHand = [originalStyles objectForKey:@"background-color"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        [styles setObject:shortHand forKey:@"background-color"];
    }
    
    shortHand = [originalStyles objectForKey:@"border-radius"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        [styles setObject:shortHand forKey:@"border-radius"];
    }
    
    shortHand = [originalStyles objectForKey:@"border-width"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        [styles setObject:shortHand forKey:@"border-width"];
    }
    
    shortHand = [originalStyles objectForKey:@"border-color"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        [styles setObject:shortHand forKey:@"border-color"];
    }
    
    shortHand = [originalStyles objectForKey:@"text-overflow"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        [styles setObject:shortHand forKey:@"text-overflow"];
    }
    
    shortHand = [originalStyles objectForKey:@"text-align"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        [styles setObject:shortHand forKey:@"text-align"];
    }
    
    shortHand = [originalStyles objectForKey:@"width"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        [styles setObject:shortHand forKey:@"width"];
    }
    
    shortHand = [originalStyles objectForKey:@"height"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        [styles setObject:shortHand forKey:@"height"];
    }
    
    shortHand = [originalStyles objectForKey:@"line-height"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        [styles setObject:shortHand forKey:@"line-height"];
    }
    
    shortHand = [originalStyles objectForKey:@"margin"];
    
    NSString *topMargin;
    NSString *rightMargin;
    NSString *bottomMargin;
    NSString *leftMargin;
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        NSArray *parts = [shortHand componentsSeparatedByString:@" "];
        
        if ([parts count] == 4) {
            topMargin = [parts objectAtIndex:0];
            rightMargin = [parts objectAtIndex:1];
            bottomMargin = [parts objectAtIndex:2];
            leftMargin = [parts objectAtIndex:3];
        } else if ([parts count] == 3) {
            topMargin = [parts objectAtIndex:0];
            rightMargin = [parts objectAtIndex:1];
            bottomMargin = [parts objectAtIndex:2];
            leftMargin = [parts objectAtIndex:1];
        } else if ([parts count] == 2) {
            topMargin = [parts objectAtIndex:0];
            rightMargin = [parts objectAtIndex:1];
            bottomMargin = [parts objectAtIndex:0];
            leftMargin = [parts objectAtIndex:1];
        } else {
            NSString *onlyValue = [parts objectAtIndex:0];
            
            topMargin = onlyValue;
            rightMargin = onlyValue;
            bottomMargin = onlyValue;
            leftMargin = onlyValue;
        }
    }
    
    if ([originalStyles objectForKey:@"margin-top"]) {
        [styles setObject:[originalStyles objectForKey:@"margin-top"] forKey:@"margin-top"];
    } else if (topMargin) {
        [styles setObject:topMargin forKey:@"margin-top"];
    }
    
    if ([originalStyles objectForKey:@"margin-right"]) {
        [styles setObject:[originalStyles objectForKey:@"margin-right"] forKey:@"margin-right"];
    } else if (rightMargin) {
        [styles setObject:rightMargin forKey:@"margin-right"];
    }
    
    if ([originalStyles objectForKey:@"margin-bottom"]) {
        [styles setObject:[originalStyles objectForKey:@"margin-bottom"] forKey:@"margin-bottom"];
    } else if (bottomMargin) {
        [styles setObject:bottomMargin forKey:@"margin-bottom"];
    }
    
    if ([originalStyles objectForKey:@"margin-left"]) {
        [styles setObject:[originalStyles objectForKey:@"margin-left"] forKey:@"margin-left"];
    } else if (leftMargin) {
        [styles setObject:leftMargin forKey:@"margin-left"];
    }
    
    shortHand = [originalStyles objectForKey:@"padding"];
    
    NSString *topPadding;
    NSString *rightPadding;
    NSString *bottomPadding;
    NSString *leftPadding;
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        NSArray *parts = [shortHand componentsSeparatedByString:@" "];
        
        if ([parts count] == 4) {
            topPadding = [parts objectAtIndex:0];
            rightPadding = [parts objectAtIndex:1];
            bottomPadding = [parts objectAtIndex:2];
            leftPadding = [parts objectAtIndex:3];
        } else if ([parts count] == 3) {
            topPadding = [parts objectAtIndex:0];
            rightPadding = [parts objectAtIndex:1];
            bottomPadding = [parts objectAtIndex:2];
            leftPadding = [parts objectAtIndex:1];
        } else if ([parts count] == 2) {
            topPadding = [parts objectAtIndex:0];
            rightPadding = [parts objectAtIndex:1];
            bottomPadding = [parts objectAtIndex:0];
            leftPadding = [parts objectAtIndex:1];
        } else {
            NSString *onlyValue = [parts objectAtIndex:0];
            
            topPadding = onlyValue;
            rightPadding = onlyValue;
            bottomPadding = onlyValue;
            leftPadding = onlyValue;
        }
    }
    
    if ([originalStyles objectForKey:@"padding-top"]) {
        [styles setObject:[originalStyles objectForKey:@"padding-top"] forKey:@"padding-top"];
    } else if (topPadding) {
        [styles setObject:topPadding forKey:@"padding-top"];
    }
    
    if ([originalStyles objectForKey:@"padding-right"]) {
        [styles setObject:[originalStyles objectForKey:@"padding-right"] forKey:@"padding-right"];
    } else if (rightPadding) {
        [styles setObject:rightPadding forKey:@"padding-right"];
    }
    
    if ([originalStyles objectForKey:@"padding-bottom"]) {
        [styles setObject:[originalStyles objectForKey:@"padding-bottom"] forKey:@"padding-bottom"];
    } else if (bottomPadding) {
        [styles setObject:bottomPadding forKey:@"padding-bottom"];
    }
    
    if ([originalStyles objectForKey:@"padding-left"]) {
        [styles setObject:[originalStyles objectForKey:@"padding-left"] forKey:@"padding-left"];
    } else if (leftPadding) {
        [styles setObject:leftPadding forKey:@"padding-left"];
    }
    
    shortHand = [originalStyles objectForKey:@"background-color"];
    
    if (shortHand && [shortHand isKindOfClass:[NSString class]]) {
        NSString *color = [shortHand stringByReplacingOccurrencesOfString:@" " withString:@""];
        [styles setObject:@[color, color] forKey:@"gradient-colors"];
    }
    
    shortHand = [originalStyles objectForKey:@"background-image"];
    
    if (shortHand &&
        [shortHand isKindOfClass:[NSString class]] &&
        [shortHand containsString:@"linear-gradient"]) {
        
        NSArray *parts = [shortHand componentsSeparatedByString:@","];
        
        if (parts.count > 0) {
            NSArray *direction = [[parts firstObject] componentsSeparatedByString:@" "];
            [styles setObject:direction[direction.count - 1] forKey:@"gradient-to"];
            
            NSMutableArray *colors = [NSMutableArray arrayWithCapacity:parts.count - 1];
            for (int i = 1; i<parts.count; i++) {
                NSString *color = [parts[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
                color = [color stringByReplacingOccurrencesOfString:@")" withString:@""];
                [colors addObject:color];
            }
            [styles setObject:colors forKey:@"gradient-colors"];
        }
    }
    
    NSRange tagBeginRange = [tag rangeOfString:@"<.+?>" options:NSRegularExpressionSearch];
    NSRange tagEndRange = [tag rangeOfString:@"</"];
    NSString *valueString = [tag substringWithRange:NSMakeRange(tagBeginRange.location + tagBeginRange.length, tagEndRange.location - tagBeginRange.location - tagBeginRange.length)];
    
    NSString *tagName = [tag substringWithRange:NSMakeRange(tagEndRange.location + 2, tag.length - tagEndRange.location - 3)];
    
    [styles setObject:valueString forKey:@"text"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:styles options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *json = [NSString stringWithFormat:@"%@%@", RICH_TAG_IDENTIFIER, [jsonString endcodedsStylesString]];
    
    NSString *newTag = [NSString stringWithFormat:@"<%@ style='%@'>%@</%@>", tagName, UNUSE_CSS, json, tagName];
    
    NSString *newHtml = [string stringByReplacingOccurrencesOfString:tag withString:newTag];
    
    return [self convertToRichHTMLWithString:newHtml];
}

@end
