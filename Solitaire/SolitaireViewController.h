//
//  SolitaireViewController.h
//  Solitaire
//
//  Created by Bo Wang on 4/24/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Solitaire.h"


@interface SolitaireViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *klondikeView;
-(void)dragCardsToPosition:(CGPoint)position animate:(BOOL)animate;

- (IBAction)newGame:(id)sender;
@end
