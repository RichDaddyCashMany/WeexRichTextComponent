//
//  KSWXRichTextComponent.m
//
//
//  Created by HJaycee on 2018/6/13.
//

#import "KSWXRichTextComponent.h"
#import <CoreText/CoreText.h>
#import "WXSDKInstance_private.h"
#import "UIColor+KSWXRichText.h"
#import "NSString+KSWXRichText.h"
#import "UIImage+KSWXRichText.h"
#import "NSMutableAttributedString+KSWXRichText.h"
#import "NSObject+KSWXRichText.h"

KSWXRichTextStyleKey const KSWXRichTextLinkTextColorKey = @"KSWXRichTextLinkTextColorKey";
KSWXRichTextStyleKey const KSWXRichTextLinkUnderlineColorKey = @"KSWXRichTextLinkUnderlineColorKey";
KSWXRichTextStyleKey const KSWXRichTextDefaultFontFamilyKey = @"KSWXRichTextDefaultFontFamilyKey";

static void(^_linkClick)(WXSDKInstance *weexInstance, NSURL *URL) = nil;

static UIColor *_defaultLinkTextColor = nil;
static UIColor *_defaultLinkUnderlineColor = nil;
static NSString *_defaultFontFamily = nil;

@interface KSWXRichTextComponent () <UITextViewDelegate>

@property (nonatomic) UITextView *textView;
@property (nonatomic, copy) NSString *text;
@property (nonatomic) UIColor *colorForStyle;
@property (nonatomic) CGFloat fontSizeForStyle;
@property (nonatomic) NSTextAlignment textAlignForStyle;
@property (nonatomic) CGFloat lineHeightForStyle;
@property (nonatomic) CGFloat paddingLeftForStyle;
@property (nonatomic) CGFloat paddingRightForStyle;
@property (nonatomic) CGFloat paddingTopForStyle;
@property (nonatomic) CGFloat paddingBottomForStyle;
@property (nonatomic) CGFloat letterSpacingForStyle;
@property (nonatomic) NSUInteger linesForStyle;
@property (nonatomic, copy) NSAttributedString *attributeString;
@property (nonatomic) NSLineBreakMode lineBreakModeForStyle;
@property (nonatomic, copy) NSString *fontFamilyForStyle;
@property (nonatomic) NSUInteger maxLines;

@end

@implementation KSWXRichTextComponent

+ (void)initialize {
    _defaultLinkTextColor = UIColorCreateWithHexString(@"5cb975");
    _defaultLinkUnderlineColor = [UIColor clearColor];
    _defaultFontFamily = @"PingFangSC-Regular";
}

WX_EXPORT_METHOD(@selector(getTextLineInfo:))

+ (void)observeLinkClick:(void (^)(WXSDKInstance *, NSURL *))linkClick {
    _linkClick = linkClick;
}

+ (void)addDefaultStyles:(NSDictionary<KSWXRichTextStyleKey,id> *)styles {
    if (styles[KSWXRichTextLinkTextColorKey] &&
        [styles[KSWXRichTextLinkTextColorKey] isKindOfClass:[UIColor class]]) {
        _defaultLinkTextColor = styles[KSWXRichTextLinkTextColorKey];
    }
    
    if (styles[KSWXRichTextLinkUnderlineColorKey] &&
        [styles[KSWXRichTextLinkUnderlineColorKey] isKindOfClass:[UIColor class]]) {
        _defaultLinkUnderlineColor = styles[KSWXRichTextLinkUnderlineColorKey];
    }
    
    if (styles[KSWXRichTextDefaultFontFamilyKey] &&
        [styles[KSWXRichTextDefaultFontFamilyKey] isKindOfClass:[NSString class]]) {
        _defaultFontFamily = styles[KSWXRichTextDefaultFontFamilyKey];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if (_linkClick) {
        _linkClick(self.weexInstance, URL);
    }
    
    return NO;
}

- (void)getTextLineInfo:(WXKeepAliveCallback)resultCallback{
    if (resultCallback) {
        NSDictionary *result = @{@"maxLine": @(_linesForStyle),
                                 @"realLine": @(_maxLines)
                                 };
        resultCallback([result jsonString], NO);
    }
}

- (UIView *)loadView {
    UITextView *textView = [UITextView new];
    textView.textContainer.lineFragmentPadding = 0;
    textView.textContainerInset = UIEdgeInsetsZero;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.delegate = self;
    if (@available(iOS 11.0, *)) {
        textView.textDragInteraction.enabled = NO;
    }
    self.textView = textView;
    return textView;
}

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance {
    _lineHeightForStyle = NSNotFound;
    _linesForStyle = 0;
    _maxLines = 0;
    
    NSMutableDictionary *newStyles = [NSMutableDictionary dictionaryWithDictionary:styles];
    // 这两个外部样式会影响最小高度
    [newStyles removeObjectForKey:@"paddingTop"];
    [newStyles removeObjectForKey:@"paddingBottom"];
    
    if(self = [super initWithRef:ref type:type styles:newStyles attributes:attributes events:events weexInstance:weexInstance]) {
        
        [self handleAttributes:attributes];
        [self handleStyles:styles isUpdate:NO];
    }
    return self;
}

- (void)handleAttributes:(NSDictionary *)attributes{
    if (attributes[@"text"]) {
        NSString *text = attributes[@"text"];
        text = [NSString convertToRichHTMLWithString:text];
        
        { // <p>123<br><p> iOS会多一个空白行，把这种格式中的br去掉
            NSRange range = [text rangeOfString:@"<p.*><br></p>" options:NSRegularExpressionSearch];
            if (range.length == text.length) {
                text = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br/>"];
            }
            text = [text stringByReplacingOccurrencesOfString:@"<br></p>" withString:@"</p>"];
        }
        
        { // 纯文本的非html标签会无法换行
            NSRange range = [text rangeOfString:@"(<.+>).*(</.+>)" options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                self.text = [NSString stringWithFormat:@"<style>*{margin:0;padding:0;}</style>%@", text];
            } else {
                self.text = [NSString stringWithFormat:@"<style>*{margin:0;padding:0;}</style><div>%@</div>", text];
            }
        }
        
        { // \r\n和\n转成<br>
            self.text = [self.text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br>"];
            self.text = [self.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        }
    }
}

- (void)handleStyles:(NSDictionary *)styles isUpdate:(BOOL)isUpdate {
    if (styles[@"color"]) {
        _colorForStyle = [WXConvert UIColor:styles[@"color"]];
    }
    if (styles[@"fontSize"]) {
        _fontSizeForStyle = [WXConvert WXPixelType:styles[@"fontSize"] scaleFactor:self.weexInstance.pixelScaleFactor];
    } else if (!isUpdate) {
        _fontSizeForStyle = 12;
    }
    if (styles[@"textAlign"]) {
        _textAlignForStyle = [WXConvert NSTextAlignment:styles[@"textAlign"]];
    } else if (!isUpdate)  {
        _textAlignForStyle = NSNotFound;
    }
    if (styles[@"lineHeight"]) {
        _lineHeightForStyle = [WXConvert WXPixelType:styles[@"lineHeight"] scaleFactor:self.weexInstance.pixelScaleFactor];
    }
    if (styles[@"paddingLeft"]) {
        _paddingLeftForStyle = [WXConvert WXPixelType:styles[@"paddingLeft"] scaleFactor:self.weexInstance.pixelScaleFactor];
    }
    if (styles[@"paddingRight"]) {
        _paddingRightForStyle = [WXConvert WXPixelType:styles[@"paddingRight"] scaleFactor:self.weexInstance.pixelScaleFactor];
    }
    if (styles[@"paddingTop"]) {
        _paddingTopForStyle = [WXConvert WXPixelType:styles[@"paddingTop"] scaleFactor:self.weexInstance.pixelScaleFactor];
    }
    if (styles[@"paddingBottom"]) {
        _paddingBottomForStyle = [WXConvert WXPixelType:styles[@"paddingBottom"] scaleFactor:self.weexInstance.pixelScaleFactor];
    }
    if (styles[@"letterSpacing"]) {
        _letterSpacingForStyle = [WXConvert WXPixelType:styles[@"letterSpacing"] scaleFactor:self.weexInstance.pixelScaleFactor];
    }
    if (styles[@"textOverflow"]) {
        NSString *textOverflow = styles[@"textOverflow"];
        if ([textOverflow isEqualToString:@"ellipsis"]) {
            _lineBreakModeForStyle = NSLineBreakByTruncatingTail;
        } else {
            _lineBreakModeForStyle = NSLineBreakByWordWrapping;
        }
    }
    if (styles[@"lines"]) {
        _linesForStyle = [styles[@"lines"] intValue];
    } else if (!isUpdate)  {
        _linesForStyle = 0;
    }
    if (styles[@"fontFamily"]) {
        _fontFamilyForStyle = styles[@"fontFamily"];
    }
}

- (CGSize (^)(CGSize))measureBlock {
    __weak typeof(self) weakSelf = self;
    return ^CGSize (CGSize constrainedSize) {
        CGRect rect = [weakSelf.attributeString boundingRectWithSize:CGSizeMake(constrainedSize.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL];
        CGRect oneLineRect = [weakSelf.attributeString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL];
        weakSelf.maxLines = ceil(rect.size.height / oneLineRect.size.height);
        
        CGFloat height = 0;
        if (weakSelf.linesForStyle > 0) {
            height = weakSelf.linesForStyle > weakSelf.maxLines ? rect.size.height : oneLineRect.size.height * weakSelf.linesForStyle;
        } else {
            height = rect.size.height;
        }
        height = height + weakSelf.paddingTopForStyle + weakSelf.paddingBottomForStyle;
        
        return (CGSize) {
            WXCeilPixelValue(constrainedSize.width),
            WXCeilPixelValue(ceil(height))
        };
    };
}

- (void)updateStyles:(NSDictionary *)styles {
    [self handleStyles:styles isUpdate:YES];
    [self setNeedsRePaint];
}

- (void)updateAttributes:(NSDictionary *)attributes {
    if (attributes[@"text"]) {
        [self setNeedsReFillAttributes:attributes];
        [self setNeedsRePaint];
    }
}

- (void)setNeedsReFillAttributes:(NSDictionary *)attributes {
    self.attributeString = nil;
    [self handleAttributes:attributes];
    self.textView.attributedText = self.attributeString;
}

- (void)setNeedsRePaint {
    [self.weexInstance.componentManager _addUITask:^{
        if ([self isViewLoaded]) {
            [self updateTextView];
            [self setNeedsLayout];
            [self readyToRender];
            [self setNeedsDisplay];
        }
    }];
}

- (void)updateTextView {
    self.textView.textContainer.lineBreakMode = _lineBreakModeForStyle;
    self.textView.textContainer.maximumNumberOfLines = _linesForStyle;
    self.textView.textContainerInset = UIEdgeInsetsMake(_paddingTopForStyle, _paddingLeftForStyle, _paddingBottomForStyle, _paddingRightForStyle);
    if (_textAlignForStyle != NSNotFound) {
        self.textView.textAlignment = _textAlignForStyle;
    }
}

- (void)viewDidLoad {
    self.textView.attributedText = self.attributeString;
    self.textView.linkTextAttributes = @{NSForegroundColorAttributeName: _defaultLinkTextColor,
                                         NSUnderlineColorAttributeName: _defaultLinkUnderlineColor
                                         };
    [self updateTextView];
}

- (NSAttributedString *)attributeString {
    if (!_attributeString) {
        _attributeString = [self buildAttributeString];
    }
    return _attributeString;
}

- (NSAttributedString *)buildAttributeString {
    __weak typeof(self) weakSelf = self;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[self.text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    if (_colorForStyle) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:_colorForStyle range:NSMakeRange(0, attributedString.length)];
    }
    
    if (_letterSpacingForStyle > 0) {
        [attributedString addAttribute:NSKernAttributeName value:@(_letterSpacingForStyle) range:NSMakeRange(0, attributedString.length)];
    }
    
    __block UIFont *font = nil;
    
    [attributedString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[UIFont class]]) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            font = value;
            CGFloat fontSize = strongSelf.fontSizeForStyle > 0 ? strongSelf.fontSizeForStyle : 12;
            
            if (strongSelf.fontFamilyForStyle && [UIFont fontWithName:strongSelf.fontFamilyForStyle size:fontSize]) {
                font = [UIFont fontWithName:strongSelf.fontFamilyForStyle size:fontSize];
            } else if (_defaultFontFamily && [UIFont fontWithName:_defaultFontFamily size:fontSize]) {
                font = [UIFont fontWithName:_defaultFontFamily size:fontSize];
            } else if ([font.familyName isEqualToString:@"Times New Roman"]) {
                // 默认字体（Times New Roman）得到的baseline值有问题
                font = [UIFont systemFontOfSize:fontSize];
            } else {
                font = [UIFont fontWithDescriptor:font.fontDescriptor size:fontSize];
            }
            
            [attributedString addAttribute:NSFontAttributeName value:font range:range];
        }
    }];
    
    if (_lineHeightForStyle == NSNotFound) {
        _lineHeightForStyle = font.lineHeight;
    }
    
    [attributedString enumerateAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if ([value isKindOfClass:[NSParagraphStyle class]]) {
            NSMutableParagraphStyle *style = value;
            
            [attributedString addAttribute:NSBaselineOffsetAttributeName value:@((strongSelf.lineHeightForStyle - font.lineHeight) / 2.0) range:range];
            
            style.minimumLineHeight = strongSelf.lineHeightForStyle;
            style.maximumLineHeight = strongSelf.lineHeightForStyle;
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:range];
        }
    }];
    
    NSRange tailRange = NSMakeRange(attributedString.length - 1, 1);
    if (attributedString.length > 0 &&
        [[[attributedString attributedSubstringFromRange:tailRange] string] isEqualToString:@"\n"]) {
        [attributedString replaceCharactersInRange:tailRange withString:@""];
    }
    
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSAttributedString *value = [attributedString attributedSubstringFromRange:range];
        
        if ([value.string hasPrefix:RICH_TAG_IDENTIFIER]) {
            NSString *json = [value.string substringFromIndex:RICH_TAG_IDENTIFIER.length];
            NSDictionary *styles = [[json decodedStylesString] jsonObject];
            
            UIImage *image = [UIImage createTagImageWithStyles:styles];
            
            NSMutableAttributedString *tagAttrString = [NSMutableAttributedString attributedStringOfImage:image lineHeight:strongSelf.lineHeightForStyle descender:font.descender];
            
            [attributedString replaceCharactersInRange:range withAttributedString:tagAttrString];
        }
    }];
    
    return attributedString;
}

@end
