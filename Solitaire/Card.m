//
//  Cards.m
//  Solitaire
//
//  Created by Bo Wang on 4/24/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "Card.h"


enum{SPADES, CLUBS, DIAMONDS, HEARTS};
@implementation Card

-(id)initWithRank:(int)r Suit:(int)s{
    self = [super init];
    self.suit = s;
    self.rank = r;
    return self;
}

+(NSMutableArray*)deck {
    NSMutableArray *deck = [[NSMutableArray alloc] initWithCapacity:52];
    for (int suit = 0; suit <= 3; suit++) {
        for (int rank = 1; rank <= 13; rank++) {
            Card *card = [[Card alloc] initWithRank:rank Suit:suit];
            [deck addObject:card];
        }
    }
    return deck;
}

-(id)copyWithZone:(NSZone *)zone{
    Card *card = [[[self class] allocWithZone:zone] init];
    card.suit = self.suit;
    card.rank = self.rank;
    return card;
}

-(BOOL)isEqual:(id)other{
    return ([self hash] == [other hash]);
}

-(NSUInteger)hash{
    NSUInteger hash = 0;
    hash = self.suit * 13 + self.rank;
    return hash;
}

#define kSuit @"suit"
#define kRank @"rank"

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.suit = [aDecoder decodeIntegerForKey:kSuit];
        self.rank = [aDecoder decodeIntegerForKey:kRank];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.suit forKey:kSuit];
    [aCoder encodeInteger:self.rank forKey:kRank];
}

@end
