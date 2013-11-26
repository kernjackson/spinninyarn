//
//  Die.m
//  Farkle
//
//  Created by Kern Jackson on 5/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "Die.h"

@interface Die()
@end

@implementation Die

+ (NSArray *)sidesUp {
	return @[@"⚀",@"⚁",@"⚂",@"⚃",@"⚄",@"⚅"];
}

+ (NSArray *)sideValues {
	return @[@"1",@"2",@"3",@"4",@"5",@"6"];
}

+ (NSArray *)pointsForSingles {
	return @[@100,@0,@0,@0,@50,@0];
}

+ (NSArray *)pointsForTriples {
	return @[@1000,@200,@300,@400,@500,@600];
}
// think I'm just calculting these instead of storing
/*
+ (NSArray *)pointsFor4 {
	return @[@1100,@400,@600,@800,@1000,@1200];
}
+ (NSArray *)pointsFor5 {
	return @[@1200,@800,@900,@1200,@1500,@1800];
}
+ (NSArray *)pointsFor6 {
	return @[@2500,@2500,@2500,@2500,@2500,@2500];
}
*/


- (id)init {
	
	self = [super init];	
	unsigned index = arc4random() % 6;
		
	[self setLocked:NO];
	[self setScored:NO];
	[self setPlayed:NO];
	[self setSideValue: [ [[Die sideValues] objectAtIndex:index] integerValue] ];
	[self setSideUp: [  [Die sidesUp] objectAtIndex:index]];
	[self setSingle: [ [[Die pointsForSingles] objectAtIndex:index] integerValue] ];
	[self setTriple: [ [[Die pointsForTriples] objectAtIndex:index] integerValue] ];

	return self;
}

- (id)rollDie {
	
	unsigned index = arc4random() % 6;
	
	[self setLocked:NO];
	[self setScored:NO];
	[self setPlayed:NO];
	[self setSideValue: [ [[Die sideValues] objectAtIndex:index] integerValue] ];
	[self setSideUp: [  [Die sidesUp] objectAtIndex:index]];
	[self setSingle: [ [[Die pointsForSingles] objectAtIndex:index] integerValue] ];
	[self setTriple: [ [[Die pointsForTriples] objectAtIndex:index] integerValue] ];
	
	return self;
}

- (id)blankDie {
	
	[self setLocked: NO];
	[self setScored: NO];
	[self setPlayed: NO];
	[self setSideValue: 0];
	[self setSideUp: 0];
	[self setSingle: 0];
	[self setTriple: 0];
	
	return self;
}

- (int)match:(NSArray *)otherDice
{
	int score = 0;
/*(
	// enumerate through the array
	for (Card *card in otherCards) {
		//		if ([[card contents] isEqualToString:[self contents]]) {
		// If nil it returns 0 which in our case is no match
		if ([card.contents isEqualToString:self.contents]) {
			score = 1;
		}
	}
 */
	return score;
}


@end
