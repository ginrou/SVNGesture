//
//  TKDGestureRecorder.m
//  SVNGesture
//
//  Created by 武田 祐一 on 2014/03/02.
//  Copyright (c) 2014年 Yuichi Takeda. All rights reserved.
//

@import AVFoundation;

#import "TKDGestureRecorder.h"
#import "TKDLibSVMWrapper.h"

@interface TKDGestureRecorder ()
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSOperationQueue *motionManagerQueue;

@property (strong, nonatomic) TKDGestureRecord *currentRecord;
@property (strong, nonatomic) TKDLibSVMWrapper *svmWrapper;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) AVAudioPlayer *player;
@end

@implementation TKDGestureRecorder

- (instancetype)init
{
    self = [super init];
    if (self) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 1.0 / 30.0; // [sec]
        _motionManagerQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (NSString *)stateTitle {
    return self.currentRecord ? @"Recording" : @"Idle";
}

- (NSInteger)recordedCount {
    return self.currentRecord.count;
}

- (void)start
{
    if (self.currentRecord != nil) return;

    self.currentRecord = [[TKDGestureRecord alloc] init];

    [self.motionManager startAccelerometerUpdatesToQueue:self.motionManagerQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {

        if (accelerometerData && error == nil) {
            [self.currentRecord addRecord:accelerometerData.acceleration];
        }

    }];

}

- (void)stop {
    if (self.currentRecord == nil) return;

    [self.motionManager stopAccelerometerUpdates];
    NSString *recordString = [self.currentRecord finalize];
    NSInteger timestamp = [self.currentRecord.startDate timeIntervalSince1970];
    NSString *filename = [NSString stringWithFormat:@"%ld.txt", (long)timestamp];
    self.currentRecord = nil;

    [self writeRecord:recordString toFile:filename];
}

- (void)writeRecord:(NSString *)record toFile:(NSString *)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSURL *documentDirectory = [fileManager URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask][0];
    NSString *filePathString = [documentDirectory.absoluteString
                                stringByAppendingPathComponent:filename];
    NSURL *filePath = [NSURL URLWithString:filePathString];

    [record writeToURL:filePath atomically:YES encoding:NSASCIIStringEncoding error:nil];
}

- (void)removeAllRecords {
    if (self.currentRecord != nil) return;

    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSURL *documentDirectory = [fileManager URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask][0];
    NSArray *files = [fileManager contentsOfDirectoryAtURL:documentDirectory includingPropertiesForKeys:@[NSURLFileResourceTypeKey] options:0 error:nil];
    for (NSURL *file in files) {
        [fileManager removeItemAtURL:file error:nil];
    }

}

- (void)startRecognizing {

    NSString *modelFile = [[NSBundle mainBundle] pathForResource:@"svm" ofType:@"model"];
    self.svmWrapper = [[TKDLibSVMWrapper alloc] initWithFile:modelFile];
    self.array = [NSMutableArray array];

    [self.motionManager startAccelerometerUpdatesToQueue:self.motionManagerQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {

        [self appendData:accelerometerData.acceleration];

    }];

}

- (void)appendData:(CMAcceleration)acceleration {

    [self.array addObject:@(acceleration.x)];
    [self.array addObject:@(acceleration.y)];
    [self.array addObject:@(acceleration.z)];

    if (self.array.count > 27) {

        [self.array removeObjectAtIndex:0];
        [self.array removeObjectAtIndex:0];
        [self.array removeObjectAtIndex:0];

    }

    if (self.array.count == 27) {

        BOOL isHadouken = [self.svmWrapper predict:self.array];
        if (isHadouken) {
            [self foundHadouken];
        }

    }

}

- (void)foundHadouken {

    NSLog(@"yes this is hadouken!!!");

    NSURL *hadoukenSoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"波動" ofType:@"wav"]];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:hadoukenSoundURL error:nil];
    [self.player play];


}


@end


@interface TKDGestureRecord ()
@property (nonatomic, strong) NSMutableArray *lines;
@end

@implementation TKDGestureRecord
- (instancetype)init {
    if (self = [super init]) {
        _lines = [NSMutableArray array];
        _startDate = [NSDate date];
    }
    return self;
}

- (void)addRecord:(CMAcceleration)acceleration {
    NSString *line = [NSString stringWithFormat:@"%lu, %f, %f, %f", (unsigned long)self.lines.count, acceleration.x, acceleration.y, acceleration.z];
    [self.lines addObject:line];
    NSLog(@"%@" , line);
}

- (NSString *)finalize {
    NSMutableString *buf = [NSMutableString string];
    for (NSString *line in self.lines) {
        [buf appendFormat:@"%@\n", line];
    }
    return buf;
}

@end
