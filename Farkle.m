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

@synthesize rolled;
@synthesize locked;

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
        turns = @12; // +1 for roll, +1 for 10 through 1
    }
    return self;
}

+ (NSArray *)pointsForTriples {
	return @[@1000,@200,@300,@400,@500,@600];
}

#pragma mark Dice

- (void)newDice {
	[rolled removeAllObjects];
	for (int i = 0; i <= 5; i++) {
		Die *die = [[Die alloc] init];
		[rolled insertObject:die atIndex:i];
	}
	// check score here?
}

- (void)rollDice {
	for (int i = 0; i <= 5; i++) {
		if ([[rolled objectAtIndex:i] isLocked]) {
			[[rolled objectAtIndex:i] setScored:YES];
		} else {
			Die *die = [[Die alloc] init];
			[rolled replaceObjectAtIndex:i withObject:die];
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

#pragma mark Sort & Score

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
            
            // 1 fives
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
        NSLog(@"%@", rolled[i]);
    }
}

- (void)logLocked {
    for (int i = 0; i < 6; i++) {
        NSLog(@"%@", locked[i]);
    }
}

@end
