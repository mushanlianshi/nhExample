//
//  LBCustomTextField.m
//  nhExample
//
//  Created by liubin on 17/4/6.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCustomTextField.h"

@interface LBCustomTextField()
{
    CGFloat _leftMargin;
}
@end


@implementation LBCustomTextField


-(instancetype)initWithFrame:(CGRect)frame pleaceHolder:(NSString *)pleaceHolder pleaceHolderColor:(UIColor *)holderColor textColor:(UIColor *)textColor leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage leftMargin:(CGFloat)leftMargin{
    self= [super initWithFrame:frame];
    if (self) {
        _leftMargin = leftMargin;
        self.placeholder = pleaceHolder;
        self.layerCornerRadius = 7;
        self.font = kFont(14);
        self.textColor = textColor;
//        self.textColor = [UIColor redColor];
        //设置键盘的类别
        self.returnKeyType = UIReturnKeySearch;
        self.pleaceHolderColor = holderColor;
        self.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
//        self.pl
        leftImage = leftImage ? leftImage : ImageNamed(@"searchicon");
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:leftImage];
        leftImageView.frame = CGRectMake(20, 0, leftImage.size.width, leftImage.size.height);
        leftImageView.contentMode = UIViewContentModeCenter;
        
        rightImage = rightImage ? rightImage : ImageNamed(@"deleteinput");
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteText)];
        UIImageView *rightImageView = [[UIImageView alloc] initWithImage:rightImage];
        rightImageView.frame = CGRectMake(frame.size.width - 20, 0, leftImage.size.width, leftImage.size.height);
        rightImageView.contentMode = UIViewContentModeCenter;
        rightImageView.userInteractionEnabled = YES;
        [rightImageView addGestureRecognizer:tapGesture];
        
        self.leftView = leftImageView;
        //左边图片显示的类型
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightView = rightImageView;
        
        
    }
    return self;
}


-(void)deleteText{
    self.text = @"";
}
#pragma mark 是否显示右边的删除按钮 根据显示的mode来设置
-(void)showRightImageView:(BOOL)isShow{
    UITextFieldViewMode mode = isShow ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
    self.rightViewMode = mode;
}

#pragma mark 根据key- value设置提示的样色
- (void)setPleaceHolderColor:(UIColor *)pleaceHolderColor{
    _pleaceHolderColor = pleaceHolderColor;
    [self setValue:pleaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
}


#pragma mark 子控件的rect位置

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect.origin.x += 10;
    return rect;
}
-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rect = [super rightViewRectForBounds:bounds];
    rect.origin.x -= 10;
    return rect;
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    CGRect rect = [super textRectForBounds:bounds];
    rect.origin.x += _leftMargin;
    return rect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect rect = [super editingRectForBounds:bounds];
    rect.origin.x += _leftMargin;
    return rect;
}

@end
