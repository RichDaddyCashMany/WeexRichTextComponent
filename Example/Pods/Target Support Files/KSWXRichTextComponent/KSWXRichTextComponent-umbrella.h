#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSCharacterSet+KSWXRichText.h"
#import "NSMutableAttributedString+KSWXRichText.h"
#import "NSObject+KSWXRichText.h"
#import "NSScanner+KSWXRichText.h"
#import "NSString+KSWXRichText.h"
#import "UIColor+KSWXRichText.h"
#import "UIImage+KSWXRichText.h"
#import "KSWXRichTextComponent.h"

FOUNDATION_EXPORT double KSWXRichTextComponentVersionNumber;
FOUNDATION_EXPORT const unsigned char KSWXRichTextComponentVersionString[];

