//
//  Farkle.h
//  Farkle
//
//  Created by Kern Jackson on 5/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Die.h"

@interface Farkle : NSObject
{
	NSMutableArray *rolled;
	NSMutableArray *locked;
	NSMutableArray *stranger;
}

- (bool)diceHot;
- (NSInteger)score:(int)die in:(int)quantity;
- (int)score:(NSArray *)array;
- (int)farkled:(NSArray *)array;

@property (nonatomic) int score;
@property (nonatomic) int total;
@property (nonatomic) int memory;
@property (nonatomic) int subtotal;
@property (nonatomic) int farkles;
@property (nonatomic) bool farkled;
@property (nonatomic) int turn;

@end
