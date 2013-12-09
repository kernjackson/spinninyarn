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
@synthesize farkles;
@synthesize turns;

@synthesize rolled;
@synthesize locked;

#pragma mark Singleton Methods

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
        turns = @12; // +1 for roll, +1 for 10 through 1
    }
    return self;
}


#pragma mark Static Values

+ (NSArray *)pointsForTriples {
	return @[@1000,@200,@300,@400,@500,@600];
}

- (void)newDice {
	[rolled removeAllObjects];
	for (int i = 0; i <= 5; i++) {
		Die *die = [[Die alloc] init];
		[rolled insertObject:die atIndex:i];
//		[self flipDiceButtons:i];
	}
	// check score here
}

- (void)rollDice {
    //Singleton *sharedManager = [Singleton sharedManager];
    //	Die *die = [[Die alloc] init];
	for (int i = 0; i <= 5; i++) {
		if ([[rolled objectAtIndex:i] isLocked]) {
//			[[self.diceButtons objectAtIndex:i] setAlpha:.1];
//			[[self.diceButtons objectAtIndex:i] setEnabled:NO];
			[[rolled objectAtIndex:i] setScored:YES];
			
		} else {
			Die *die = [[Die alloc] init];
			[rolled replaceObjectAtIndex:i withObject:die];
			// perform flip animation here
            // possibly send a message here?
//			[self flipDiceButtons:i];
		}
	}
    //	[self setFarkles: [self farkled]];
}

- (bool)diceHot {
    return -1;
}

- (void)disableDie:(UIButton *)sender {
   // Farkle *sharedManager = [Farkle sharedManager];
    
    // we need this, but it currently prevents compilaton
//	[[rolled objectAtIndex:[sender tag] setLocked:YES];
}

#pragma mark Sort Array

- (NSArray *)sort:(NSMutableArray *)unsorted {
    
    NSMutableArray *sorted = [[NSMutableArray alloc] init];
    // Initialize the array
    for (int i = 0; i < 6; i++) {
        [sorted addObject:@0];
    } // increment at each position for each die value
    for (int position = 0; position < 6; position++) {
        for (int value = 0; value < 6; value++) {
            // this was using isEqualTo:
            if ([unsorted[position] isEqual:[NSNumber numberWithInt:value+1]]) {
                NSNumber *count = [NSNumber numberWithInt:[sorted[value] intValue] + 1];
                [sorted removeObjectAtIndex:value];
                [sorted insertObject:count atIndex:value];
            }
        }
    }
    return sorted;
}

#pragma mark Return Score

- (NSInteger)score:(NSArray *)localLocked {
    
    int localScore = 0;
    // step through the entire array
    for (int i = 0; i < 6; i++) {
        
        // are there more than 6?
        if ( [localLocked[0] intValue]
            +[localLocked[1] intValue]
            +[localLocked[2] intValue]
            +[localLocked[3] intValue]
            +[localLocked[4] intValue]
            +[localLocked[5] intValue]
            > 6) {
            return -1;
        }
        
        // localScore 3 or more
        else if ([localLocked[i] intValue] >= 3) {
            
            // check _onesLow whether 1*4 = 2000 or 1*4 == 1100
            localScore += (([[[Farkle pointsForTriples]
                              objectAtIndex:i]
                             intValue] * (([localLocked[i] intValue] -2))) );
            
            // check _doubling whether adding or doubling
            if (_doubling) {
                //
            }
            
            // check for fullhouse
            // if 3 and 2
        }
        else if ([localLocked[i] intValue] == 2) {
            
            // check for 3 pair here
            int counter = 0;
            for (int j = 0; j < 6; j++) {
                if ([localLocked[j] intValue] == 2) {
                    counter++;
                }
            }
            if (counter == 3) {
                localScore = 1500;
            }
            
            // 2 ones
            else if (i == 0) {
                localScore += 200;
            }
            
            // 2 fives
            else if (i == 4) {
                localScore += 100;
            }
            else localScore += 0;
        }
        else if ([localLocked[i] intValue] == 1) {
            
            // check for straight here
            if (   ([localLocked[0] intValue] == 1)
                && ([localLocked[1] intValue] == 1)
                && ([localLocked[2] intValue] == 1)
                && ([localLocked[3] intValue] == 1)
                && ([localLocked[4] intValue] == 1)
                && ([localLocked[5] intValue] == 1)
                ) {
                localScore = 2500; // overwrite the existing localScore
            }
            
            // 1 one
            if (i == 0) {
                localScore += 100;
            }
            
            // 1 fives
            else if (i == 4) {
                localScore += 50;
            }
            else localScore += 0;
        }
    }
    return localScore;
}



@end
