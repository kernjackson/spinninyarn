//
//  Singleton.h
//  Singleton
//
//  Created by Kern Jackson on 11/8/13.
//  Copyright (c) 2013 Kern Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject {
    NSNumber *score;
    NSNumber *total;
    NSNumber *subtotal; // ???
    NSNumber *farkles;
    NSNumber *turns;
    
    NSMutableArray *rolled;
    NSMutableArray *locked;
}

@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSNumber *total;
@property (nonatomic, retain) NSNumber *subtotal; // Do we need this?
@property (nonatomic, retain) NSNumber *farkles;
@property (nonatomic, retain) NSNumber *turns;

@property (nonatomic, retain) NSMutableArray *rolled;
@property (nonatomic, retain) NSMutableArray *locked;

+ (id)sharedManager;

@end
