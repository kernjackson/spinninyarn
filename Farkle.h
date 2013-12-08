//
//  Farkle.h
//  Farkle
//
//  Created by Kern Jackson on 5/25/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Farkle : NSObject

@property (nonatomic) BOOL doubling;
@property (nonatomic) BOOL onesLow;

- (bool)diceHot;
- (NSArray *)sort:(NSMutableArray *)locked;
- (NSInteger)score:(NSArray *)locked;

@end
