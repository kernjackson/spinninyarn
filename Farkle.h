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
    
    //NSNumber *rolledPoints;
    NSInteger rolledPoints;
    NSInteger lockedPoints;
    NSInteger scoredPoints;
    NSInteger totalPoints;
    
    BOOL isNewGame;
    
    
/*
    BOOL newGame; // don't think I need this
    BOOL canRoll;
    BOOL canPass;
    BOOL farkled;
*/    
     // ???
    NSNumber *memory;  // ???
    NSNumber *farkles;
   //BOOL farkled; // There's got to be a better way to do this ???
    NSNumber *turns;
    
//    NSMutableArray *rolled;
//    NSMutableArray *locked;
}

@property (nonatomic, assign) NSInteger rolledPoints;
@property (nonatomic, assign) NSInteger lockedPoints;
@property (nonatomic, assign) NSInteger scoredPoints;
@property (nonatomic, assign) NSInteger totalPoints;

@property (nonatomic, assign) BOOL isNewGame;

@property (nonatomic, retain) NSNumber *memory; // ???
@property (nonatomic, retain) NSNumber *farkles;
@property (nonatomic, retain) NSNumber *turns;

@property (nonatomic, retain) NSMutableArray *rolledDice;
@property (nonatomic, retain) NSMutableArray *lockedDice;

+ (id)sharedManager;

@property (nonatomic) BOOL doubling;
@property (nonatomic) BOOL onesLow;

#pragma mark gameLoop
- (void)gameLoop;
//- (BOOL)isNewGame;
- (BOOL)isGameOver;
- (BOOL)canRoll;
- (BOOL)canPass;
- (bool)areDiceHot;

#pragma mark Dice
- (NSMutableArray *)newDice; // this should be private?
- (void)rollDice;


- (NSArray *)sort:(NSMutableArray *)unsorted;
- (NSInteger)score:(NSArray *)unscored;

@end
