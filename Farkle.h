//
//  Farkle.h
//  Farkle
//
//  Created by Kern Jackson on 5/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Die.h"
#import "Singleton.h"

@interface Farkle : NSObject {
    NSNumber *score;
    NSNumber *total;
    NSNumber *subtotal; // ???
    NSNumber *farkles;
    NSNumber *turns;
    
    NSMutableArray *rolled;
    NSMutableArray *locked;
}

@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSNumber *total;
@property (nonatomic, retain) NSNumber *subtotal; // Do we need this?
@property (nonatomic, retain) NSNumber *farkles;
@property (nonatomic, retain) NSNumber *turns;

@property (nonatomic, retain) NSMutableArray *rolled;
@property (nonatomic, retain) NSMutableArray *locked;

+ (id)sharedManager;

@property (nonatomic) BOOL doubling;
@property (nonatomic) BOOL onesLow;


- (bool)diceHot;
- (NSArray *)sort:(NSMutableArray *)locked;
- (NSInteger)score:(NSArray *)locked;

- (void)rollDice;

@end
