//
//  TKDLibSVMWrapper.h
//  SVNGesture
//
//  Created by 武田 祐一 on 2014/03/21.
//  Copyright (c) 2014年 Yuichi Takeda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKDLibSVMWrapper : NSObject
- (instancetype)initWithFile:(NSString *)filepath;
- (BOOL)predict:(NSArray *)vector;
@end
