//
//  Farkle.m
//  Farkle
//
//  Created by Kern Jackson on 5/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "Farkle.h"
#import "Die.h"
//#import "Rules.h"

@interface Farkle()

@property (nonatomic) int score;
@property (nonatomic) int total;
@property (nonatomic) int subtotal;
@property (nonatomic) int farkles;

@end

@implementation Farkle

#define GOAL 10000
#define MINIMUM 300
#define PENALTY 1000
#define TURNS 10

- (bool)diceHot {
	int temp = 0;
	for (int i = 0; i <=5; i++) {
		if ([[rolled objectAtIndex:i] isLocked]) {
			temp++;
		}
	}
	if (temp == 6) {
		return TRUE;
	} else
		return FALSE;
}

- (int)score:(NSArray *)array {
	Farkle *farkle = [[Farkle alloc] init];
	int subtotal = 0;
	for (int dieValue = 1; dieValue <= 6; dieValue++) {
		int quantity = 0;
		for (int i = 0; i <= 5; i++) {
			if ( ([[array objectAtIndex:i] sideValue] == dieValue)
					&& ([[array objectAtIndex:i] isLocked])
					&& (![[array objectAtIndex:i] isScored]) ) {
				quantity++;
			}
		}
		subtotal += [farkle score:dieValue in:quantity];
	}
	return subtotal;
}

- (int)farkled:(NSArray *)array {
	Farkle *farkle = [[Farkle alloc] init];
	int subtotal = 0;
	for (int dieValue = 1; dieValue <= 6; dieValue++) {
		int quantity = 0;
		for (int i = 0; i <= 5; i++) {
			if ( ([[array objectAtIndex:i] sideValue] == dieValue)
					&& (![[array objectAtIndex:i] isLocked])
					&& (![[array objectAtIndex:i] isScored]) ) {
				quantity++;
			}
		}
		subtotal += [farkle score:dieValue in:quantity];
	}
	return subtotal;
}

- (int)straight:(NSArray *)array {
	Farkle *farkle = [[Farkle alloc] init];
	int subtotal = 0;
	for (int dieValue = 1; dieValue <= 6; dieValue++) {
		int quantity = 0;
		for (int i = 0; i <= 5; i++) {
			if ( ([[array objectAtIndex:i] sideValue] == dieValue)
					&& (![[array objectAtIndex:i] isLocked])
					&& (![[array objectAtIndex:i] isScored]) ) {
				quantity++;
			}
		}
		subtotal += [farkle score:dieValue in:quantity];
	}
	return subtotal;
}

// this did return an int before
- (NSInteger)score:(int)die in:(int)quantity {
	
    NSArray *singles = [Die pointsForSingles];
    NSArray *triples = [Die pointsForTriples];
    
//	NSArray *singles = [Rules singles];
//	NSArray *triples = [Rules triples];
	
	NSInteger single = [[singles objectAtIndex:(die - 1)] integerValue];
	NSInteger triple = [[triples objectAtIndex:(die - 1)] integerValue];
	
	if (quantity == 1) {
		// how do we check for a straight? probably make a seperate method that just checks for quantity 1 of each 0-5 only for rolled.count unlocked = 6
		// how do we check for three pairs? same thing but for quantity 2. only for rolled.count unlocked = 6
		return ( (quantity * single) );
	}
	else if (quantity == 2) {
		if	(die == 7) {
			NSLog(@"7?");
		}
		else return ( (quantity * single) );
	}
	else if ( (quantity >= 3) && (quantity <= 5)) {
		if ((die == 1) || (die == 5)) {
			return ( triple + ((quantity - 3) * single) );
		} else
			return ( triple + ((quantity - 3) * triple) );
	}
	else if (quantity == 6) {
		return 2500;
	}
	else if (quantity == 0) {
		return 0;
	}
	else {
		NSLog(@"error");
		return -1;
	}
    return 0;
    
}

@end
