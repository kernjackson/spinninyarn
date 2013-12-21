//
//  Farkle.m
//  Farkle
//
//  Created by Kern Jackson on 5/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "Farkle.h"
#import "Die.h"

#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface Farkle() {

NSInteger rolledPoints;
NSInteger lockedPoints;
NSInteger scoredPoints;
NSInteger totalPoints;
NSInteger previousPoints;
    
}

+ (NSArray *)pointsForTriples;

@property (nonatomic, assign) NSInteger rolledPoints;
@property (nonatomic, assign) NSInteger lockedPoints;
@property (nonatomic, assign) NSInteger scoredPoints;
@property (nonatomic, assign) NSInteger totalPoints;
@property (nonatomic, assign) NSInteger previousPoints;

@property (nonatomic, retain) NSMutableArray *rolledDice;
@property (nonatomic, retain) NSMutableArray *lockedDice;
@property (nonatomic, retain) NSMutableArray *scoredDice;

@property (nonatomic, retain) NSMutableArray *oldDice;

@end

@implementation Farkle

@synthesize rolledPoints;
@synthesize lockedPoints;
@synthesize scoredPoints;
@synthesize totalPoints;
@synthesize previousPoints;

@synthesize isNewGame;
@synthesize canPass;
@synthesize canRoll;

@synthesize scoreTitle;
@synthesize passTitle;

@synthesize memory; // replaced by one of the above
@synthesize farkles;
@synthesize turns;

@synthesize dice;

@synthesize rolledDice;
@synthesize lockedDice;
@synthesize scoredDice;

#pragma mark Initialize

+ (id)sharedManager {
    static Farkle *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (id)init {
    if (self = [super init]) {
        
        scoreTitle = @0;
        passTitle = @0;
        
        scoredPoints = 0;
        rolledPoints = 0;
        lockedPoints = 0;
        
        isNewGame = YES;
        
        farkles = @0;
        turns = @10; // +1 for roll, +1 for 10 through 1
        
        //NSMutableArray *rolled = [[NSMutableArray alloc] init];
        
    }
    return self;
}

+ (NSArray *)pointsForTriples {
	return @[@1000,@200,@300,@400,@500,@600];
}

- (void)clearArray:(NSMutableArray *)arrayToClear {
    for (int i = 0; i < 6; i++) {
        [arrayToClear insertObject:@0 atIndex:i];
    }
}

#pragma mark Actions

- (void)rolled {

    if (isNewGame) {
        isNewGame = NO;
        NSLog(@"isNewGame");
    }
    if (self.isGameOver) {
        NSLog(@"isGameOver");
    } else {
        if (self.didFarkle) {
            // clear dice, and all points but those in scoreTitle
            NSLog(@"FARKLED");
        } else {
        
        
            //rolledDice = [self sort:dice];
            //rolledPoints = [self score:rolledDice];
            rolledPoints = [self scoreRolled];
            lockedPoints = [self scoreLocked];
            scoredPoints = [self scoreScored];
            
            //scoredPoints += lockedPoints;
            
            //passTitle = [NSNumber numberWithInteger:lockedPoints];
            
            [self logPoints];
        
            [self didFarkle];
        }
    }
    
    
    // scoredDice += lockedDice
    // clear lockedDice
    //
}

- (void)passed {
    [self decrementTurn];
    scoredPoints += lockedPoints;
    scoreTitle = [NSNumber numberWithInteger:scoredPoints];
    lockedPoints = 0;
    passTitle = @0;
    
    
    rolledPoints = [self scoreRolled];
    lockedPoints = [self scoreLocked];
    scoredPoints = [self scoreScored];
    [self logPoints];
///    [self clearArray:dice];
}



- (void)toggleDie {
    // We set the dice to locked in the controller?
    
    //lockedPoints = [self score:[self sort:lockedDice]];
    //NSLog(@"lockedPoints: %ld", (long)lockedPoints);
 /*
    lockedPoints = [self scoreLocked];
    NSLog(@"lockedPoints %ld", (long)lockedPoints);
    
    passTitle = [NSNumber numberWithInteger:(long)lockedPoints];
    NSLog(@"toggleDie: %@", passTitle);
    
    
    lockedDice = dice;
*/
    
    rolledPoints = [self scoreRolled];
    lockedPoints = [self scoreLocked];
    scoredPoints = [self scoreScored];
    
    scoredPoints += lockedPoints;
    passTitle = [NSNumber numberWithInteger:scoredPoints];
    
    [self logPoints];
    
}

- (void)endTurn {
    //self.playerTurns--;
    [self isGameOver];
}

#pragma mark Game Loop

- (void)newgameLoop {
    if (isNewGame) { // can this go inside the next if?
        dice = [self newDice];
        isNewGame = NO;
        NSLog(@"[self newGame]");
    }
    else if ([self isGameOver]) {
        NSLog(@"[self gameOver]");
        // this number is hardcoded for now, but should come from the Settings singleton
        if (scoredPoints >= 10000) {
            NSLog(@"Player Won");
        } else NSLog(@"Player Lost");
        [self newGame];
    }
    else {
        [self clearArray:rolledDice];
        for (int i = 0; i < 6; i++) {
            // do we need to check for isLocked here or just for isScore?
            if ((![[dice objectAtIndex:i] isLocked]) &&
                (![[dice objectAtIndex:i] isScored]))
            {
                //[array replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:FALSE]];
                [rolledDice replaceObjectAtIndex:i withObject:[[dice objectAtIndex:i] sideValue]];
            } // else [unsorted insertObject:@0 atIndex:i];
        }

    }
    
}

- (void)decrementTurn {
    // decrement turns
    NSNumber *temp = [NSNumber numberWithInt:[self.turns intValue] -1];
    self.turns = temp;
}

- (void)yetAnother {
    // if isNewGame?
    // if isGameOver?
    // else
    // sort dice
    // score diceRolled
        // if int diceRolled == 0, didFarkle = YES
        // else
            // if (!dice.scored) && (dice.locked)
                // setScored = YES
            // if (
}

- (void)gameLoop {
/*
    NSInteger test = 0;
    test = [rolledPoints integerValue];
    NSLog(@"test: %ld", (long)test);
    test += test;
    NSLog(@"test: %ld", (long)test);
*/

    if (isNewGame) { // can this go inside the next if?
        dice = [self newDice];
        isNewGame = NO;
        NSLog(@"[self newGame]");
    }
    else if ([self isGameOver]) {
        NSLog(@"[self gameOver]");
        // this number is hardcoded for now, but should come from the Settings singleton
        if (scoredPoints >= 10000) {
            NSLog(@"Player Won");
        } else NSLog(@"Player Lost");
        [self newGame];
    }
    else {
        
        // will this be depreciated?
        previousPoints = lockedPoints;
        NSLog(@"%ld", (long)previousPoints);
        
        /////////////////////////////////
        // need to calculate the score for rolled, locked and ¿scored?
        
        NSMutableArray *unsorted = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6; i++) {
            [unsorted insertObject:@0 atIndex:i];
        }
        // calculate score for rolled
        for (int i = 0; i < 6; i++) {
            // do we need to check for isLocked here or just for isScore?
            if ((![[rolledDice objectAtIndex:i] isLocked]) &&
                (![[rolledDice objectAtIndex:i] isScored]))
            {
                //[array replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:FALSE]];
                [unsorted replaceObjectAtIndex:i withObject:[[rolledDice objectAtIndex:i] sideValue]];
            } // else [unsorted insertObject:@0 atIndex:i];
        }
        
       // NSNumber *temp = [NSNumber numberWithInt:[aNumber intValue] + 1];
        
        // increment this instead of overwriting it?
        //NSInteger temp = [rolledPoints integerValue];
        rolledPoints = [self score:[self sort:unsorted]];
        //rolledPoints = [self score:[self sort:unsorted]];
        NSLog(@"rolled: %ld", (long)rolledPoints);
        /////////////////////////////////
        // calculate score for locked
        // do I need to clear the array to @0's here?
        // need to set locked dice to score before doing this, but where?

        for (int i = 0; i < 6; i++) {
        
            [unsorted replaceObjectAtIndex:i withObject:@0];
        }
        
        for (int i = 0; i < 6; i++) {
            if (( [[rolledDice objectAtIndex:i] isLocked]) &&
                (![[rolledDice objectAtIndex:i] isScored]))
            {
                [unsorted replaceObjectAtIndex:i withObject:[[rolledDice objectAtIndex:i] sideValue]];
                [lockedDice replaceObjectAtIndex:i withObject:[[rolledDice objectAtIndex:i] sideValue]];
                //[unsorted insertObject:[[rolledDice objectAtIndex:i] sideValue] atIndex:i];
            } // else [unsorted insertObject:@0 atIndex:i];
        }
        lockedPoints += [self score:[self sort:unsorted]]; // was +=
        NSLog(@"locked: %ld", (long)lockedPoints);
        /////////////////////////////////
        
        //NSLog(@"subtotal: %ld", (long)[self score:[self sort:rolledDice]]);
        [self logLocked];
        
        canRoll = [self canRoll];
        canPass = [self canPass];
    }
}

#pragma mark Check Game State

- (BOOL)isNewGame {
   // if ([turns  isEqual: @10]) {
//        NSNumber *temp = [NSNumber numberWithInt:[turns intValue] -1];
//        turns = temp;
  //      return YES;
   // } else return NO;
    return YES; // this should probably have it's own BOOL flag
}

- (BOOL)isGameOver {
    if ([turns  isEqual: @0] ) {
        return YES;
    } else return NO;
}

- (BOOL)canRoll {
    if (lockedPoints >= 50) { // NSDefaults minimumScore
        return YES;
    } else return NO;
}

- (BOOL)canPass {
    if (lockedPoints < 300) {
        return NO;
    } else return YES;
    // return YES;
}

- (bool)areDiceHot {
    // if all dice are scored return YES
    // else return false
    // how do we check to see if a non scoring die has been selected?
    return NO;
}

- (void)newGame {
    turns = @10;
}

- (int)whoOne {
    return -1;
}

- (BOOL)didFarkle {
    if (rolledPoints == 0) {
        return YES;
    }
      return NO;
}

#pragma mark Dice

- (NSMutableArray *)newDice {
    NSMutableArray *newDice = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 5; i++) {
		Die *die = [[Die alloc] init];
        [newDice addObject:die];
	}
    return newDice;
}

- (void)rollDice {
    
    if (!dice) {
        dice = [self newDice];
    }
    
    // This should be in the inherited class Solitaire
    if (isNewGame) {
        dice = [self newDice];
    }
    
	for (int i = 0; i <= 5; i++) {
		if ([[dice objectAtIndex:i] isLocked]) {
			[[dice objectAtIndex:i] setScored:YES];
		} else {
			Die *die = [[Die alloc] init];
			[dice replaceObjectAtIndex:i withObject:die];
		}
	}
    [self logRolled];
    //	[self setFarkles: [self farkled]];
}

- (void)eraseArray:(NSMutableArray *)arrayToErase {
    for (int i = 0; i < 6; i++) {
        [arrayToErase replaceObjectAtIndex:i withObject:0]; // would cause a crash if it was expecting an NSNumber
    }
}

#pragma mark Sort & Score

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)scoreRolled {
    // make a temporary array
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    // and initialize it
    for (int i = 0; i < 6; i++) {
        [temp insertObject:@0 atIndex:i];
    }
    // calculate score for rolled
    for (int i = 0; i < 6; i++) {
        // is it neither locked or scored?
        if ((![[dice objectAtIndex:i] isLocked]) &&
            (![[dice objectAtIndex:i] isScored]))
        {
            [temp replaceObjectAtIndex:i withObject:[[dice objectAtIndex:i] sideValue]];
        } // else [temp insertObject:@0 atIndex:i];
    }
    return rolledPoints = [self score:[self sort:temp]];
}

- (NSInteger)scoreLocked {
    // make a temporary array
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    // and initialize it
    for (int i = 0; i < 6; i++) {
        [temp insertObject:@0 atIndex:i];
    }
    // calculate score for rolled
    for (int i = 0; i < 6; i++) {
        // is it neither locked or scored?
        if (( [[dice objectAtIndex:i] isLocked]) &&
            (![[dice objectAtIndex:i] isScored]))
        {
            [temp replaceObjectAtIndex:i withObject:[[dice objectAtIndex:i] sideValue]];
        } // else [temp insertObject:@0 atIndex:i];
    }
    return lockedPoints = [self score:[self sort:temp]];
}

- (NSInteger)scoreScored {
    // make a temporary array
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    // and initialize it
    for (int i = 0; i < 6; i++) {
        [temp insertObject:@0 atIndex:i];
    }
    // calculate score for rolled
    for (int i = 0; i < 6; i++) {
        // is it neither locked or scored?
        if (( [[dice objectAtIndex:i] isLocked]) &&
            ( [[dice objectAtIndex:i] isScored]))
        {
            [temp replaceObjectAtIndex:i withObject:[[dice objectAtIndex:i] sideValue]];
        } // else [temp insertObject:@0 atIndex:i];
    }
    return scoredPoints = [self score:[self sort:temp]];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 121345 == 211110, 443564 == 001311, etc
- (NSArray *)sort:(NSMutableArray *)unsorted {
    NSMutableArray *sorted = [[NSMutableArray alloc] init];
    // Initialize the array
    for (int i = 0; i < 6; i++) {
        [sorted addObject:@0];
    } // increment at each position for each die value
    for (int position = 0; position < 6; position++) {
        for (int value = 0; value < 6; value++) {
            if (unsorted[position] == [NSNumber numberWithInt:value+1]) {
          //  if ([[unsorted[position] sideValue] isEqual:[NSNumber numberWithInt:value+1]]) {
                NSNumber *count = [NSNumber numberWithInt:[sorted[value] intValue] + 1];
                //NSLog(@"count: %@", count);
                [sorted replaceObjectAtIndex:value withObject:count];
            }
        }
    }
    return sorted;
}

- (NSInteger)score:(NSArray *)unscored {
    
    int scored = 0;
    // step through the entire array
    for (int i = 0; i < 6; i++) {
        
        // are there more than 6?
        if ( [unscored[0] intValue]
            +[unscored[1] intValue]
            +[unscored[2] intValue]
            +[unscored[3] intValue]
            +[unscored[4] intValue]
            +[unscored[5] intValue]
            > 6) {
            return -1;
        }
        
        // scored 3 or more
        else if ([unscored[i] intValue] >= 3) {
            
            // check _onesLow whether 1*4 = 2000 or 1*4 == 1100
            scored += (([[[Farkle pointsForTriples]
                          objectAtIndex:i]
                         intValue] * (([unscored[i] intValue] -2))) );
            
            // check _doubling whether adding or doubling
            if (_doubling) {
                //
            }
            
            // check for fullhouse
            // if 3 and 2
        }
        else if ([unscored[i] intValue] == 2) {
            
            // check for 3 pair here
            int counter = 0;
            for (int j = 0; j < 6; j++) {
                if ([unscored[j] intValue] == 2) {
                    counter++;
                }
            }
            if (counter == 3) {
                scored = 1500;
            }
            
            // 2 ones
            else if (i == 0) {
                scored += 200;
            }
            
            // 2 fives
            else if (i == 4) {
                scored += 100;
            }
            else scored += 0;
        }
        else if ([unscored[i] intValue] == 1) {
            
            // check for straight here
            if (   ([unscored[0] intValue] == 1)
                && ([unscored[1] intValue] == 1)
                && ([unscored[2] intValue] == 1)
                && ([unscored[3] intValue] == 1)
                && ([unscored[4] intValue] == 1)
                && ([unscored[5] intValue] == 1)
                ) {
                scored = 2500; // overwrite the existing scored
            }
            
            // 1 one
            if (i == 0) {
                scored += 100;
            }
            
            // 1 five
            else if (i == 4) {
                scored += 50;
            }
            else scored += 0;
        }
    }
    return scored;
}

#pragma mark Console

- (void)logRolled {
    for (int i = 0; i < 6; i++) {
        if ((![[dice objectAtIndex:i] isLocked]) &&
            (![[dice objectAtIndex:i] isScored])) {
            NSLog(@"rolled: %@", [[dice objectAtIndex:i] sideUp]);
        }
    }
}

- (void)logLocked {
    
    for (int i = 0; i < 6; i++) {
        if ([[dice objectAtIndex:i] isLocked]) {
            NSLog(@"locked: %@", [[dice objectAtIndex:i] sideUp]);
        }
    }
}

- (void)logPoints {
    NSLog(@"=====================================");
    NSLog(@"rolledPoints %ld", (long)rolledPoints);
    NSLog(@"lockedPoints %ld", (long)lockedPoints);
    NSLog(@"scoredPoints %ld", (long)scoredPoints);
    NSLog(@"=====================================");
}

@end
