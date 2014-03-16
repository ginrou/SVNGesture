#!/usr/bin/env python
#coding:utf-8

import sys
import argparse
import numpy as np

sys.path.append('./lib/libsvm-3.17/python')
from svm import *
from svmutil import *

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=str)
    parser.add_argument("model", type=str)
    args = parser.parse_args()

    model = svm_load_model(args.model)
    y, x = svm_read_problem( args.input )

    label, acc, val = svm_predict(y, x, model)
    print acc
