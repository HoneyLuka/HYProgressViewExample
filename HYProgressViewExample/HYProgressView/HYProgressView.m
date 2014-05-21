//
//  HYProgressView.m
//  Delete
//
//  Created by Shadow on 14-5-20.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "HYProgressView.h"

#define DEGREE(a) 2*M_PI/360*a
//degreesToRadians(x) (M_PI*(x)/180.0)

@interface HYProgressView ()

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation HYProgressView

#pragma mark - 初始化方法

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupDefaultValues];
        [self setupLayers];
        [self updateLayers];
    }
    return self;
}

- (void)setupDefaultValues
{
    _type = HYProgressViewTypeDefault;
    _bgColor = DEFAULT_BG_COLOR;
    _foreColor = DEFAULT_FORE_COLOR;
    _gradientColors = nil;
    _bgOpacity = 0.3f;
    _lineWidth = 15.f;
    _startAngle = 130;
    _endAngle = 50;
    _clockwise = YES;
    _animationDuration = 0.25f;
    _animationTimingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
}

- (void)setupLayers
{
    self.bgLayer = [[CAShapeLayer alloc]init];
    self.bgLayer.fillColor = [UIColor clearColor].CGColor;
    self.bgLayer.strokeColor = self.bgColor.CGColor;
    self.bgLayer.opacity = self.bgOpacity;
    self.bgLayer.lineCap = kCALineCapRound;
    self.bgLayer.frame = self.bounds;
    [self.layer addSublayer:self.bgLayer];
    
    self.progressLayer = [[CAShapeLayer alloc]init];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = self.foreColor.CGColor;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.frame = self.bounds;
    self.progressLayer.fillRule = kCAFillRuleEvenOdd;
    [self.layer addSublayer:self.progressLayer];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(0.9, 0.5);
    [self.layer addSublayer:self.gradientLayer];
    self.gradientLayer.hidden = YES;
}

#pragma mark - 更新方法

- (void)clean
{
    self.bgLayer.fillColor = nil;
    self.bgLayer.strokeColor = nil;
    self.progressLayer.fillColor = nil;
    self.progressLayer.strokeColor = nil;
}

- (void)updateLayersForDefaultAndRing
{
    [self clean];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    UIBezierPath *layerPath = [UIBezierPath bezierPathWithArcCenter:center
                                                             radius:CGRectGetWidth(self.bounds)/2-self.lineWidth
                                                         startAngle:DEGREE(self.startAngle)
                                                           endAngle:DEGREE(self.endAngle)
                                                          clockwise:self.clockwise];
    CGPathRef path = CGPathCreateMutableCopy(layerPath.CGPath);
    self.bgLayer.path = layerPath.CGPath;
    self.progressLayer.path = path;
    CGPathRelease(path);
    
    self.bgLayer.lineWidth = self.lineWidth;
    self.progressLayer.lineWidth = self.lineWidth;
    
    self.bgLayer.opacity = self.bgOpacity;
    
    self.bgLayer.strokeColor = self.bgColor.CGColor;
    
    if (self.foreColor) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.gradientLayer.hidden = YES;
        self.gradientLayer.mask = nil;
        [CATransaction commit];
        
        [self.layer addSublayer:self.progressLayer];
        self.progressLayer.strokeColor = self.foreColor.CGColor;
        
    } else if (self.gradientColors) {
        //不给strokeColor设置值的话就没办法显示出来gradientLayer的颜色.
        self.progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        NSMutableArray *colorArr = [@[]mutableCopy];
        for (UIColor *color in self.gradientColors) {
            [colorArr addObject:(id)color.CGColor];
        }
        self.gradientLayer.colors = colorArr;
        self.gradientLayer.mask = self.progressLayer;
        self.gradientLayer.hidden = NO;
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:self.animationDuration];
    [CATransaction setAnimationTimingFunction:self.animationTimingFunction];
    self.progressLayer.strokeEnd = self.progress;
    [CATransaction commit];
}

- (void)updateLayersForPie
{
    [self clean];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    UIBezierPath *layerPath = [UIBezierPath bezierPathWithArcCenter:center
                                                             radius:CGRectGetWidth(self.bounds)/2-self.lineWidth
                                                         startAngle:DEGREE(self.startAngle)
                                                           endAngle:DEGREE(self.endAngle)
                                                          clockwise:self.clockwise];
    self.bgLayer.path = layerPath.CGPath;
    
    layerPath = [UIBezierPath bezierPathWithArcCenter:center
                                               radius:CGRectGetWidth(self.bounds)/2-self.lineWidth
                                           startAngle:DEGREE(self.startAngle)
                                             endAngle:DEGREE(self.startAngle)+DEGREE(360)*self.progress
                                            clockwise:self.clockwise];
    [layerPath addLineToPoint:center];
    [layerPath closePath];
    self.progressLayer.path = layerPath.CGPath;
    
    self.bgLayer.lineWidth = self.lineWidth;
    self.progressLayer.lineWidth = self.lineWidth;
    
    self.bgLayer.opacity = self.bgOpacity;
    
    self.bgLayer.fillColor = self.bgColor.CGColor;
    
    if (self.foreColor) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.gradientLayer.hidden = YES;
        self.gradientLayer.mask = nil;
        [CATransaction commit];
        
        [self.layer addSublayer:self.progressLayer];
        self.progressLayer.fillColor = self.foreColor.CGColor;
    } else if (self.gradientColors) {
        //不给fillColor设置值的话就没办法显示出来gradientLayer的颜色.
        self.progressLayer.fillColor = [UIColor whiteColor].CGColor;
        
        NSMutableArray *colorArr = [@[]mutableCopy];
        for (UIColor *color in self.gradientColors) {
            [colorArr addObject:(id)color.CGColor];
        }
        self.gradientLayer.colors = colorArr;
        self.gradientLayer.mask = self.progressLayer;
        self.gradientLayer.hidden = NO;
    }
    self.progressLayer.strokeEnd = self.progress;
}

- (void)updateLayersForPieWithBorder
{
    [self clean];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    UIBezierPath *layerPath = [UIBezierPath bezierPathWithArcCenter:center
                                                             radius:CGRectGetWidth(self.bounds)/2-self.lineWidth
                                                         startAngle:DEGREE(self.startAngle)
                                                           endAngle:DEGREE(self.endAngle)
                                                          clockwise:self.clockwise];
    self.bgLayer.path = layerPath.CGPath;
    
    layerPath = [UIBezierPath bezierPathWithArcCenter:center
                                               radius:CGRectGetWidth(self.bounds)/2-self.lineWidth-self.lineWidthOffset
                                           startAngle:DEGREE(self.startAngle)
                                             endAngle:DEGREE(self.startAngle)+DEGREE(360)*self.progress
                                            clockwise:self.clockwise];
    [layerPath addLineToPoint:center];
    [layerPath closePath];
    self.progressLayer.path = layerPath.CGPath;
    
    self.bgLayer.lineWidth = self.lineWidth;
    self.progressLayer.lineWidth = self.lineWidth;
    
    self.bgLayer.opacity = self.bgOpacity;
    
    self.bgLayer.fillColor = self.bgColor.CGColor;
    self.bgLayer.strokeColor = self.foreColor.CGColor;
    
    self.progressLayer.fillColor = self.foreColor.CGColor;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.gradientLayer.hidden = YES;
    self.gradientLayer.mask = nil;
    [CATransaction commit];
    
    [self.layer addSublayer:self.progressLayer];
    
    self.progressLayer.strokeEnd = self.progress;
}

- (void)updateLayers
{
    if (self.type == HYProgressViewTypeDefault) {
        [self updateLayersForDefaultAndRing];
    } else if (self.type == HYProgressViewTypeRing) {
        [self updateLayersForDefaultAndRing];
    } else if (self.type == HYProgressViewTypePie) {
        [self updateLayersForPie];
    } else if (self.type == HYProgressViewTypePieWithBorder) {
        [self updateLayersForPieWithBorder];
    }
}

- (void)updateType
{
    if (self.type == HYProgressViewTypeDefault) {
        [self setupDefaultValues];
        [self updateLayers];
    } else if (self.type == HYProgressViewTypeRing) {
        _lineWidth = 2.f;
        _startAngle = -90;
        _endAngle = -90+360;
        [self updateLayers];
    } else if (self.type == HYProgressViewTypePie) {
        _lineWidth = 2.f;
        _startAngle = -90;
        _endAngle = -90+360;
        [self updateLayers];
    } else if (self.type == HYProgressViewTypePieWithBorder) {
        _lineWidthOffset = 2.f;
        _bgOpacity = 1.f;
        _lineWidth = 2.f;
        _gradientColors = nil;
        if (!_foreColor) {
            _foreColor = DEFAULT_FORE_COLOR;
        }
        _startAngle = -90;
        _endAngle = -90+360;
        [self updateLayers];
    }
}

#pragma mark - setter

- (void)setType:(HYProgressViewType)type
{
    _type = type;
    [self updateType];
}

- (void)setLineWidthOffset:(CGFloat)lineWidthOffset
{
    _lineWidthOffset = lineWidthOffset;
    if (self.type == HYProgressViewTypePieWithBorder) {
        [self updateLayers];
    }
}

- (void)setClockwise:(BOOL)clockwise
{
    _clockwise = clockwise;
    [self updateLayers];
}

- (void)setEndAngle:(CGFloat)endAngle
{
    _endAngle = endAngle;
    [self updateLayers];
}

- (void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle;
    [self updateLayers];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self updateLayers];
}

- (void)setGradientColors:(NSArray *)gradientColors
{
    _gradientColors = gradientColors;
    _foreColor = nil;
    
    [self updateLayers];
}

- (void)setForeColor:(UIColor *)foreColor
{
    _foreColor = foreColor;
    _gradientColors = nil;
    
    [self updateLayers];
}

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    [self updateLayers];
}

- (void)setProgress:(CGFloat)progress
{
    if (progress < 0) {
        _progress = 0;
    } else if (progress > 1) {
        _progress = 1;
    } else {
        _progress = progress;
    }
    
    [self updateLayers];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
