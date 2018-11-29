//
//  KSWXRichTextComponent.h
//
//
//  Created by HJaycee on 2018/6/13.S
//

#import <WeexSDK/WeexSDK.h>

/**
 开放给Weex的DOM方法：
 
 $refs.richtext.getTextLineInfo((res) => {
    const arg = JSON.parse(res)
    res.maxLine // 最大行数
    res.realLine // 实际行数
 })
 */

typedef NSString * KSWXRichTextStyleKey NS_EXTENSIBLE_STRING_ENUM;

// 超链接颜色
extern KSWXRichTextStyleKey const KSWXRichTextLinkTextColorKey;
// 超链接下划线颜色
extern KSWXRichTextStyleKey const KSWXRichTextLinkUnderlineColorKey;
// 默认FontFamily
extern KSWXRichTextStyleKey const KSWXRichTextDefaultFontFamilyKey;


@interface KSWXRichTextComponent : WXComponent

/**
 监听超链接的点击

 @param linkClick weex实例和链接回调
 */
+ (void)observeLinkClick:(void(^)(WXSDKInstance *weexInstance, NSURL *URL))linkClick;

/**
 部分默认样式的设置

 @param styles 样式
 */
+ (void)addDefaultStyles:(NSDictionary<KSWXRichTextStyleKey, id> *)styles;

@end
