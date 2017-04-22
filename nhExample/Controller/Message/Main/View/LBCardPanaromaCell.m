//
//  LBCardPanaromaCell.m
//  nhExample
//
//  Created by liubin on 17/4/21.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "LBCardPanaromaCell.h"
#import "LBHeroModel.h"
@interface LBCardPanaromaCell()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation LBCardPanaromaCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

-(void)setModel:(id)model{
    if (model && [model isKindOfClass:[LBHeroModel class]]) {
        LBHeroModel *heroModel = (LBHeroModel *)model;
        self.imageView.image = ImageNamed(heroModel.imageName);
        [self.contentView sendSubviewToBack:self.bgView];
    }
    
}

-(void)layoutSubviews{
    self.bgView.frame = self.bounds;
    self.imageView.frame = self.bounds;
}

-(void)config{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.imageView = [[UIImageView alloc] init];
        self.imageView.layerCornerRadius = 10;
        [self.contentView addSubview:_imageView];
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.cornerRadius = 10;
        self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.bgView.layer.shadowOpacity = 0.8;
        self.bgView.layer.shadowRadius = 6.0f;
        self.bgView.layer.shadowOffset = CGSizeMake(6, 6);
        [self.contentView addSubview:_bgView];
    });
}

@end
