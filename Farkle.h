//
//  Farkle.h
//  Farkle
//
//  Created by Kern Jackson on 5/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Die.h"

@interface Farkle : NSObject {
    NSNumber *rolledPoints;
    NSNumber *lockedPoints;
    NSNumber *scoredPoints;
    NSNumber *totalPoints;
    
    
    
     // ???
    NSNumber *memory;  // ???
    NSNumber *farkles;
   //BOOL farkled; // There's got to be a better way to do this ???
    NSNumber *turns;
    
//    NSMutableArray *rolled;
//    NSMutableArray *locked;
}

@property(nonatomic,assign) NSInteger test;

@property (nonatomic, retain) NSNumber *rolledPoints;
@property (nonatomic, retain) NSNumber *lockedPoints;
@property (nonatomic, retain) NSNumber *scoredPoints;
@property (nonatomic, retain) NSNumber *totalPoints;

@property (nonatomic, retain) NSNumber *memory; // ???
@property (nonatomic, retain) NSNumber *farkles;
//@property (nonatomic) BOOL farkled; // There's got to be a better way to do this ???
@property (nonatomic, retain) NSNumber *turns;

@property (nonatomic, retain) NSMutableArray *rolledDice;
@property (nonatomic, retain) NSMutableArray *lockedDice;

+ (id)sharedManager;

@property (nonatomic) BOOL doubling;
@property (nonatomic) BOOL onesLow;

#pragma mark gameLoop
- (void)gameLoop;
- (bool)isNewGame;
- (bool)isGameOver;

#pragma mark Dice
- (NSMutableArray *)newDice; // this should be private?
- (void)rollDice;
- (bool)diceHot;

- (NSArray *)sort:(NSMutableArray *)unsorted;
- (NSInteger)score:(NSArray *)unscored;

@end
