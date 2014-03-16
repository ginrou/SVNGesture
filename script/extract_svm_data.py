#!/usr/bin/env python
#coding:utf-8

import sys
import argparse
import numpy as np

sys.path.append('./lib/libsvm-3.17/python')
from svm import *

import matplotlib.pyplot as plt

def get_unmatched_ranges(matched_range, step, max_size, peak_col):
    ranges = [ range(a,a+step) for a in range(max_size-step) if a % (step/2) == 0 ]
    return [ r for r in ranges if not  peak_col in r ]

def string_libsvm_formatted( label, data ):
    lists = [ "%s:%s" %(i+1, v) for i, v in enumerate(data) ]
    return "%s %s\n" %( label, ' '.join(lists))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=str)
    parser.add_argument("-o", "--outfile", type=str, default="training_data.txt")
    parser.add_argument("-s", "--samples", type=int)
    parser.add_argument("-img", "--image", type=str)
    args = parser.parse_args()

    if args.samples % 3 != 0 :
        print "required :: samples % 3 == 0, aborting..."
        exit(-1)

    raw_data = np.loadtxt(args.input, delimiter=", ")[:,1:4] ## 0列目は連番

    ## 引数にimageがあったら保存する
    if args.image:
        plt.plot( np.sum( np.abs( raw_data**2 ), axis = -1 ) )
        [ plt.plot( raw_data[:,i] ) for i in range(3) ]
        plt.savefig(args.image)

    ## x,y,z のノルムが最大の箇所を抜き出す
    peak_col = np.argmax( np.sum( np.abs( raw_data**2 ), axis = -1 ) )

    ## データの分類:ピークの両脇は正解のレンジ
    step = args.samples/3
    matched_range = range( peak_col - step/2, peak_col + step/2+1 )
    matched_data = raw_data[ matched_range, : ]

    ## データの分類:不正解のレンジはそれ以外の箇所
    unmatched_ranges = get_unmatched_ranges( matched_range, step, raw_data.shape[0], peak_col )
    unmatched_data = [ raw_data[ r,: ] for r in unmatched_ranges ] 

    file = open(args.outfile, "a")

    file.write( string_libsvm_formatted( "1", matched_data.flatten() ) )
    for data in unmatched_data:
        file.write( string_libsvm_formatted( "-1", data.flatten() ) )

    file.close()
