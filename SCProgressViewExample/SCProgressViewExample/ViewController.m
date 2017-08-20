//
//  ViewController.m
//  SCProgressViewExample
//
//  Created by ShannonChen on 2017/8/20.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import "ViewController.h"
#import "SCProgressView.h"

@interface ViewController () <SCProgressViewDataSource>

@property (strong, nonatomic) SCProgressView *progressView;


@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.progressView = [[SCProgressView alloc] initWithFrame:CGRectMake(30, 100, self.view.bounds.size.width - 30 * 2, 5)];
    self.progressView.dataSource = self;
    self.progressView.showsPopUpview = YES;
    [self.view addSubview:self.progressView];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    _numberFormatter = formatter;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
   
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.progressView.progress = 0.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.progressView setProgress:1.0 animated:YES];
    });
}

#pragma mark - <SCProgressViewDataSource>
- (NSString *)progressView:(SCProgressView *)progressView stringForProgress:(float)progress {
    return [_numberFormatter stringFromNumber:@(progress)];
}



@end
