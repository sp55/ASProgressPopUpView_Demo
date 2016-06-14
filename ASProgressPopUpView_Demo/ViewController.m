//
//  ViewController.m
//  ASProgressPopUpView_Demo
//
//  Created by admin on 16/6/14.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "ViewController.h"
#import "ASProgressPopUpView.h"

@interface ViewController ()<ASProgressPopUpViewDataSource>
@property (weak, nonatomic) IBOutlet ASProgressPopUpView *progressView1;
@property (weak, nonatomic) IBOutlet ASProgressPopUpView *progressView2;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *reStartBtn;

@end

@implementation ViewController
{
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView1.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
    self.progressView1.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
    self.progressView1.dataSource = self;
    
    self.progressView2.popUpViewCornerRadius = 12.0;
    self.progressView2.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:28];
}
//Switch
- (IBAction)toggleShowHide:(UISwitch *)sender {
    if (sender.on) {
        [self.progressView1 showPopUpViewAnimated:YES];
        [self.progressView2 showPopUpViewAnimated:YES];
    } else {
        [self.progressView1 hidePopUpViewAnimated:YES];
        [self.progressView2 hidePopUpViewAnimated:YES];
    }
}
//重置
- (IBAction)reStartProgress:(UIButton *)sender {
    
    self.startBtn.selected = NO;
    self.startBtn.enabled = YES;
    
    self.progressView1.progress = 0.0;
    self.progressView2.progress = 0.0;
}
//开始
- (IBAction)satrtProgress:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self progress];
}

#pragma mark - Timer

- (void)progress
{
    if (self.progressView1.progress >= 1.0) {
        self.startBtn.selected = NO;
        self.startBtn.enabled = NO;
    }
    
    float progress = self.progressView1.progress;
    if (self.startBtn.selected && progress < 1.0) {
        
        progress += self.reStartBtn.selected ? 0.005 : 0.1;
        
        [self.progressView1 setProgress:progress animated:!self.reStartBtn.selected];
        [self.progressView2 setProgress:progress animated:!self.reStartBtn.selected];
        
        [NSTimer scheduledTimerWithTimeInterval:self.reStartBtn.selected ? 0.05 : 0.5
                                         target:self
                                       selector:@selector(progress)
                                       userInfo:nil
                                        repeats:NO];
    }
}

#pragma mark - ASProgressPopUpView dataSource

// <ASProgressPopUpViewDataSource> is entirely optional
// it allows you to supply custom NSStrings to ASProgressPopUpView
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    if (progress < 0.2) {
        s = @"Just starting";
    } else if (progress > 0.4 && progress < 0.6) {
        s = @"About halfway";
    } else if (progress > 0.75 && progress < 1.0) {
        s = @"Nearly there";
    } else if (progress >= 1.0) {
        s = @"Complete";
    }
    return s;
}

// by default ASProgressPopUpView precalculates the largest popUpView size needed
// it then uses this size for all values and maintains a consistent size
// if you want the popUpView size to adapt as values change then return 'NO'
- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return NO;
}


@end
