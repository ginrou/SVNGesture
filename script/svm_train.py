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
    parser.add_argument("-o", "--outfile", default="svm.model")
    args = parser.parse_args()

    y, x = svm_read_problem( args.input )
    model = svm_train(y,x)
    print len(model.get_SV())
    svm_save_model( args.outfile, model )
