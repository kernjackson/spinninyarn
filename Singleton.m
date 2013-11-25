//
//  Singleton.m
//  Singleton
//
//  Created by Kern Jackson on 11/8/13.
//  Copyright (c) 2013 Kern Jackson. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

@synthesize someProperty;

// Farkle
@synthesize score;
@synthesize total;
@synthesize subTotal;
@synthesize farkles;
@synthesize turns;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static Singleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (id)init {
    if (self = [super init]) {

        someProperty = @"someProperty";
        
        score = @0;
        total = @0;
        subTotal = @0;
        farkles = @0;
        turns = @0;
    }
    return self;
}

@end
