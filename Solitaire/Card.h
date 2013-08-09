//
//  Cards.h
//  Solitaire
//
//  Created by Bo Wang on 4/24/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject <NSCopying, NSCoding>
@property (nonatomic) int suit;
@property (nonatomic) int rank;
-(id)initWithRank:(int)r Suit:(int)s;
+(NSMutableArray*)deck;

@end
