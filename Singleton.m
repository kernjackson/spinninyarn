//
//  Singleton.m
//  Singleton
//
//  Created by Kern Jackson on 11/8/13.
//  Copyright (c) 2013 Kern Jackson. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

// Farkle
@synthesize score;
@synthesize total;
@synthesize subtotal; 
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
        
        score = @0;
        total = @0;
        subtotal = @0;
        farkles = @0;
        turns = @12; // +1 for roll and +1 for 10-1
    }
    return self;
}

@end
