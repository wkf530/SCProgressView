//
//  SCProgressPopUpView.h
//  SCProgressPopUpView
//
//  Created by ShannonChen on 2017/8/14.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCProgressPopUpView : UIView

@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) CGFloat arrowHeight;
@property (strong, nonatomic) UIColor *fillColor;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *font;
@property (copy, nonatomic) NSString *text;

@property (assign, nonatomic) CGFloat leftRightPadding;
@property (assign, nonatomic) CGFloat topBottomPadding;


- (void)setFrame:(CGRect)frame arrowOffset:(CGFloat)arrowOffset colorOffset:(CGFloat)colorOffset text:(NSString *)text;
- (CGSize)popUpSizeForString:(NSString *)string;

@end
