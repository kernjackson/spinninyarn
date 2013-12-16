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
    NSInteger previousPoints;
    
 //   BOOL isNewGame;
    
//    BOOL canPass;
//    BOOL canRoll;
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
@property (nonatomic, assign) NSInteger previousPoints;

@property (nonatomic, assign) BOOL isNewGame;
@property (nonatomic, assign) BOOL canPass;
@property (nonatomic, assign) BOOL canRoll;

@property (nonatomic, retain) NSNumber *memory; // ???
@property (nonatomic, retain) NSNumber *farkles;
@property (nonatomic, retain) NSNumber *turns;

@property (nonatomic, retain) NSMutableArray *dice;

+ (id)sharedManager;

@property (nonatomic) BOOL doubling;
@property (nonatomic) BOOL onesLow;

#pragma mark gameLoop

- (void)newGame;
- (void)passed;
- (void)rolled;
- (void)toggleDie;

- (void)gameLoop;

- (BOOL)isNewGame;
- (BOOL)isGameOver;
- (BOOL)canRoll;
- (BOOL)canPass;
- (BOOL)areDiceHot;
- (BOOL)didFarkle;

#pragma make private

- (NSMutableArray *)newDice; // this should be private?
- (void)rollDice; // private
- (NSArray *)sort:(NSMutableArray *)unsorted; //private
- (NSInteger)score:(NSArray *)unscored; // private

@end
