//
//  PICircularProgressView.m
//  PICircularProgressView
//
//  Created by Dominik Alexander on 11.06.13.
//  Copyright (c) 2013 Dominik Alexander. All rights reserved.
//

#import "PICircularProgressView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation PICircularProgressView

+ (void)initialize
{
    if (self == [PICircularProgressView class])
    {
        id appearance = [self appearance];
        
        [appearance setShowText:YES];
        [appearance setRoundedHead:NO];
        [appearance setShowShadow:YES];
        
        [appearance setThicknessRatio:0.33f];
        
        [appearance setInnerBackgroundColor:nil];
        [appearance setOuterBackgroundColor:[UIColor colorWithRed:252/255.0 green:193/255.0 blue:161/255.0 alpha:1]];
        
        [appearance setTextColor:[UIColor blackColor]];
        [appearance setFont:[UIFont systemFontOfSize:10]];
        [appearance setProgressFillColor:nil];
        
        [appearance setProgressTopGradientColor:[UIColor colorWithRed:250.0/255.0 green:38.0/255.0 blue:114.0/255.0 alpha:1.0]];
        [appearance setProgressBottomGradientColor:[UIColor colorWithRed:128.0/255.0 green:9.0/255.0 blue:153.0/255.0 alpha:1.0]];
        
    }
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:tapGesture];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}
- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self addGestureRecognizer:tapGesture];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self addGestureRecognizer:panGesture];
    return self;
}
- (void)handleGesture:(UIGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self];
    if (CGRectContainsPoint(self.bounds, point)) {
        self.progress = [self angleFromStartToPoint:[recognizer locationInView:self]] / (2 * M_PI);
        [self setNeedsDisplay];
       
    }
}

//calculate angle between start to point
- (CGFloat)angleFromStartToPoint:(CGPoint)point{
    NSLog(@"point.x = %f,point.y = %f",point.x,point.y);
    NSLog(@"self.bounds.size.width = %f,self.bounds.size.height = %f",self.bounds.size.width,self.bounds.size.height);
    CGFloat angle = [self angleBetweenLinesWithLine1Start:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2) Line1End:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2 - 1) Line2Start:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2) Line2End:point];
    if (CGRectContainsPoint(CGRectMake(0, 0, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)), point)) {
        angle = 2 * M_PI - angle;
    }
    return angle;
}
//calculate angle between 2 lines
- (CGFloat)angleBetweenLinesWithLine1Start:(CGPoint)line1Start
                                  Line1End:(CGPoint)line1End
                                Line2Start:(CGPoint)line2Start
                                  Line2End:(CGPoint)line2End{
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    return acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Calculate position of the circle
    CGFloat progressAngle = _progress * 360.0 - 180;
    //中心点
    CGPoint center = CGPointMake(rect.size.width / 2.0f, rect.size.height / 2.0f);
    //半径
    CGFloat radius = MIN(rect.size.width, rect.size.height) / 2.0f;
    
    //确定整个圆环的四方形的大小
    CGRect square;
    if (rect.size.width > rect.size.height)
    {
        square = CGRectMake((rect.size.width - rect.size.height) / 2.0, 0.0, rect.size.height, rect.size.height);
    }
    else
    {
        square = CGRectMake(0.0, (rect.size.height - rect.size.width) / 2.0, rect.size.width, rect.size.width);
    }
    
    
    //两个圆环之间的距离
    CGFloat circleWidth = radius * _thicknessRatio;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    //如果内圆的颜色不为空，就以这种颜色进行填充
    if (_innerBackgroundColor)
    {
        // Fill innerCircle with innerBackgroundColor
        UIBezierPath *innerCircle = [UIBezierPath bezierPathWithArcCenter:center
                                                                   radius:radius - circleWidth
                                                               startAngle:2*M_PI
                                                                 endAngle:0.0
                                                                clockwise:YES];
        
        [_innerBackgroundColor setFill];
        
        [innerCircle fill];
    }
    
    //如果外环的颜色不为空的话，就以这种颜色进行填充
    if (_outerBackgroundColor)
    {
        // Fill outerCircle with outerBackgroundColor
        UIBezierPath *outerCircle = [UIBezierPath bezierPathWithArcCenter:center
                                                              radius:radius
                                                          startAngle:0.0
                                                            endAngle:2*M_PI
                                                           clockwise:NO];
        [outerCircle addArcWithCenter:center
                               radius:radius - circleWidth
                           startAngle:2*M_PI
                             endAngle:0.0
                            clockwise:YES];
        
        [_outerBackgroundColor setFill];
        
        [outerCircle fill];
    }
    
    if (_showShadow)
    {
        // Draw shadows
        CGFloat locations[5] = { 0.0f, 0.33f, 0.66f, 1.0f };
        NSArray *gradientColors = @[
                                    (id)[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor],
                                    (id)[[UIColor colorWithWhite:0.9 alpha:0.0] CGColor],
                                    (id)[[UIColor colorWithWhite:0.9 alpha:0.0] CGColor],
                                    (id)[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor],
                                    ];
        
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(rgb, (__bridge CFArrayRef)gradientColors, locations);
        CGContextDrawRadialGradient(context, gradient, center, radius - circleWidth, center, radius, 0);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(rgb);
    }
    
    if (_showText && _textColor)
    {
        NSString *progressString = [NSString stringWithFormat:@"%.0f%@", _progress * 100.0,@"%"];
       
        
        CGFloat fontSize = radius;
        UIFont *font = [_font fontWithSize:fontSize];
        
        CGFloat diagonal = 2 * (radius - circleWidth);
        CGFloat edge = diagonal / sqrtf(2);
        
        CGFloat actualFontSize;
        CGSize maximumSize = CGSizeMake(edge, edge);
        CGSize expectedSize = [progressString sizeWithFont:font
                                               minFontSize:5.0
                                            actualFontSize:&actualFontSize
                                                  forWidth:maximumSize.width
                                             lineBreakMode:NSLineBreakByWordWrapping];
        
        if (actualFontSize < fontSize)
        {
            font = [font fontWithSize:actualFontSize];
            expectedSize = [progressString sizeWithFont:font
                                            minFontSize:5.0
                                         actualFontSize:&actualFontSize
                                               forWidth:maximumSize.width
                                          lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        CGPoint origin = CGPointMake(center.x - expectedSize.width / 2.0, center.y - expectedSize.height / 2.0);

        [_textColor setFill];
        
        [progressString drawAtPoint:origin forWidth:expectedSize.width withFont:font lineBreakMode:NSLineBreakByWordWrapping];
         NSLog(@"progressString = %@",progressString);
        NSArray * array = [progressString componentsSeparatedByString:@"%"];
        NSString * size = [array objectAtIndex:0];
        if (size.length == 1) {
            size = [NSString stringWithFormat:@"0%@",size];
        }
        if ([self.delegate respondsToSelector:@selector(getProgressSize:)]) {
            [self.delegate getProgressSize:size];
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center
                                                    radius:radius
                                                startAngle:(CGFloat) - M_PI_2
                                                  endAngle:(CGFloat)(- M_PI_2 + self.progress * 2 * M_PI)
                                                 clockwise:YES]];
    
        [path addArcWithCenter:center
                    radius:radius-circleWidth
                startAngle:(CGFloat)(- M_PI_2 + self.progress * 2 * M_PI)
                  endAngle:(CGFloat) - M_PI_2
                 clockwise:NO];
    
       [path closePath];
    
   if (_progressTopGradientColor && _progressBottomGradientColor)
    {
        [path addClip];
        
        NSArray *backgroundColors = @[
                                      (id)[_progressTopGradientColor CGColor],
                                      (id)[_progressBottomGradientColor CGColor],
                                      ];
        CGFloat backgroudColorLocations[2] = { 0.0f, 1.0f };
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGGradientRef backgroundGradient = CGGradientCreateWithColors(rgb, (__bridge CFArrayRef)(backgroundColors), backgroudColorLocations);
        CGContextDrawLinearGradient(context,
                                    backgroundGradient,
                                    CGPointMake(0.0f, square.origin.y),
                                    CGPointMake(0.0f, square.size.height),
                                    0);
        CGGradientRelease(backgroundGradient);
        CGColorSpaceRelease(rgb);
    }
    
    CGContextRestoreGState(context);
}

#pragma mark - Setter

- (void)setProgress:(double)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

#pragma mark - UIAppearance

- (void)setShowText:(NSInteger)showText
{
    _showText = showText;
    
    [self setNeedsDisplay];
}

- (void)setRoundedHead:(NSInteger)roundedHead
{
    _roundedHead = roundedHead;
    
    [self setNeedsDisplay];
}

- (void)setShowShadow:(NSInteger)showShadow
{
    _showShadow = showShadow;
    
    [self setNeedsDisplay];
}

- (void)setThicknessRatio:(CGFloat)thickness
{
    _thicknessRatio = MIN(MAX(0.0f, thickness), 1.0f);
    
    [self setNeedsDisplay];
}

- (void)setInnerBackgroundColor:(UIColor *)innerBackgroundColor
{
    _innerBackgroundColor = innerBackgroundColor;
    
    [self setNeedsDisplay];
}

- (void)setOuterBackgroundColor:(UIColor *)outerBackgroundColor
{
    _outerBackgroundColor = outerBackgroundColor;
    
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    [self setNeedsDisplay];
}

- (void)setProgressFillColor:(UIColor *)progressFillColor
{
    _progressFillColor = progressFillColor;
    
    [self setNeedsDisplay];
}

- (void)setProgressTopGradientColor:(UIColor *)progressTopGradientColor
{
    _progressTopGradientColor = progressTopGradientColor;
    
    [self setNeedsDisplay];
}

- (void)setProgressBottomGradientColor:(UIColor *)progressBottomGradientColor
{
    _progressBottomGradientColor = progressBottomGradientColor;
    
    [self setNeedsDisplay];
}

@end
