//
//  Singleton.h
//  Singleton
//
//  Created by Kern Jackson on 11/8/13.
//  Copyright (c) 2013 Kern Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject {
    NSString *someProperty;
    
}
//
@property (nonatomic, retain) NSString *someProperty;
//
@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSNumber *total;
@property (nonatomic, retain) NSNumber *subTotal;
@property (nonatomic, retain) NSNumber *farkles;
@property (nonatomic, retain) NSNumber *turns;

+ (id)sharedManager;

@end
