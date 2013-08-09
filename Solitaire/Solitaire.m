//
//  Solitaire.m
//  Solitaire
//
//  Created by Bo Wang on 4/24/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "Solitaire.h"
#import "Card.h"

@implementation Solitaire {
    NSMutableArray *stock_;
    NSMutableArray *waste_;
    NSMutableArray *foundation_[4];
    NSMutableArray *tableau_[7];
    NSMutableArray *faceUpCards;
}

#define kStock @"stock"
#define kWaste @"waste"
#define kFoundation0 @"foundation0"
#define kFoundation1 @"foundation1"
#define kFoundation2 @"foundation2"
#define kFoundation3 @"foundation3"
#define kTableau0 @"tableau0"
#define kTableau1 @"tableau1"
#define kTableau2 @"tableau2"
#define kTableau3 @"tableau3"
#define kTableau4 @"tableau4"
#define kTableau5 @"tableau5"
#define kTableau6 @"tableau6"



-(id)init {
    self = [super init];
    [self freshGame];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        stock_ = [aDecoder decodeObjectForKey:kStock];
        waste_ = [aDecoder decodeObjectForKey:kWaste];
        foundation_[0] = [aDecoder decodeObjectForKey:kFoundation0];
        foundation_[1] = [aDecoder decodeObjectForKey:kFoundation1];
        foundation_[2] = [aDecoder decodeObjectForKey:kFoundation2];
        foundation_[3] = [aDecoder decodeObjectForKey:kFoundation3];
        tableau_[0] = [aDecoder decodeObjectForKey:kTableau0];
        tableau_[1] = [aDecoder decodeObjectForKey:kTableau1];
        tableau_[2] = [aDecoder decodeObjectForKey:kTableau2];
        tableau_[3] = [aDecoder decodeObjectForKey:kTableau3];
        tableau_[4] = [aDecoder decodeObjectForKey:kTableau4];
        tableau_[5] = [aDecoder decodeObjectForKey:kTableau5];
        tableau_[6] = [aDecoder decodeObjectForKey:kTableau6];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:stock_ forKey:kStock];
    [aCoder encodeObject:waste_ forKey:kWaste];
    
    [aCoder encodeObject:foundation_[0] forKey:kFoundation0];
    [aCoder encodeObject:foundation_[1] forKey:kFoundation1];
    [aCoder encodeObject:foundation_[2] forKey:kFoundation2];
    [aCoder encodeObject:foundation_[3] forKey:kFoundation3];
    
    [aCoder encodeObject:tableau_[0] forKey:kTableau0];
    [aCoder encodeObject:tableau_[1] forKey:kTableau1];
    [aCoder encodeObject:tableau_[2] forKey:kTableau2];
    [aCoder encodeObject:tableau_[3] forKey:kTableau3];
    [aCoder encodeObject:tableau_[4] forKey:kTableau4];
    [aCoder encodeObject:tableau_[5] forKey:kTableau5];
    [aCoder encodeObject:tableau_[6] forKey:kTableau6];
}



-(void)freshGame{
    NSMutableArray *deck = [Card deck];
    stock_ = [[NSMutableArray alloc] init];
    waste_ = [[NSMutableArray alloc] init];
    faceUpCards = [[NSMutableArray alloc] init];
    for (int i=0; i<4; i++) {
        foundation_[i] = [[NSMutableArray alloc] init];
    }
    for (int i=0; i<7; i++) {
           tableau_[i] = [[NSMutableArray alloc] init];
    }
 
    int index = 0;
    NSUInteger count = [deck count];
    for (NSUInteger i=0; i<count; i++) {
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [deck exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    for (int i=0; i<24; i++){
        [stock_ addObject:deck[index]];
        index++;
    }
    
    for (int i=0; i<7; i++){
        int j=0;
        while(j<=i){
            Card *card = [deck objectAtIndex:index];
            if (j == i) {
                [faceUpCards addObject:card];
            }
            [tableau_[i] addObject:deck[index]];
            index++;
            j++;
        }
    }

}

-(NSArray*)stock{
    return stock_;
}

-(NSArray*)waste{
    return waste_;
}

-(NSArray*)foundation:(int)i{
    return foundation_[i];
}

-(NSArray*)tableau:(int)i{
    return tableau_[i];
}

-(BOOL)isCardFaceUp:(Card*)card{
    for (Card *mycard in faceUpCards) {
        if ([mycard isEqual:card]) {
            return YES;
        }
    }
    return NO;
}

-(NSArray*)fanBeginningWithCard:(Card*)card{
    NSMutableArray *fan = [[NSMutableArray alloc] init];
    int i=0;
    int j=0;
    for (i=0; i<7; i++) {
        if ([tableau_[i] count] > 0) {
            for (j=0; j<[tableau_[i] count]; j++) {
                if ([[tableau_[i] objectAtIndex:j] isEqual:card]) {
                    goto label1;
                }
            }
        }
    }
    label1:
    for (int flag=j; flag<[tableau_[i] count]; flag++) {
        [fan addObject:[tableau_[i] objectAtIndex:flag]];
   
    }
        
    return fan;
}

-(BOOL)canDropCard:(Card*)c onFoundation:(int)i{
    if ([[waste_ lastObject] isEqual:c]) {
            if (c.rank == 1) {
                if ([foundation_[i] count] ==0) {
                    return YES;
                }
            } else {
                Card *topCard = [foundation_[i] lastObject];
                if ((c.rank - topCard.rank)==1 && c.suit == topCard.suit){
                    return YES;
                }
            }
    } else {
        for (int j=0; j<7; j++) {
            if ([[tableau_[j] lastObject] isEqual:c]) {
                if (c.rank == 1) {
                    if ([foundation_[i] count] ==0) {
                        return YES;
                    }
                } else {
                    Card *topCard = [foundation_[i] lastObject];
                    if ((c.rank - topCard.rank)==1 && c.suit == topCard.suit){
                        return YES;
                    }
                }
            }
        }
    }
    
    return NO;
}
-(void)didDropCard:(Card*)c onFoundation:(int)i{
    if ([[waste_ lastObject] isEqual:c]) {
        [foundation_[i] addObject:c];
        [waste_ removeLastObject];
        return;
    } else {
        for (int j=0; j<7; j++) {
            if ([[tableau_[j] lastObject] isEqual:c]) {
                [foundation_[i] addObject:c];
                [tableau_[j] removeLastObject];
                return;
            }
        }
    }
}
-(BOOL)canDropCard:(Card*)c onTableau:(int)i{
    Card *lastCard = [tableau_[i] lastObject];
    if (lastCard) {
        if ((lastCard.suit == 0 || lastCard.suit == 1) && (c.suit == 0 || c.suit == 1)) {
            return NO;
        }
        if ((lastCard.suit == 2 || lastCard.suit ==3) && (c.suit == 2 || c.suit == 3)) {
            return NO;
        }
        
        if ((lastCard.rank - c.rank) == 1) {
            return YES;
        }
    } else {
        return YES;
    }
    return NO;
}
-(void)didDropCard:(Card*)c onTableau:(int)i{
    if ([[waste_ lastObject] isEqual:c]) {
        [tableau_[i] addObject:c];
        [waste_ removeLastObject];
        return;
    } else {
        for (int j=0; j<7; j++) {
            if ([[tableau_[j] lastObject] isEqual:c] && i!=j) {
                [tableau_[i] addObject:c];
                [tableau_[j] removeLastObject];
                return;
            }
        }
    }
}

-(void)didDropFan:(NSArray*)cards onTableau:(int)i{
    for (int j=0; j<7; j++) {
        if ([[tableau_[j] lastObject] isEqual:[cards lastObject]]) {
            const int n = [cards count];
            for (int k=0; k<n; k++) {
                [tableau_[j] removeLastObject];
            }
        }
    }
    for (Card *card in cards) {
        [tableau_[i] addObject:card];
    }
}
-(BOOL)canFlipCard:(Card*)c{
    for (int i=0; i<7; i++){
        Card *card = [tableau_[i] lastObject];
        if ([card isEqual:c] && [self isCardFaceUp:c] == NO) {
            return YES;
        }
    }
    return NO;
}
-(void)didFlipCard:(Card*)c{
    [faceUpCards addObject:c];
}
-(BOOL)canDealCard{
    if ([stock_ count] == 0) {
        return NO;
    }
    return YES;
}
-(void)didDealCard{
    Card *deal = [stock_ lastObject];
    [self didFlipCard:deal];
    [faceUpCards addObject:deal];
    [waste_ addObject:deal];
    [stock_ removeLastObject];
    
}
-(void)collectWasteCardsIntoStock{
    if ([stock_ count] == 0) {
        while ([waste_ count] !=0) {
            Card *card = [waste_ lastObject];
            [faceUpCards removeObject:card];
            [stock_ addObject:card];
            [waste_ removeLastObject];
        }
    }
}

-(BOOL)gameWon {
    for (int i=0; i<4; i++) {
        NSLog(@"%d",[foundation_[i] count]);
    }
    for (int i=0; i<4; i++) {
        if ([foundation_[i] count] != 13) {
            return NO;
        }
    }
    NSLog(@"You Win");
    return YES;
}
@end
