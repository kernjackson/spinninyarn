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
NSInteger finalPoints;
    
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
@synthesize hotDice;
@synthesize nonScoring;

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
        
        // possibly check defaults here.
        //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        scoreTitle = @0;
        passTitle = @0;
        
        scoredPoints = 0;
        rolledPoints = 0;
        lockedPoints = 0;
        
        isNewGame = YES;
        nonScoring = YES;
        
        farkles = @0;
        turns = @11; // +1 for roll, +1 for 10 through 1
        
        
        
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
            previousPoints = totalPoints;
            scoredPoints += lockedPoints;
            rolledPoints = [self scoreRolled];
            totalPoints = previousPoints + scoredPoints;
        
            [self logPoints];
        }
}

- (void)passed {
    
    totalPoints = (previousPoints + lockedPoints);
    finalPoints += totalPoints;
    scoreTitle = [NSNumber numberWithInteger:(finalPoints)];
    
    lockedPoints = [self scoreLocked];
    scoredPoints = [self scoreScored];
    
    [self logPoints];
    [self endTurn];
}

- (void)toggleDie {
    
    lockedPoints = [self scoreLocked];

    totalPoints = previousPoints + lockedPoints;
    passTitle = [NSNumber numberWithInteger:totalPoints];
    
    [self logPoints];
}

- (void)endTurn {
    
    // This is probably the only place we need to check for isGameOver
    
    // decrement turns
    NSNumber *temp = [NSNumber numberWithInt:[self.turns intValue] -1];
    self.turns = temp;
    rolledPoints = -1;
    scoredPoints = 0;
    lockedPoints = 0;
    totalPoints = 0;
    previousPoints = 0;
    passTitle = @0;
    nonScoring = YES; // hmm...
    [self clearDice];
    if (self.isGameOver) {
        NSLog(@"GAMEOVER");
    }
    // clear dice here
}

#pragma mark Check Game State

- (BOOL)isNewGame {
    if ([turns  isEqual: @11]) {
        NSNumber *temp = [NSNumber numberWithInt:[turns intValue] -1];
        turns = temp;
        return YES;
    } else return NO;
}

- (BOOL)isGameOver {
    if ([turns  isEqual: @0] ) {
        //turns = @10;
        return YES;
    } else return NO;
}

- (BOOL)canRoll { // add a check for non-scoring dice
    // should also  return NO if nonscoring
    //NSInteger temp = [passTitle integerValue];
    if ( ( (lockedPoints >= 50) && (nonScoring)) || (isNewGame)) {
       // && (nonScoring)) { // NSDefaults minimumScore
        NSLog(@"YES: %d", lockedPoints);
        return YES;
    
  //    if (nonScoring) {
   //     NSLog(@"NO: %d", lockedPoints);
   //     return NO;
    } else return NO;
}

- (BOOL)canPass {
    // should also return NO if nonscoring
    NSInteger temp = [passTitle integerValue];
    if ( (temp < 300) || (self.areDiceHot) )
    { // add a check for non-scoring dice
        return NO;
    } else return YES;
}

- (BOOL)areDiceHot {
    // if all dice are scored return YES
    // else return false
    // how do we check to see if a non scoring die has been selected?
    NSInteger count = 0;
    for (int i = 0; i <= 5; i++) {
		if ( ([[dice objectAtIndex:i] isLocked]) || [[dice objectAtIndex:i] isScored]) {
			count++;
        }
    }
    if (count == 6) {
        return YES;
    } else return NO;
}

- (void)newGame {
    turns = @11;
    totalPoints = 0;
    scoredPoints = 0;
    lockedPoints = 0;
    finalPoints = 0;
    passTitle = @0;
    scoreTitle = @0;
}

- (int)whoOne {
    return -1;
}

- (BOOL)didFarkle {
    if ((rolledPoints == 0) && (!isNewGame)) {
        [self endTurn];
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

// Not sure what to do here? acutally set to nil, or just some value like @0 that will hide the die and not score it
- (void)clearDice {
    Die *die = [[Die alloc] init];
    for (int i = 0; i <= 5; i++) {
        [dice replaceObjectAtIndex:i withObject:[die blankDie]];
	}
}

- (void)rollDice {
    
    if (!dice) {
        dice = [self newDice];
    }
    
    if ( (self.areDiceHot) && (nonScoring) ){
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
            
            // check for hotDice
            // all dice must be selected, and all dice must be scoring
            
            // Check for non-scoring dice. it's ugly, but it works
            else if (([unscored[1] intValue] == 1) ||
                     ([unscored[1] intValue] == 2) ||
                     ([unscored[2] intValue] == 1) ||
                     ([unscored[2] intValue] == 2) ||
                     ([unscored[3] intValue] == 1) ||
                     ([unscored[3] intValue] == 2) ||
                     ([unscored[5] intValue] == 1) ||
                     ([unscored[5] intValue] == 2)
               
                     ) {
                nonScoring = YES;
                NSLog(@"NON SCORING DICE");
            }
            else {
                scored += 0;
                nonScoring =  NO;
            }
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
    NSLog(@"totalPoints  %ld", (long)totalPoints);
    NSLog(@"=====================================");
}

@end
