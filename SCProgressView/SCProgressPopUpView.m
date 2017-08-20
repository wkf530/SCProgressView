//
//  SCProgressPopUpView.m
//  SCProgressPopUpView
//
//  Created by ShannonChen on 2017/8/14.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import "SCProgressPopUpView.h"

static NSString *const FillColorAnimation = @"fillColor";

@interface SCProgressPopUpView ()

@property (weak, nonatomic) CAShapeLayer *pathLayer;
@property (strong, nonatomic) CATextLayer *textLayer;
@property (strong, nonatomic) CAShapeLayer *colorAnimationLayer;

@property (assign, nonatomic) CGFloat arrowCenterOffset;

@property (strong, nonatomic) NSMutableAttributedString *attributedString;


@end

@implementation SCProgressPopUpView

@synthesize fillColor = _fillColor;

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pathLayer = (CAShapeLayer *)self.layer; // ivar can now be accessed without casting to CAShapeLayer every time
        
        _cornerRadius = 6.0;
        _arrowHeight = 8.0;
        _leftRightPadding = 5;
        _topBottomPadding = 5;
        _fillColor = [UIColor greenColor];
        
        _textLayer = [CATextLayer layer];
        _textLayer.alignmentMode = kCAAlignmentCenter;
        _textLayer.anchorPoint = CGPointMake(0, 0);
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        _textLayer.actions = @{@"contents" : [NSNull null]};
        [self.layer addSublayer:_textLayer];
        
        _colorAnimationLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_colorAnimationLayer];
        
        
        _attributedString = [[NSMutableAttributedString alloc] initWithString:@" " attributes:nil];
    }
    return self;
}

#pragma mark - Subclassed
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat textHeight = _attributedString.size.height;
    CGRect textRect = CGRectMake(self.bounds.origin.x,
                                 (self.bounds.size.height - _arrowHeight - textHeight)/2,
                                 self.bounds.size.width, textHeight);
    _textLayer.frame = CGRectIntegral(textRect);
}


#pragma mark - Public

- (void)setCornerRadius:(CGFloat)radius {
    if (_cornerRadius == radius) return;
    _cornerRadius = radius;
    _pathLayer.path = [self pathForRect:self.bounds withArrowOffset:_arrowCenterOffset].CGPath;
}


- (UIColor *)fillColor {
    return [UIColor colorWithCGColor:[_pathLayer.presentationLayer fillColor]];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    
    _pathLayer.fillColor = fillColor.CGColor;
    [_colorAnimationLayer removeAnimationForKey:FillColorAnimation]; // single color, no animation required
}

- (void)setText:(NSString *)string {
    _text = _text.copy;
    
    [_attributedString.mutableString setString:string];
    _textLayer.string = string;
}

- (void)setTextColor:(UIColor *)color {
    
    _textLayer.foregroundColor = color.CGColor;
}

- (void)setFont:(UIFont *)font {
    
    [_attributedString addAttribute:NSFontAttributeName
                              value:font
                              range:NSMakeRange(0, [_attributedString length])];
    
    _textLayer.font = (__bridge CFTypeRef)(font.fontName);
    _textLayer.fontSize = font.pointSize;
}


- (void)setFrame:(CGRect)frame arrowOffset:(CGFloat)arrowOffset colorOffset:(CGFloat)colorOffset text:(NSString *)text {
    
    // only redraw path if either the arrowOffset or popUpView size has changed
    if (arrowOffset != _arrowCenterOffset || !CGSizeEqualToSize(frame.size, self.frame.size)) {
        _pathLayer.path = [self pathForRect:frame withArrowOffset:arrowOffset].CGPath;
    }
    
    _arrowCenterOffset = arrowOffset;
    
    
    CGFloat anchorX = 0.5+(arrowOffset/CGRectGetWidth(frame));
    self.layer.anchorPoint = CGPointMake(anchorX, 1);
    self.layer.position = CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame)*anchorX, 0);
    self.layer.bounds = (CGRect){CGPointZero, frame.size};
    
    [self setText:text];
    
    if ([_colorAnimationLayer animationForKey:FillColorAnimation]) {
        _colorAnimationLayer.timeOffset = colorOffset;
        _pathLayer.fillColor = [_colorAnimationLayer.presentationLayer fillColor];
    }
}

- (CGSize)popUpSizeForString:(NSString *)string {
    
    [[_attributedString mutableString] setString:string];
    CGFloat w, h;
    w = ceilf([_attributedString size].width + 2 * self.leftRightPadding);
    h = ceilf(([_attributedString size].height + 2 * self.topBottomPadding) + self.arrowHeight);
    return CGSizeMake(w, h);
}


#pragma mark - Drawing 
- (UIBezierPath *)pathForRect:(CGRect)rect withArrowOffset:(CGFloat)arrowOffset {
    
    if (CGRectEqualToRect(rect, CGRectZero)) return nil;
    
    rect = (CGRect){CGPointZero, rect.size}; // ensure origin is CGPointZero
    
    // Create rounded rect
    CGRect roundedRect = rect;
    roundedRect.size.height -= _arrowHeight;
    UIBezierPath *popUpPath = [UIBezierPath bezierPathWithRoundedRect:roundedRect cornerRadius:_cornerRadius];
    
    // Create arrow path
    CGFloat maxX = CGRectGetMaxX(roundedRect); // prevent arrow from extending beyond this point
    CGFloat arrowTipX = CGRectGetMidX(rect) + arrowOffset;
    CGPoint tip = CGPointMake(arrowTipX, CGRectGetMaxY(rect));
    
    CGFloat arrowLength = CGRectGetHeight(roundedRect)/2.0;
    CGFloat x = arrowLength * tan(45.0 * M_PI/180); // x = half the length of the base of the arrow
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:tip];
    [arrowPath addLineToPoint:CGPointMake(MAX(arrowTipX - x, 0), CGRectGetMaxY(roundedRect) - arrowLength)];
    [arrowPath addLineToPoint:CGPointMake(MIN(arrowTipX + x, maxX), CGRectGetMaxY(roundedRect) - arrowLength)];
    [arrowPath closePath];
    
    [popUpPath appendPath:arrowPath];
    
    return popUpPath;
}


@end
