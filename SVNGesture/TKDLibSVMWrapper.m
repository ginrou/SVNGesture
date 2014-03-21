//
//  TKDLibSVMWrapper.m
//  SVNGesture
//
//  Created by 武田 祐一 on 2014/03/21.
//  Copyright (c) 2014年 Yuichi Takeda. All rights reserved.
//

#import "TKDLibSVMWrapper.h"

#include "svm.h"

@interface TKDLibSVMWrapper ()
@property (assign) struct svm_model* model;
@end

@implementation TKDLibSVMWrapper

- (instancetype)initWithFile:(NSString *)filepath {

    self = [super init];
    if (self) {

        const char *filename = [filepath cStringUsingEncoding:NSUTF8StringEncoding];
        _model = svm_load_model(filename);

    }

    return self;
}

- (void)dealloc {
    svm_free_and_destroy_model(&_model);
}

- (BOOL)predict:(NSArray *)vector {

    int size = vector.count;
    struct svm_node *node = malloc(sizeof(struct svm_node) * (size+1));
    for (int i = 0 ; i < size; ++i) {
        NSNumber *num = vector[i];
        node[i].value = [num doubleValue];
        node[i].index = i+1;
        NSLog(@"%lf", node[i].value);
    }

    node[size].index = -1;

    double v = svm_predict(_model, node);

    free(node);

    NSLog(@"predicted = %lf", v);

    return v > 0;
}

@end
