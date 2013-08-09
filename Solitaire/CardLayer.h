//
//  CardLayer.h
//  Solitaire
//
//  Created by Bo Wang on 4/24/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Card.h"

@interface CardLayer : CALayer
@property (strong, nonatomic) Card *card;
@property (assign, nonatomic) BOOL faceUp;

-(id)initWithCard:(Card*)c;
//-(void)setImage:(BOOL)isFaceUp;

@end
    