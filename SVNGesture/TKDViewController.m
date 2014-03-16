//
//  TKDViewController.m
//  SVNGesture
//
//  Created by 武田 祐一 on 2014/03/02.
//  Copyright (c) 2014年 Yuichi Takeda. All rights reserved.
//

#import "TKDViewController.h"
#import "TKDGestureRecorder.h"

#import "TKDPushClient.h"

@interface TKDViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *frameCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) TKDGestureRecorder *recorder;
@property (assign, nonatomic) BOOL isRecording;

@end

@implementation TKDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.recorder = [[TKDGestureRecorder alloc] init];
    self.isRecording = NO;
    [self updateUIElements];
    [self updateCounter];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    TKDPushClient *pushClient = [[TKDPushClient alloc] init];
    [pushClient sentPushToMySelf];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUIElements
{
    self.statusLabel.text = self.recorder.stateTitle;
    self.frameCountLabel.text = [NSString stringWithFormat:@"%d", self.recorder.recordedCount];

    if (self.isRecording) {
        [self.button setTitle:@"stop" forState:UIControlStateNormal];
    } else {
        [self.button setTitle:@"start" forState:UIControlStateNormal];
    }

}

- (void)updateCounter {
    self.frameCountLabel.text = [NSString stringWithFormat:@"%d", self.recorder.recordedCount];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/30.0 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self updateCounter];
    });
}

- (IBAction)buttonTapped:(id)sender {

    if (self.isRecording) {
        [self.recorder stop];
        self.isRecording = NO;
        [self updateUIElements];
    } else {
        [self.recorder start];
        self.isRecording = YES;
        [self updateUIElements];
    }

}
- (IBAction)removeRecordButtonTapped:(id)sender {
    [self.recorder removeAllRecords];
}

@end
