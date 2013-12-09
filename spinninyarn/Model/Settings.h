//
//  Settings.h
//  spinninyarn
//
//  Created by Kern Jackson on 11/25/13.
//  Copyright (c) 2013 Kern Jackson. All rights reserved.
//
//  Seems like I need this, so that I'm not always having to check the NSDefaults file everytime I calculate the score.
//  I suppose this would do all the writing and reading to NSDefaults, though I'm not sure if this actually solve the problem. Assuming it solves any problem at all. Intend to work on Farkle class to achive MVP by midnight Sunday December 15, 2013.

#import <Foundation/Foundation.h>

@interface Settings : NSUserDefaults
{
    BOOL penalty;
    BOOL minimum;
    BOOL hotdice;
    BOOL stealing;
    
    NSNumber *playTo;
    NSNumber *minimumScore;
    NSNumber *difficulty;
}
/*
@property (nonatomic, retain) NSNumber penalty;
@property (nonatomic, retain) NSNumber minimum;
@property (nonatomic, retain) NSNumber hotdice;
@property (nonatomic, retain) NSNumber stealing;
@property (nonatomic, retain) NSNumber *playTo;
@property (nonatomic, retain) NSNumber *minimumScore;
@property (nonatomic, retain) NSNumber *difficulty;
*/
@end
