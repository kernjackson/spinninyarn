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

@interface Farkle()

+ (NSArray *)pointsForTriples;

@end

@implementation Farkle

@synthesize score;
@synthesize total;
@synthesize subtotal;
@synthesize memory;
@synthesize farkles;
@synthesize turns;

@synthesize rolledDice;
@synthesize lockedDice;

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
        
        score = @0;
        total = @0;
        subtotal = @0;
        farkles = @0;
        turns = @10; // +1 for roll, +1 for 10 through 1
        
        //NSMutableArray *rolled = [[NSMutableArray alloc] init];
        
    }
    return self;
}

+ (NSArray *)pointsForTriples {
	return @[@1000,@200,@300,@400,@500,@600];
}

- (void)gameLoop {
    if ([self isNewGame]) // can this go inside the next if?
        NSLog(@"[self newGame]");
    else if ([self isGameOver]) {
        NSLog(@"[self gameOver]");
        [self newGame];
    }
    else {
        
        /////////////////////////////////
        // need to calculate the score for rolled, locked and ¿scored?
        
        NSMutableArray *unsorted = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6; i++) {
            [unsorted addObject:@0];
        }
        // calculate score for rolled
        for (int i = 0; i < 6; i++) {
            if ((![[rolledDice objectAtIndex:i] isLocked]) &&
                (![[rolledDice objectAtIndex:i] isScored]))
            {
                [unsorted insertObject:[[rolledDice objectAtIndex:i] sideValue] atIndex:i];
            }
        }
        subtotal = [NSNumber numberWithInteger:[self score:[self sort:unsorted]]];
        NSLog(@"subtotal: %@", subtotal);
        /////////////////////////////////
        // calculate score for locked
        for (int i = 0; i < 6; i++) {
            if ([[rolledDice objectAtIndex:i] isLocked])
            {
                [unsorted insertObject:[[rolledDice objectAtIndex:i] sideValue] atIndex:i];
            }
        }
        total = [NSNumber numberWithInteger:[self score:[self sort:unsorted]]];
        NSLog(@"total: %@", total);
        /////////////////////////////////

        
        //NSLog(@"subtotal: %ld", (long)[self score:[self sort:rolledDice]]);
        [self logLocked];
    }
}

- (bool)isNewGame {
    if ([turns  isEqual: @10]) {
//        NSNumber *temp = [NSNumber numberWithInt:[turns intValue] -1];
//        turns = temp;
        return YES;
    } else return NO;
}

- (bool)isGameOver {
    if ([turns  isEqual: @0] ) {
        return YES;
    } else return NO;
}

- (void)newGame {
    turns = @10;
}

- (int)whoOne {
    return -1;
}

/*
- (int)gameLoop {
    
    // is it a new game?
    if ([turns intValue] > 10) {
        // newGame
    }
    // did Player Win?
    else if ([score intValue] >= 10000) {
        // playerWon
    }
    // did Player Lose?
    else if ([turns intValue] < 0) {
        // playerLost
    }
    else {
        
    }
    
    
    
    return -1;
}
*/
#pragma mark Dice

- (NSMutableArray *)newDice {
    NSMutableArray *newDice = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 5; i++) {
		Die *die = [[Die alloc] init];
        [newDice addObject:die];
	}
    return newDice;
}
/*
- (void)newDice {
    NSMutableArray *rolled = [[NSMutableArray alloc] init];
//	[self.rolled removeAllObjects];
	for (int i = 0; i <= 5; i++) {
		Die *die = [[Die alloc] init];
//        [rolled insertObject:die atIndex:i];
        [rolled addObject:die];
        NSLog(@"die: %@", [die sideUp]);
        NSLog(@"rolled: %@", [rolled objectAtIndex:i]);
//		[rolled insertObject:die atIndex:i];
	}
	// check score here?
}
*/
- (void)rollDice {
    
    
    
    // This should be in the inherited class Solitaire
    if ([self isNewGame]) {
        rolledDice = [self newDice];
    }
    
	for (int i = 0; i <= 5; i++) {
		if ([[rolledDice objectAtIndex:i] isLocked]) {
			[[rolledDice objectAtIndex:i] setScored:YES];
		} else {
			Die *die = [[Die alloc] init];
			[rolledDice replaceObjectAtIndex:i withObject:die];
		}
	}
    [self logRolled];
    //	[self setFarkles: [self farkled]];
}

- (bool)diceHot {
    return -1;
}

- (void)enableDie:(int)sender {
    
}

- (void)disableDie:(int)tag {
   // Farkle *sharedManager = [Farkle sharedManager];
    
    // we need this, but it currently prevents compilaton
//	[rolled objectAtIndex:tag setLocked:YES];
}

// I don't think I actually need this, as we never really need to removed all objects from the array. Just set everything to zero instead.
- (void)clearDice {
	[rolledDice removeAllObjects];
	for (int i = 0; i <= 5; i++) {
//		[[_diceButtons objectAtIndex:i] setAlpha:1];
//		[[self.diceButtons objectAtIndex:i] setEnabled:YES];
//		[[self.diceButtons objectAtIndex:i] setSelected:FALSE];
//		[[self.diceButtons objectAtIndex:i] setTitle:@""
//                                            forState:UIControlStateNormal];
//		[[self.diceButtons objectAtIndex:i] setEnabled:NO]; // ???
	}
}

#pragma mark Sort & Score

- (NSArray *)sort:(NSMutableArray *)unsorted {
    
    NSMutableArray *sorted = [[NSMutableArray alloc] init];
    // Initialize the array
    for (int i = 0; i < 6; i++) {
        [sorted addObject:@0];
    } // increment at each position for each die value
    for (int position = 0; position < 6; position++) {
        for (int value = 0; value < 6; value++) {
            if ([unsorted[position] isEqual:[NSNumber numberWithInt:value+1]]) {
                NSNumber *count = [NSNumber numberWithInt:[sorted[value] intValue] + 1];
                [sorted removeObjectAtIndex:value];
                [sorted insertObject:count atIndex:value];
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
        if ((![[rolledDice objectAtIndex:i] isLocked]) &&
            (![[rolledDice objectAtIndex:i] isScored])) {
            NSLog(@"rolled: %@", [[rolledDice objectAtIndex:i] sideUp]);
        }
    }
}

- (void)logLocked {
    
    for (int i = 0; i < 6; i++) {
        if ([[rolledDice objectAtIndex:i] isLocked]) {
            NSLog(@"locked: %@", [[rolledDice objectAtIndex:i] sideUp]);
        }
    }
}

@end
