//
//  SCProgressView.h
//  SCProgressPopUpView
//
//  Created by ShannonChen on 2017/8/20.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCProgressView;

// to supply custom text to the popUpView label, implement <ASProgressPopUpViewDataSource>
// the dataSource will be messaged each time the progress changes
@protocol SCProgressViewDataSource <NSObject>

- (NSString *)progressView:(SCProgressView *)progressView stringForProgress:(float)progress;


@end


@interface SCProgressView : UIView

@property (assign, nonatomic) float progress;

@property (weak, nonatomic) id <SCProgressViewDataSource> dataSource;
@property (assign, nonatomic) BOOL showsPopUpview;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *font;


- (void)setProgress:(float)progress animated:(BOOL)animated;



@end
