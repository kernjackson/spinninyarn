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

    NSNumber *scoreTitle;
    NSNumber *passTitle;

    NSNumber *memory;  // ???
    NSNumber *farkles;
    NSNumber *turns;
    
    BOOL hotDice;
}

@property (nonatomic, assign) BOOL isNewGame;
@property (nonatomic, assign) BOOL canPass;
@property (nonatomic, assign) BOOL canRoll;
@property (nonatomic, assign) BOOL hotDice;
@property (nonatomic, assign) BOOL nonScoring;

@property (nonatomic, retain) NSNumber *scoreTitle;
@property (nonatomic, retain) NSNumber *passTitle;

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

- (BOOL)isNewGame;
- (BOOL)isGameOver;
- (BOOL)canRoll;
- (BOOL)canPass;
- (BOOL)areDiceHot;
- (BOOL)didFarkle;

#pragma make private

- (NSMutableArray *)newDice; // this should be private?
- (void)rollDice; // private
- (NSMutableArray *)sort:(NSMutableArray *)unsorted; //private
- (NSInteger)score:(NSArray *)unscored; // private

@end
