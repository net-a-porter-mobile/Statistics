//
//  SBStatistics.m
//  Statistics
//
//  Created by Stig Brautaset on 10/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "SBStatistics.h"


@implementation SBStatistics

@synthesize count;
@synthesize mindex;
@synthesize maxdex;

@synthesize min;
@synthesize max;
@synthesize mean;

- (id)init
{
    if (self = [super init]) {
        count = 0;
        min = max = mean = pseudoVariance = nan(0);
    }
    return self;
}

- (void)addDataFromArray:(NSArray*)array
{
    for (id x in array)
        [self addData:x];
}

- (void)addData:(id)x
{
    NSAssert([x respondsToSelector:@selector(doubleValue)], @"Data must respond to -doubleValue");
    
    double d = [x doubleValue];

    if (!count) {
        max = -INFINITY;
        min = INFINITY;
        mean = pseudoVariance = 0;
    }
    
    if (d < min) {
        min = d;
        mindex = count;
    }
    if (d > max) {
        max = d;
        maxdex = count;
    }
    
    double oldMean = mean;
    mean += (d - oldMean) / ++count;
    pseudoVariance += (d - mean) * (d - oldMean);
}

- (double)range
{
    return max - min;
}

- (double)variance
{
    return pseudoVariance / (count - 1);
}

- (double)biasedVariance
{
    return pseudoVariance / count;    
}

- (double)standardDeviation
{
    return sqrt([self variance]);
}

- (double)biasedStandardDeviation
{
    return sqrt([self biasedVariance]);
}

@end
