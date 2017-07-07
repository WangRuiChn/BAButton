//
//  UIButton+BAKit.m
//  BAButtonDemo
//
//  Created by boai on 2017/5/17.
//  Copyright © 2017年 博爱之家. All rights reserved.
//

#import "UIButton+BAKit.h"
#import <objc/runtime.h>
#import "BAKit_ConfigurationDefine.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIImage (BAKit)

/**
 创建一个 纯颜色 图片【全部铺满】
 
 @param color color
 @return 纯颜色 图片
 */
+ (UIImage *)ba_image_Color:(UIColor *)color
{
    UIImage *image = [self ba_image_Color:color size:CGSizeMake(1.0f, 1.0f)];
    return image;
}

/**
 创建一个 纯颜色 图片【可以设置 size】
 
 @param color color
 @param size size
 @return 纯颜色 图片
 */
+ (UIImage *)ba_image_Color:(UIColor *)color size:(CGSize)size
{
    CGRect rect          = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *image       = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/*!
 *  根据宽比例去缩放图片
 *
 *  @param width width description
 *
 *  @return return value description
 */
- (UIImage *)ba_imageScaleToWidth:(CGFloat)width
{
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat old_width = imageSize.width;
    CGFloat old_height = imageSize.height;
    CGFloat targetWidth = width;
    CGFloat targetHeight = old_height / (old_width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO)
    {
        CGFloat widthFactor = targetWidth / old_width;
        CGFloat heightFactor = targetHeight / old_height;
        if(widthFactor > heightFactor)
        {
            scaleFactor = widthFactor;
        }
        else
        {
            scaleFactor = heightFactor;
        }
        scaledWidth = old_width * scaleFactor;
        scaledHeight = old_height * scaleFactor;
        if(widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

@implementation UIButton (BAKit)

- (void)setupButtonLayout
{
    CGFloat image_w = self.imageView.bounds.size.width;
    CGFloat image_h = self.imageView.bounds.size.height;
    
    CGFloat title_w = self.titleLabel.bounds.size.width;
    CGFloat title_h = self.titleLabel.bounds.size.height;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
    {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        title_w = self.titleLabel.intrinsicContentSize.width;
        title_h = self.titleLabel.intrinsicContentSize.height;
    }

    UIEdgeInsets imageEdge = UIEdgeInsetsZero;
    UIEdgeInsets titleEdge = UIEdgeInsetsZero;
    
    if (self.ba_padding_inset == 0)
    {
        self.ba_padding_inset = 5;
    }
    
    switch (self.ba_buttonLayoutType) {
        case BAKit_ButtonLayoutTypeNormal:
        {
            
            titleEdge = UIEdgeInsetsMake(0, self.ba_padding, 0, 0);
            
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.ba_padding);
            
        }
            break;
        case BAKit_ButtonLayoutTypeCenterImageRight:
        {
            titleEdge = UIEdgeInsetsMake(0, -image_w - self.ba_padding, 0, image_w);
            imageEdge = UIEdgeInsetsMake(0, title_w + self.ba_padding, 0, -title_w);
        }
            break;
        case BAKit_ButtonLayoutTypeCenterImageTop:
        {
            titleEdge = UIEdgeInsetsMake(0, -image_w, -image_h - self.ba_padding, 0);
            imageEdge = UIEdgeInsetsMake(-title_h - self.ba_padding, 0, 0, -title_w);
        }
            break;
        case BAKit_ButtonLayoutTypeCenterImageBottom:
        {
            titleEdge = UIEdgeInsetsMake(-image_h - self.ba_padding, -image_w, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, -title_h - self.ba_padding, -title_w);
        }
            break;
        case BAKit_ButtonLayoutTypeLeftImageLeft:
        {
            titleEdge = UIEdgeInsetsMake(0, self.ba_padding + self.ba_padding_inset, 0, 0);
            
            imageEdge = UIEdgeInsetsMake(0, self.ba_padding_inset, 0, 0);

            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case BAKit_ButtonLayoutTypeLeftImageRight:
        {
            titleEdge = UIEdgeInsetsMake(0, -image_w + self.ba_padding_inset, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, title_w + self.ba_padding + self.ba_padding_inset, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case BAKit_ButtonLayoutTypeRightImageLeft:
        {
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.ba_padding + self.ba_padding_inset);
            titleEdge = UIEdgeInsetsMake(0, 0, 0, self.ba_padding_inset);

            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
        case BAKit_ButtonLayoutTypeRightImageRight:
        {
            titleEdge = UIEdgeInsetsMake(0, 0, 0, image_w + self.ba_padding + self.ba_padding_inset);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, -title_w + self.ba_padding_inset);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
            
        default:
            break;
    }
    self.imageEdgeInsets = imageEdge;
    self.titleEdgeInsets = titleEdge;
}

#pragma mark - 快速创建 button

/**
 快速创建 button1：frame、title、titleColor、titleFont
 
 @param frame frame
 @param title title
 @param titleColor titleColor
 @param titleFont titleFont
 @return button
 */
+ (id)ba_buttonWithFrame:(CGRect)frame
                   title:(NSString * __nullable)title
              titleColor:(UIColor * __nullable)titleColor
               titleFont:(UIFont * __nullable)titleFont
{
    UIButton *button = [UIButton ba_buttonWithFrame:frame title:title titleColor:titleColor titleFont:titleFont backgroundColor:nil];
    
    return button;
}

/**
 快速创建 button2：frame、title、backgroundColor
 
 @param frame frame
 @param title title
 @param backgroundColor backgroundColor
 @return button
 */
+ (id)ba_buttonWithFrame:(CGRect)frame
                   title:(NSString * __nullable)title
         backgroundColor:(UIColor * __nullable)backgroundColor
{
    UIButton *button = [UIButton ba_buttonWithFrame:frame title:title titleColor:nil titleFont:nil backgroundColor:backgroundColor];
    
    return button;
}

/**
 快速创建 button3：frame、title、titleColor、titleFont、backgroundColor

 @param frame frame
 @param title title
 @param titleColor titleColor
 @param titleFont titleFont
 @param backgroundColor backgroundColor
 @return button
 */
+ (id)ba_buttonWithFrame:(CGRect)frame
                   title:(NSString * __nullable)title
              titleColor:(UIColor * __nullable)titleColor
               titleFont:(UIFont * __nullable)titleFont
         backgroundColor:(UIColor * __nullable)backgroundColor
{
    UIButton *button = [UIButton ba_buttonWithFrame:frame title:title titleColor:titleColor titleFont:titleFont image:nil backgroundColor:backgroundColor];

    return button;
}

/**
 快速创建 button4：frame、title、backgroundImage
 
 @param frame frame
 @param title title
 @param backgroundImage backgroundImage
 @return button
 */
+ (id)ba_buttonWithFrame:(CGRect)frame
                   title:(NSString * __nullable)title
         backgroundImage:(UIImage * __nullable)backgroundImage
{
    UIButton *button = [UIButton ba_buttonWithFrame:frame title:title backgroundImage:backgroundImage];
    return button;
}

/**
 快速创建 button5：frame、title、titleColor、titleFont、image、backgroundColor

 @param frame frame description
 @param title title description
 @param titleColor titleColor description
 @param titleFont titleFont description
 @param image image description
 @param backgroundColor backgroundColor description
 @return button
 */
+ (instancetype)ba_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                        titleColor:(UIColor * __nullable)titleColor
                         titleFont:(UIFont * __nullable)titleFont
                             image:(UIImage * __nullable)image
                   backgroundColor:(UIColor * __nullable)backgroundColor
{
    UIButton *button = [UIButton ba_buttonWithFrame:frame title:title selectedTitle:nil highlightedTitle:nil titleColor:titleColor selectedTitleColor:nil highlightedTitleColor:nil titleFont:titleFont image:image selectedImage:nil highlightedImage:nil backgroundImage:nil selectedBackgroundImage:nil highlightedBackgroundImage:nil backgroundColor:backgroundColor selectedBackgroundColor:nil highlightedBackgroundColor:nil];
    
    return button;
}

/**
 快速创建 button6：frame、title、titleColor、titleFont、image、backgroundImage

 @param frame frame description
 @param title title description
 @param titleColor titleColor description
 @param titleFont titleFont description
 @param image image description
 @param backgroundImage backgroundImage description
 @return button
 */
+ (instancetype)ba_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                        titleColor:(UIColor * __nullable)titleColor
                         titleFont:(UIFont * __nullable)titleFont
                             image:(UIImage * __nullable)image
                   backgroundImage:(UIImage * __nullable)backgroundImage
{
    UIButton *button = [UIButton ba_buttonWithFrame:frame title:title selectedTitle:nil highlightedTitle:nil titleColor:titleColor selectedTitleColor:nil highlightedTitleColor:nil titleFont:titleFont image:image selectedImage:nil highlightedImage:nil backgroundImage:backgroundImage selectedBackgroundImage:nil highlightedBackgroundImage:nil backgroundColor:nil selectedBackgroundColor:nil highlightedBackgroundColor:nil];
    
    return button;
}


/**
 快速创建 button7：大汇总-点击事件、圆角
 
 @param frame frame
 @param title title
 @param selTitle selTitle
 @param titleColor titleColor，默认：黑色
 @param titleFont titleFont默认：15
 @param image image description
 @param selImage selImage
 @param padding padding 文字图片间距
 @param buttonLayoutType buttonLayoutType 文字图片布局样式
 @param viewRectCornerType viewRectCornerType 圆角样式
 @param viewCornerRadius viewCornerRadius 圆角角度
 @param target target
 @param sel sel
 @return button
 */
+ (instancetype __nonnull)ba_creatButtonWithFrame:(CGRect)frame
                                            title:(NSString * __nullable)title
                                         selTitle:(NSString * __nullable)selTitle
                                       titleColor:(UIColor * __nullable)titleColor
                                        titleFont:(UIFont * __nullable)titleFont
                                            image:(UIImage * __nullable)image
                                         selImage:(UIImage * __nullable)selImage
                                          padding:(CGFloat)padding
                              buttonPositionStyle:(BAKit_ButtonLayoutType)buttonLayoutType
                               viewRectCornerType:(BAKit_ViewRectCornerType)viewRectCornerType
                                 viewCornerRadius:(CGFloat)viewCornerRadius
                                           target:(id __nullable)target
                                         selector:(SEL __nullable)sel
{
    UIButton *button = [UIButton ba_buttonWithFrame:frame title:title selectedTitle:selTitle highlightedTitle:nil titleColor:titleColor selectedTitleColor:nil highlightedTitleColor:nil titleFont:titleFont image:image selectedImage:selImage highlightedImage:nil backgroundImage:nil selectedBackgroundImage:nil highlightedBackgroundImage:nil backgroundColor:nil selectedBackgroundColor:nil highlightedBackgroundColor:nil];
    [button ba_button_setButtonLayoutType:buttonLayoutType padding:padding];
    [button ba_button_setViewRectCornerType:viewRectCornerType viewCornerRadius:viewCornerRadius];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

/**
 快速创建 button8：大汇总-所有 normal、selected、highlighted 样式都有

 @param frame frame
 @param title title description
 @param selectedTitle selectedTitle description
 @param highlightedTitle highlightedTitle description
 @param titleColor titleColor description
 @param selectedTitleColor selectedTitleColor description
 @param highlightedTitleColor highlightedTitleColor description
 @param titleFont titleFont description
 @param image image description
 @param selectedImage selectedImage description
 @param highlightedImage highlightedImage description
 @param backgroundImage backgroundImage description
 @param selectedBackgroundImage selectedBackgroundImage description
 @param highlightedBackgroundImage highlightedBackgroundImage description
 @param backgroundColor backgroundColor description
 @param selectedBackgroundColor selectedBackgroundColor description
 @param highlightedBackgroundColor highlightedBackgroundColor description
 @return button
 */
+ (instancetype)ba_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                     selectedTitle:(NSString * __nullable)selectedTitle
                  highlightedTitle:(NSString * __nullable)highlightedTitle
                        titleColor:(UIColor * __nullable)titleColor
                selectedTitleColor:(UIColor * __nullable)selectedTitleColor
             highlightedTitleColor:(UIColor * __nullable)highlightedTitleColor
                         titleFont:(UIFont * __nullable)titleFont
                             image:(UIImage * __nullable)image
                     selectedImage:(UIImage * __nullable)selectedImage
                  highlightedImage:(UIImage * __nullable)highlightedImage
                   backgroundImage:(UIImage * __nullable)backgroundImage
           selectedBackgroundImage:(UIImage * __nullable)selectedBackgroundImage
        highlightedBackgroundImage:(UIImage * __nullable)highlightedBackgroundImage
                   backgroundColor:(UIColor * __nullable)backgroundColor
           selectedBackgroundColor:(UIColor * __nullable)selectedBackgroundColor
        highlightedBackgroundColor:(UIColor * __nullable)highlightedBackgroundColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    [button ba_buttonSetTitle:title selectedTitle:selectedTitle highlightedTitle:highlightedTitle];
    if (!titleColor)
    {
        titleColor = [UIColor blackColor];
    }
    [button ba_buttonSetTitleColor:titleColor selectedTitleColor:selectedTitleColor highlightedTitleColor:highlightedTitleColor];
    button.titleLabel.font = titleFont ? titleFont : [UIFont systemFontOfSize:15.0f];
    
    [button ba_buttonSetImage:image selectedImage:selectedImage highlightedImage:highlightedImage];
    [button ba_buttonSetBackgroundImage:backgroundImage selectedBackgroundImage:selectedBackgroundImage highlightedBackgroundImage:highlightedBackgroundImage];
    [button ba_buttonSetBackgroundColor:backgroundColor selectedBackgroundColor:selectedBackgroundColor highlightedBackgroundColor:highlightedBackgroundColor];
    
    return button;
}

#pragma mark - 自定义：button
/**
 自定义：button backgroundColor、selectedBackgroundColor、highlightedBackgroundColor

 @param backgroundColor backgroundColor
 @param selectedBackgroundColor selectedBackgroundColor
 @param highlightedBackgroundColor highlightedBackgroundColor
 */
- (void)ba_buttonSetBackgroundColor:(UIColor * __nullable)backgroundColor
            selectedBackgroundColor:(UIColor * __nullable)selectedBackgroundColor
         highlightedBackgroundColor:(UIColor * __nullable)highlightedBackgroundColor
{

    [self ba_buttonSetBackgroundImage:[UIImage ba_image_Color:backgroundColor]
              selectedBackgroundImage:[UIImage ba_image_Color:selectedBackgroundColor]
           highlightedBackgroundImage:[UIImage ba_image_Color:highlightedBackgroundColor]];
}

/**
 自定义：button backgroundImage、selectedBackgroundImage、highlightedBackgroundImage

 @param backgroundImage backgroundImage
 @param selectedBackgroundImage selectedBackgroundImage
 @param highlightedBackgroundImage highlightedBackgroundImage
 */
- (void)ba_buttonSetBackgroundImage:(UIImage * __nullable)backgroundImage
            selectedBackgroundImage:(UIImage * __nullable)selectedBackgroundImage
         highlightedBackgroundImage:(UIImage * __nullable)highlightedBackgroundImage
{
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
}

/**
 自定义：button image、selectedImage、highlightedImage

 @param image image
 @param selectedImage selectedImage
 @param highlightedImage highlightedImage
 */
- (void)ba_buttonSetImage:(UIImage * __nullable)image
            selectedImage:(UIImage * __nullable)selectedImage
         highlightedImage:(UIImage * __nullable)highlightedImage
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:selectedImage forState:UIControlStateSelected];
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
}

/**
 自定义：button title、selectedTitle、highlightedTitle

 @param title title
 @param selectedTitle selectedTitle
 @param highlightedTitle highlightedTitle
 */
- (void)ba_buttonSetTitle:(NSString * __nullable)title
            selectedTitle:(NSString * __nullable)selectedTitle
         highlightedTitle:(NSString * __nullable)highlightedTitle
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:selectedTitle forState:UIControlStateSelected];
    [self setTitle:highlightedTitle forState:UIControlStateHighlighted];
}

/**
 自定义：button titleColor、selectedTitleColor、highlightedTitleColor

 @param titleColor titleColor
 @param selectedTitleColor selectedTitleColor
 @param highlightedTitleColor highlightedTitleColor
 */
- (void)ba_buttonSetTitleColor:(UIColor * __nullable)titleColor
            selectedTitleColor:(UIColor * __nullable)selectedTitleColor
         highlightedTitleColor:(UIColor * __nullable)highlightedTitleColor
{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
}

/**
 自定义：button 字体、大小

 @param fontName fontName
 @param size size
 */
- (void)ba_buttonSetTitleFontName:(NSString *)fontName
                             size:(CGFloat)size
{
    [self.titleLabel setFont:[UIFont fontWithName:fontName size:size]];
}

/**
 自定义：button 点击事件，默认：UIControlEventTouchUpInside

 @param target target
 @param tag tag
 @param action action
 */
- (void)ba_buttonAddTarget:(nullable id)target
                       tag:(NSInteger)tag
                    action:(SEL)action
{
    self.tag = tag;
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

/**
 快速设置 button 的布局样式 和 间距
 
 @param type button 的布局样式
 @param padding 文字与图片之间的间距
 */
- (void)ba_button_setButtonLayoutType:(BAKit_ButtonLayoutType)type padding:(CGFloat)padding
{
    self.ba_buttonLayoutType = type;
    self.ba_padding = padding;
}

/**
 快速切圆角
 
 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 */
- (void)ba_button_setViewRectCornerType:(BAKit_ViewRectCornerType)type viewCornerRadius:(CGFloat)viewCornerRadius
{
    [self ba_view_setViewRectCornerType:type viewCornerRadius:viewCornerRadius];
}

/**
 快速切圆角，带边框、边框颜色
 
 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 @param borderWidth 边线宽度
 @param borderColor 边线颜色
 */
- (void)ba_button_setViewRectCornerType:(BAKit_ViewRectCornerType)type
                       viewCornerRadius:(CGFloat)viewCornerRadius
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor
{
    [self ba_view_setViewRectCornerType:type viewCornerRadius:viewCornerRadius borderWidth:borderWidth borderColor:borderColor];
}

#pragma mark - setter / getter
- (void)setBa_buttonLayoutType:(BAKit_ButtonLayoutType)ba_buttonLayoutType
{
    BAKit_Objc_setObj(@selector(ba_buttonLayoutType), @(ba_buttonLayoutType));
    [self setupButtonLayout];
}

- (BAKit_ButtonLayoutType)ba_buttonLayoutType
{
    return [BAKit_Objc_getObj integerValue];
}

- (void)setBa_padding:(CGFloat)ba_padding
{
    BAKit_Objc_setObj(@selector(ba_padding), @(ba_padding));
    [self setupButtonLayout];
}

- (CGFloat)ba_padding
{
    return [BAKit_Objc_getObj floatValue];
}

- (void)setBa_padding_inset:(CGFloat)ba_padding_inset
{
    BAKit_Objc_setObj(@selector(ba_padding_inset), @(ba_padding_inset));
    [self setupButtonLayout];
}

- (CGFloat)ba_padding_inset
{
    return [BAKit_Objc_getObj floatValue];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setupButtonLayout];
}

@end
NS_ASSUME_NONNULL_END

