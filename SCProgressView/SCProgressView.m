//
//  SCProgressView.m
//  SCProgressPopUpView
//
//  Created by ShannonChen on 2017/8/20.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import "SCProgressView.h"
#import "SCProgressPopUpView.h"

@interface SCProgressView ()

@property (strong, nonatomic) CALayer *progressLayer;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (strong, nonatomic) SCProgressPopUpView *popUpView;

@property (assign, nonatomic) float animationTargetProgress;

@end

@implementation SCProgressView

- (void)dealloc {
    
}


#pragma mark - initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    _progressLayer = [CALayer layer];
    _progressLayer.masksToBounds = YES;
    [self.layer addSublayer:_progressLayer];
    
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor yellowColor].CGColor];
    _gradientLayer.locations = @[@(0), @(1)];
    _gradientLayer.startPoint = CGPointZero;
    _gradientLayer.endPoint = CGPointMake(1, 0);
    [_progressLayer addSublayer:_gradientLayer];
    
    _popUpView = [[SCProgressPopUpView alloc] initWithFrame:CGRectZero];
    _popUpView.fillColor = [UIColor colorWithRed:217/255.0 green:169/255.0 blue:97/255.0 alpha:1.0];
//    _popUpView.alpha = 0.0;
    [self addSubview:_popUpView];
    
    self.backgroundColor = [UIColor lightGrayColor];
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:20];
    
    self.progress = 0;
}


#pragma mark - Public
- (void)setProgress:(float)progress {
    _progress = MAX(0.0, MIN(progress, 1.0)); // ensure that progress always 0.0 ~ 1.0
    
    [self updateProgressLayer];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    
    
    if (animated) {
        
        self.animationTargetProgress = progress;
        [self progressAnimated];
        
    } else {
        
        self.progress = progress;
    }
}

- (void)setTextColor:(UIColor *)color {
    _textColor = color;
    [self.popUpView setTextColor:color];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    [self.popUpView setFont:font];
}


#pragma mark - subclassed

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateProgressLayer];
    if (self.showsPopUpview) {
        [self updatePopUpView];
    }
    
}



#pragma mark - Private
- (void)progressAnimated {
    
    if (self.progress < self.animationTargetProgress) {
        
        self.progress += 0.01;
        
        [NSTimer scheduledTimerWithTimeInterval:0.01
                                         target:self
                                       selector:@selector(progressAnimated)
                                       userInfo:nil
                                        repeats:NO];
    }
}


- (void)updateProgressLayer {
    NSLog(@"============%g", self.bounds.size.width * self.progress);
    _gradientLayer.frame = self.bounds;
    _progressLayer.frame = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
}


- (void)updatePopUpView {
    
    
    NSString *progressString = [self.dataSource progressView:self stringForProgress:self.progress];
    if (progressString.length == 0) progressString = @"???"; // replacement for blank string
    
    CGSize popUpViewSize = [self.popUpView popUpSizeForString:progressString];
    
    // 计算 popUpView 的 frame
    CGRect bounds = self.bounds;
    CGFloat xPos = (CGRectGetWidth(bounds) * self.progress) - popUpViewSize.width/2;
    
    CGRect popUpRect = CGRectMake(xPos, CGRectGetMinY(bounds)-popUpViewSize.height,
                                  popUpViewSize.width, popUpViewSize.height);
    
    // 检测 popUpRect 是否超出 progress view 的边界
    CGFloat minOffsetX = CGRectGetMinX(popUpRect);                              // 距离最左边边界的距离
    CGFloat maxOffsetX = CGRectGetMaxX(popUpRect) - CGRectGetWidth(bounds);     // 距离最右边边界的距离
    
    CGFloat arrowOffset = minOffsetX < 0.0 ? minOffsetX : (maxOffsetX > 0.0 ? maxOffsetX : 0.0);
    popUpRect.origin.x -= arrowOffset;
    
    NSLog(@"----------%g", CGRectGetWidth(bounds) * self.progress);
    [self.popUpView setFrame:popUpRect arrowOffset:arrowOffset colorOffset:self.progress text:progressString];
    
}

@end
