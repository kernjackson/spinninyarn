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

#pragma mark Static Values

+ (NSArray *)pointsForTriples {
	return @[@1000,@200,@300,@400,@500,@600];
}

- (void)newDice {
	[self.rolled removeAllObjects];
	for (int i = 0; i <= 5; i++) {
		
		Die *die = [[Die alloc] init];
		[self.rolled insertObject:die atIndex:i];
//		[self flipDiceButtons:i];
	}
	// check score here
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

- (NSInteger)score:(NSArray *)locked {
    
    int score = 0;
    // step through the entire array
    for (int i = 0; i < 6; i++) {
        
        // are there more than 6?
        if ( [locked[0] intValue]
            +[locked[1] intValue]
            +[locked[2] intValue]
            +[locked[3] intValue]
            +[locked[4] intValue]
            +[locked[5] intValue]
            > 6) {
            return -1;
        }
        
        // score 3 or more
        else if ([locked[i] intValue] >= 3) {
            
            // check _onesLow whether 1*4 = 2000 or 1*4 == 1100
            score += (([[[Farkle pointsForTriples]
                         objectAtIndex:i]
                        intValue] * (([locked[i] intValue] -2))) );
            
            // check _doubling whether adding or doubling
            if (_doubling) {
                //
            }
            
            // check for fullhouse
            // if 3 and 2
        }
        else if ([locked[i] intValue] == 2) {
            
            // check for 3 pair here
            int counter = 0;
            for (int j = 0; j < 6; j++) {
                if ([locked[j] intValue] == 2) {
                    counter++;
                }
            }
            if (counter == 3) {
                score = 1500;
            }
            
            // 2 ones
            else if (i == 0) {
                score += 200;
            }
            
            // 2 fives
            else if (i == 4) {
                score += 100;
            }
            else score += 0;
        }
        else if ([locked[i] intValue] == 1) {
            
            // check for straight here
            if (   ([locked[0] intValue] == 1)
                && ([locked[1] intValue] == 1)
                && ([locked[2] intValue] == 1)
                && ([locked[3] intValue] == 1)
                && ([locked[4] intValue] == 1)
                && ([locked[5] intValue] == 1)
                ) {
                score = 2500; // overwrite the existing score
            }
            
            // 1 one
            if (i == 0) {
                score += 100;
            }
            
            // 1 fives
            else if (i == 4) {
                score += 50;
            }
            else score += 0;
        }
    }
    return score;
}


@end
