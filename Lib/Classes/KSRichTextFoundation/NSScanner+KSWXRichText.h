//
//  NSScanner+KSWXRichText.h
//
//
//  Created by HJaycee on 2018/11/2.

//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSScanner (KSWXRichText)

- (BOOL)_scanCSSAttribute:(NSString * __autoreleasing*)name value:(id __autoreleasing*)value;

@end

NS_ASSUME_NONNULL_END
