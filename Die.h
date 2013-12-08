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
@property (nonatomic, getter = isPlayed) BOOL played;
@property (nonatomic, getter = isLocked) BOOL locked;
@property (nonatomic, getter = isScored) BOOL scored;

- (int)match:(NSArray *)otherDice;

- (id)blankDie;
- (id)rollDie;

@end
