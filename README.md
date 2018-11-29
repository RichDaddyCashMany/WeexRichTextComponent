## 介绍
本仓库是iOS端的weex富文本组件。本质上是一个`UITextView`，用于将`HTML`字符串解析成`NSAttributedString`。

但是，并不是所有`HTML`样式都能被解析出来，比如`圆角`、`渐变`、`边框`等。

本组件对这些特殊样式也一样做了支持，并且支持自定义`超链接颜色`、`文字行数获取`等扩展功能。

## Cocoapods

```
pod 'KSWXRichTextComponent'
```

## 效果演示

![example.png](https://github.com/HJaycee/WeexRichTextComponent/blob/master/example.png?raw=true)

## 如何使用

**1.原生中注册组件**

```
[WXSDKEngine registerComponent:@"rich-text" withClass:[KSWXRichTextComponent class]];
```

**2.前端中使用组件**

```
<rich-text class="rich" text="<p style='color:blue;'>abc</p>"></rich-text>

.rich {
	color: red;
}
```

## 外部样式（class）

```
color: ;
fontFamily: ;
fontSize: ;
textAlign: ;
lineHeight: ;
paddingLeft: ;
paddingRight: ;
paddingTop: ;
paddingBottom: ;
letterSpacing: ;
textOverflow: ; // only ellipsis
lines: ;
```

## 内部样式（style）

> 支持所有样式，但是并不是都会被解析出来，比如`圆角相关样式`

## 圆角相关样式（style）

> style中带`border`样式的会被解析成图片附件（NSTextAttachment）替换原来的富文本

```
/*自带以下样式，修改无效*/
display: inline-block;
border-style: solid;
white-space: nowrap;
overflow: hidden;

/*渐变色支持四个方向*/
background-image: linear-gradient(to {where}, {color}, {color}, ...);

/*只支持ellipsis*/
text-overflow: ellipsis;

/*只支持left、right、center*/
text-align: ; 

margin: ;
margin-top: ;
margin-bottom: ;
margin-left: ;
margin-right: ;

padding: ;
padding-top: ;
padding-bottom: ;
padding-left: ;
padding-right: ;

font-size: ;
font-family: ;
color: ;

border-radius: ;
background-color: ;

height ;
width: ;
line-height: ;

border-width: ;
border-color: ;
```

## DOM方法

**1.获取行数**

```
 $refs.richtext.getTextLineInfo((res) => {
    const arg = JSON.parse(res)
    res.maxLine // 最大行数
    res.realLine // 实际行数
 })
```

## 超链接监听

```
[KSWXRichTextComponent observeLinkClick:^(WXSDKInstance *weexInstance, NSURL *URL) {
    if ([URL.scheme isEqualToString:@"somescheme"]) {
        // do some thing
    }
}];
```

## 超链接样式自定义

```
[KSWXRichTextComponent addDefaultStyles:@{KSWXRichTextLinkTextColorKey: [UIColor orangeColor],
                                          KSWXRichTextLinkUnderlineColorKey: [UIColor orangeColor]
                                          }];
```

## LICENSE

MIT
