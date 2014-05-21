//
//  HYProgressView.h
//  Delete
//
//  Created by Shadow on 14-5-20.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_GRADIENT_LEFT_COLOR [UIColor colorWithRed:0.122 green:0.616 blue:0.910 alpha:1.0]
#define DEFAULT_GRADIENT_RIGHT_COLOR [UIColor colorWithRed:0.702 green:0.784 blue:0.788 alpha:1.0]
#define DEFAULT_BG_COLOR [UIColor colorWithRed:0.702 green:0.784 blue:0.788 alpha:1.0]
#define DEFAULT_FORE_COLOR [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:1.0]

typedef NS_ENUM(NSUInteger, HYProgressViewType) {
    HYProgressViewTypeDefault = 0,           //普通类型
    HYProgressViewTypeRing = 1,             //环形
    HYProgressViewTypePie = 2,              //饼形, 无动画
    HYProgressViewTypePieWithBorder = 3,    //带边框的饼形, 无动画
};

@interface HYProgressView : UIView

/**
 进度条类型, 更改类型会导致某些属性重置, 所以请一次更改终生使用....
 */
@property (nonatomic, assign) HYProgressViewType type;

/**
 进度条背景颜色, 默认为DEFAULT_BG_COLOR.
 */
@property (nonatomic, strong) UIColor *bgColor;

/**
 进度条背景透明度, 默认为0.3.
 */
@property (nonatomic, assign) CGFloat bgOpacity;

/**
 进度条前景颜色(填充颜色), 默认为DEFAULT_FORE_COLOR, 与gradientColors互斥.
 */
@property (nonatomic, strong) UIColor *foreColor;

/**
 渐变颜色, 默认为nil, 与foreColor互斥(不支持HYProgressViewTypePieWithBorder).
 */
@property (nonatomic, strong) NSArray *gradientColors;

/**
 如果你对渐变色的分布不太满意, 可以自己修改里边的属性.
 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

/**
 进度条宽度, 默认为15.
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 进度条开始角度, 默认为130.
 */
@property (nonatomic, assign) CGFloat startAngle;

/**
 进度条结束角度, 默认为50.
 */
@property (nonatomic, assign) CGFloat endAngle;

/**
 进度条是否顺时针, 默认为YES.
 */
@property (nonatomic, assign) BOOL clockwise;

/**
 进度条进度, 取值范围0.0f - 1.0f, 默认为0.
 */
@property (nonatomic, assign) CGFloat progress;

/**
 在HYProgressViewTypePieWithBorder类型下的饼图与边框的间隔, 如果不是该类型则忽略该属性.
 */
@property (nonatomic, assign) CGFloat lineWidthOffset;

#pragma mark - 动画时间

/**
 动画时间, 默认为0.25s.
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 动画的时间曲线, 默认为[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault].
 */
@property (nonatomic, strong) CAMediaTimingFunction *animationTimingFunction;

#pragma mark - 初始化方法

/**
 使用该方法初始化, 使用正方形坐标.
 */
- (id)initWithFrame:(CGRect)frame;

@end
