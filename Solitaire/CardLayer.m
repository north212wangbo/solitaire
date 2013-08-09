//
//  CardLayer.m
//  Solitaire
//
//  Created by Bo Wang on 4/24/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "CardLayer.h"
#import "Card.h"

@implementation CardLayer {
    UIImage *frontImage;
    UIImage *backImage;
}


-(id)initWithCard:(Card *)c{
    self = [super init];
    int suit = c.suit;
    int rank = c.rank;
    self.card = [[Card alloc] initWithRank:rank Suit:suit];

    frontImage = imageForCard(rank, suit);
    backImage = [UIImage imageNamed:@"back-blue-150-2.png"];


    self.contents = (id) frontImage.CGImage;
    self.contentsGravity = kCAGravityResizeAspect;
    return self;
}

UIImage *imageForCard(int rank, int suit) {  // rank =1..13, suit = 0..3
    static NSString *suits[] = {@"spades", @"clubs", @"diamonds", @"hearts"};
    static NSString *ranks[] = {@"", @"a", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"j", @"q", @"k"};
    NSString *imageName = [NSString stringWithFormat:@"%@-%@-150.png", suits[suit], ranks[rank]];
    return [UIImage imageNamed:imageName];
}

-(void)setFaceUp:(BOOL)faceUp {
    if (faceUp){
        self.contents = (id)frontImage.CGImage;
    } else {
        self.contents = (id) backImage.CGImage;
    }
}
@end
