//
//  Solitaire.h
//  Solitaire
//
//  Created by Bo Wang on 4/24/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Solitaire : NSObject <NSCoding>


-(id)init;
-(void)freshGame;
-(BOOL)gameWon;
-(NSArray*)stock;
-(NSArray*)waste;
-(NSArray*)foundation:(int)i;
-(NSArray*)tableau:(int)i;
-(BOOL)isCardFaceUp:(Card*)card;
-(NSArray*)fanBeginningWithCard:(Card*)card;
-(BOOL)canDropCard:(Card*)c onFoundation:(int)i;
-(void)didDropCard:(Card*)c onFoundation:(int)i;
-(BOOL)canDropCard:(Card*)c onTableau:(int)i;
-(void)didDropCard:(Card*)c onTableau:(int)i;
-(void)didDropFan:(NSArray*)cards onTableau:(int)i;
-(BOOL)canFlipCard:(Card*)c;
-(void)didFlipCard:(Card*)c;
-(BOOL)canDealCard;
-(void)didDealCard;
-(void)collectWasteCardsIntoStock;


@end
