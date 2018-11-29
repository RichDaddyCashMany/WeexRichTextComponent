//
//  UIColor+KSWXRichText.h
//  kaiStart
//
//  Created by HJaycee on 2018/11/2.
//  Copyright © 2018 KaiShiZhongChou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIColor *UIColorCreateWithHTMLName(NSString *name);
UIColor *UIColorCreateWithHexString(NSString *hexString);

@interface UIColor (KSWXRichText)

@end

NS_ASSUME_NONNULL_END
