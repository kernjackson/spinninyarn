//
//  Die.h
//  Farkle
//
//  Created by Kern Jackson on 5/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Die : NSObject {
    
}

@property (nonatomic) NSUInteger sideValue;
@property (strong, nonatomic) NSString *sideUp;
@property (nonatomic) NSUInteger single;
@property (nonatomic) NSUInteger triple;
@property (nonatomic, getter = isPlayed) BOOL played;
@property (nonatomic, getter = isLocked) BOOL locked;
@property (nonatomic, getter = isScored) BOOL scored;

+ (NSArray *)validSides;
+ (NSArray *)pointsForSingles;
+ (NSArray *)pointsForTriples;

- (int)match:(NSArray *)otherDice;

- (id)blankDie;
- (id)rollDie;

@end
