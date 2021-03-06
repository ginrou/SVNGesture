//
//  TKDViewController.m
//  SVNGesture
//
//  Created by 武田 祐一 on 2014/03/02.
//  Copyright (c) 2014年 Yuichi Takeda. All rights reserved.
//

@import AudioToolbox;
@import AVFoundation;

#import "TKDViewController.h"
#import "TKDGestureRecorder.h"

#import "TKDLibSVMWrapper.h"

@interface TKDViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *frameCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) TKDGestureRecorder *recorder;
@property (assign, nonatomic) BOOL isRecording;

@property AVAudioPlayer *player;

@end

@implementation TKDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.recorder = [[TKDGestureRecorder alloc] init];
    self.isRecording = NO;
    [self updateUIElements];
    [self updateCounter];

    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"svm" ofType:@"model"];
    TKDLibSVMWrapper *wrapper = [[TKDLibSVMWrapper alloc] initWithFile:filepath];

    NSString *dataFile = [[NSBundle mainBundle] pathForResource:@"hadouken" ofType:@"txt"];
    NSString *dataStr = [NSString stringWithContentsOfFile:dataFile encoding:NSUTF8StringEncoding error:nil];

    NSMutableArray *vals = [NSMutableArray array];

    for (NSString *s in [dataStr componentsSeparatedByString:@" "]) {

        NSArray *indexAndValue = [s componentsSeparatedByString:@":"];
        if (indexAndValue.count == 2) {
            [vals addObject:indexAndValue[1]];
        }

    }

    BOOL isHadouken = [wrapper predict:vals];

    NSLog(@"isHadouken = %d", isHadouken);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUIElements
{
    self.statusLabel.text = self.recorder.stateTitle;

    if (self.isRecording) {
        [self.button setTitle:@"stop" forState:UIControlStateNormal];
    } else {
        [self.button setTitle:@"start" forState:UIControlStateNormal];
    }

}

- (void)updateCounter {
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

- (IBAction)hadoukenButtonTapped:(id)sender {
//    NSURL *hadoukenSoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"波動" ofType:@"wav"]];
//    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:hadoukenSoundURL error:nil];
//    [self.player play];

    [self.recorder startRecognizing];

}

@end
