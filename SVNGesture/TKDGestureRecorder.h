//
//  TKDGestureRecorder.h
//  SVNGesture
//
//  Created by 武田 祐一 on 2014/03/02.
//  Copyright (c) 2014年 Yuichi Takeda. All rights reserved.
//

@import CoreMotion;

#import <Foundation/Foundation.h>

@interface TKDGestureRecorder : NSObject

@property (nonatomic, readonly) NSString *stateTitle;
@property (nonatomic, readonly) NSInteger recordedCount;

- (void)start;
- (void)stop;
- (void)removeAllRecords;

@end

@interface TKDGestureRecord : NSObject
@property (nonatomic, strong, readonly) NSDate *startDate;
@property (readonly) NSInteger count;
- (void)addRecord:(CMAcceleration)acceleration;
- (NSString *)finalize;
@end