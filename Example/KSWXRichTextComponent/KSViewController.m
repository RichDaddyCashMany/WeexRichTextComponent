//
//  KSViewController.m
//  KSWXRichTextComponent
//
//  Created by HJaycee on 11/28/2018.
//  Copyright (c) 2018 HJaycee. All rights reserved.
//

#import "KSViewController.h"
#import "KSWXRichTextComponent.h"
#import <WeexSDK/WeexSDK.h>

@interface KSViewController ()

@property (nonatomic) WXSDKInstance *weexInstance;

@end

@implementation KSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [WXSDKEngine initSDKEnvironment];
    
    // register component
    [WXSDKEngine registerComponent:@"rich-text" withClass:[KSWXRichTextComponent class]];
    
    [KSWXRichTextComponent addDefaultStyles:@{KSWXRichTextLinkTextColorKey: [UIColor orangeColor],
                                              KSWXRichTextLinkUnderlineColorKey: [UIColor orangeColor]
                                              }];
    
    [KSWXRichTextComponent observeLinkClick:^(WXSDKInstance *weexInstance, NSURL *URL) {
        if ([URL.scheme isEqualToString:@"somescheme"]) {
            // do some thing
        }
    }];
    
    // render
    self.weexInstance = [WXSDKInstance new];
    self.weexInstance.viewController = self;
    self.weexInstance.frame = self.view.frame;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.js" ofType:nil];
    [self.weexInstance renderWithURL:[NSURL fileURLWithPath:path]];
    
    __weak typeof(self) weakSelf = self;
    
    self.weexInstance.onCreate = ^(UIView *view) {
        [weakSelf.view addSubview:view];
    };
    
    self.weexInstance.onFailed = ^(NSError *error) {
        NSLog(@"onFailed: %@", error);
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
