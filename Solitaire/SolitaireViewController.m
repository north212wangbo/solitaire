//
//  SolitaireViewController.m
//  Solitaire
//
//  Created by Bo Wang on 4/24/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "SolitaireViewController.h"
#import "CardLayer.h"
#import <QuartzCore/QuartzCore.h>
#import "SolitaireAppDelegate.h"
#import "Solitaire.h"
#import "Card.h"
#define FAN_OFFSET 0.2
#define DEAL_NUMBER 3

@interface SolitaireViewController ()

@end

@implementation SolitaireViewController{
    Solitaire *solitaire;
    CALayer *stockLayer;
    CALayer *wasteLayer;
    CALayer *foundationLayers[4];
    CALayer *tableauLayers[7];
    
    NSMutableDictionary *cardToLayerDictionary; //maps cards to CardLayer
    NSMutableArray *deck;
    
    CGFloat topZPosition;
    CardLayer *draggingCardLayer;
    NSMutableArray *draggingFan;
    CGPoint touchStartPoint;
    CGPoint touchStartLayerPosition;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    SolitaireAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    solitaire = appDelegate.solitaire;
    
	// Do any additional setup after loading the view, typically from a nib.
    
    self.klondikeView.layer.name = @"background";
    topZPosition = 1.0;
    
    stockLayer = [CALayer layer];
    stockLayer.name = @"stock";
    stockLayer.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:0.3].CGColor;
    [self.klondikeView.layer addSublayer:stockLayer];
    
    wasteLayer = [CALayer layer];
    wasteLayer.name = @"stock";
    wasteLayer.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:0.3].CGColor;
    [self.klondikeView.layer addSublayer:wasteLayer];
    
    for (int i=0; i<4; i++) {
        foundationLayers[i] = [CALayer layer];
        foundationLayers[i].name = @"foundation";
        foundationLayers[i].backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:0.3].CGColor;
        [self.klondikeView.layer addSublayer:foundationLayers[i]];
    }
    
    for (int i=0; i<7; i++) {
        tableauLayers[i] = [[CALayer alloc] init];
        tableauLayers[i].name = @"tableau";
        tableauLayers[i].backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:0.3].CGColor;
        [self.klondikeView.layer addSublayer:tableauLayers[i]];
    }

    
    deck = [Card deck];
    cardToLayerDictionary = [[NSMutableDictionary alloc] init];
    
    for(Card *card in deck){
        CardLayer *cardLayer = [[CardLayer alloc] initWithCard:card];
        cardLayer.name = @"card";
        [self.klondikeView.layer addSublayer:cardLayer];
        [cardToLayerDictionary setObject:cardLayer forKey:card];
    }
    
}

-(void)viewWillLayoutSubviews{
    const CGFloat width = self.klondikeView.frame.size.width;
    const CGFloat height = self.klondikeView.frame.size.height;
    const BOOL portrait = width < height;

    
    if(!portrait){
        const CGFloat m = 20;
        const CGFloat t = 20;
        const CGFloat s = 40;
        const CGFloat gap = 10;
        const CGFloat cardHeight = 135;
        const CGFloat cardWidth = 90;
        
        stockLayer.frame = CGRectMake(m,t,cardWidth,cardHeight);
        wasteLayer.frame = CGRectMake(m+cardWidth+gap,t,cardWidth,cardHeight);
        
        for (int i=0; i<4; i++) {
            foundationLayers[i].frame = CGRectMake(m+cardWidth*3+gap*(3+i)+cardWidth*i,t,cardWidth,cardHeight);
        }
        
        for (int i=0; i<7; i++) {
            tableauLayers[i].frame = CGRectMake(m+gap*i+cardWidth*i,t+cardHeight+s,cardWidth,cardHeight);
        }
    } else {
        const CGFloat m = 30;
        const CGFloat t = 20;
        const CGFloat s = 30;
        const CGFloat gap = 30;
        const CGFloat cardHeight = 135;
        const CGFloat cardWidth = 90;
        
        stockLayer.frame = CGRectMake(m,t,cardWidth,cardHeight);
        wasteLayer.frame = CGRectMake(m+cardWidth+gap,t,cardWidth,cardHeight);
        
        for (int i=0; i<4; i++) {
            foundationLayers[i].frame = CGRectMake(m+cardWidth*3+gap*(3+i)+cardWidth*i,t,cardWidth,cardHeight);
        }
        
        for (int i=0; i<7; i++) {
            tableauLayers[i].frame = CGRectMake(m+gap*i+cardWidth*i,t+cardHeight+s,cardWidth,cardHeight);
        }
    }
    
    [self layoutCards];
}

-(void)viewDidLayoutSubviews {
    //[self party];
}

-(void)layoutCards {
    CGFloat z= topZPosition;
    const CGFloat cardHeight = 150;
    const CGFloat cardWidth = 90;
    
    NSArray *stock = [solitaire stock];
    NSArray *waste = [solitaire waste];

    for (Card *card in stock) {        
        CardLayer *cardLayer = [cardToLayerDictionary objectForKey:card];
        cardLayer.frame = stockLayer.frame;
        [cardLayer setFaceUp:[solitaire isCardFaceUp:card]];
        cardLayer.zPosition = z++;
    }
    
    for (Card *card in waste) {
        CardLayer *cardLayer = [cardToLayerDictionary objectForKey:card];
        cardLayer.frame = wasteLayer.frame;
        [cardLayer setFaceUp:[solitaire isCardFaceUp:card]];
    }
    
    for (int i=0; i<4; i++) {
        NSArray *foundation = [solitaire foundation:i];
        for (Card *card in foundation) {
            CardLayer *cardLayer = [cardToLayerDictionary objectForKey:card];
            cardLayer.frame = foundationLayers[i].frame;
        }
    }
    
    for (int i=0; i<7; i++) {
        NSArray *tableau = [solitaire tableau:i];
        const CGPoint origin = tableauLayers[i].frame.origin;
        int j=0;
        for (Card *card in tableau) {
            CardLayer *cardLayer = [cardToLayerDictionary objectForKey:card];
            cardLayer.frame = CGRectMake(origin.x, origin.y+j*FAN_OFFSET*cardHeight, cardWidth, cardHeight);
            cardLayer.position = CGPointMake(tableauLayers[i].position.x,tableauLayers[i].position.y+j*FAN_OFFSET*cardHeight);
            [cardLayer setFaceUp:[solitaire isCardFaceUp:card]];
            cardLayer.zPosition = z++;
            j++;
        }
    }
    
    topZPosition = z;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.klondikeView];
    CGPoint hitTestPoint = [self.klondikeView.layer convertPoint:touchPoint toLayer:self.klondikeView.layer.superlayer];
    CALayer *layer = [self.klondikeView.layer hitTest:hitTestPoint];
    touchStartPoint = layer.position;
    const float cardWidth = 90;

    
    if (layer == nil) return;
   
    
    if ([layer.name isEqual:@"card"]) {
        CardLayer *cardLayer = (CardLayer*) layer;
        Card *card = cardLayer.card;            
        draggingCardLayer = (CardLayer*)layer;


        if ([solitaire isCardFaceUp:card]){//if a faceup card is clicked, see if it can be fliped, dealed, dropped on foundation, collect to stock
            draggingCardLayer.zPosition = topZPosition++;
            if ([[touches anyObject] tapCount] >= 2) {//if double click , see if card can drop on foundation
                for (int i=0; i<4; i++){
                    if ([solitaire canDropCard:card onFoundation:i]){
                        [CATransaction begin];
                        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                        draggingCardLayer.position = foundationLayers[i].position;
                        [solitaire didDropCard:card onFoundation:i];
                        [CATransaction commit];
                        touchStartPoint = draggingCardLayer.position;
                        if([solitaire gameWon])
                            [self party];
                        break;
                    }
                }
            } else {//if it's in the middle of a tableau, if yes, add to fan
                for (int i=0; i<7; i++) {
                    if ([[solitaire tableau:i] count]!=0) {
                        if ([self isMiddleofTableau:draggingCardLayer inTableau:i]) {
                            [self addToDragFanTableau:i withLayer:draggingCardLayer];
                        }
                    }
                }
                [self dragCardsToPosition:touchPoint animate:YES];
            }
        } else if ([solitaire canFlipCard:card]){
            [cardLayer setFaceUp:YES];
            [solitaire didFlipCard:card];
        }
        
        if ([[[solitaire stock] lastObject] isEqual:card]){//Deal card from stock to waste, add animation
            NSMutableArray *positions = [[NSMutableArray alloc] init];
            for (int i=0; i< DEAL_NUMBER; i++) {

                if ([solitaire canDealCard]) {
                    Card *lastCard = [[solitaire stock] lastObject];
                    CardLayer *clayer = [cardToLayerDictionary objectForKey:lastCard];
                    [solitaire didDealCard];
                    const CGPoint position = CGPointMake(stockLayer.position.x+i*0.4*cardWidth, stockLayer.position.y);
                    [positions addObject:[NSValue valueWithCGPoint:position]];
                    
                    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                    [anim setValues:[positions mutableCopy]];
                    [anim setDuration:0.2];
                    
                    [clayer setFaceUp:[solitaire isCardFaceUp:lastCard]];
                    clayer.zPosition = topZPosition++;
                    clayer.position = wasteLayer.position;
                    touchStartPoint = draggingCardLayer.position;
                    [clayer addAnimation:anim forKey:@"foo"];
                }
            }
        }
        
    }  else if ([layer.name isEqual:@"stock"]){//collect card from waste to stock
        [solitaire collectWasteCardsIntoStock];
        for (Card *card in [solitaire stock]) {
            CardLayer *cardLayer = [cardToLayerDictionary objectForKey:card];
            [cardLayer setFaceUp:[solitaire isCardFaceUp:card]];
            cardLayer.position = stockLayer.position;
            cardLayer.zPosition = topZPosition++;
        }
    }
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([draggingFan count] != 0) {//dragging fan
        UITouch *touch = [touches anyObject];
        CGPoint p = [touch locationInView:self.klondikeView];
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        draggingCardLayer.position = p;
        const CGFloat off = 0.2*draggingCardLayer.bounds.size.height;
        const int n = [draggingFan count];
        for (int i=1; i<n; i++){
            CardLayer *clayer = [cardToLayerDictionary objectForKey:[draggingFan objectAtIndex:i]];
            clayer.position = CGPointMake(p.x, p.y + i*off);
        }
        [CATransaction commit];
    } else if (draggingCardLayer ) {//dragging single card
        UITouch *touch = [touches anyObject];
        CGPoint p = [touch locationInView:self.klondikeView];
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        draggingCardLayer.position = p;
        [CATransaction commit];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    draggingCardLayer = nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    const CGFloat cardHeight = 150;
    
    if (draggingCardLayer) {//If dragging single card
        if ([draggingFan count] == 0) {//Can it be dropped on foundation?
            for (int i=0; i<4; i++) {
                if ([self canDropInFoundation:draggingCardLayer onFoundation:i] ) {
                    if ([solitaire canDropCard:draggingCardLayer.card onFoundation:i]) {
                        [solitaire didDropCard:draggingCardLayer.card onFoundation:i];
                        draggingCardLayer.position = foundationLayers[i].position;
                        draggingCardLayer = nil;
                        if([solitaire gameWon]){
                            [self party];
                        }
                        return;
                    }
                    
                }
            }
            
            for (int i=0; i<7; i++) {//Can it be dropped on tableau?
                if ([self canDropInTableau:draggingCardLayer onTableau:i]) {
                    [solitaire didDropCard:draggingCardLayer.card onTableau:i];
                    NSArray *tableau = [solitaire tableau:i];
                    CGPoint position = tableauLayers[i].position;
                    int j=[tableau count];
                    float fanOffset = 0.2*cardHeight;
                    float y = position.y+(j-1)*fanOffset;
                    //cardLayer.faceUp = [solitaire isCardFaceUp:card];
                    
                    CGPoint new = CGPointMake(position.x, y);
                    draggingCardLayer.position = new;
                    draggingCardLayer = nil;
                    return;
                }
            }
            draggingCardLayer.position = touchStartPoint;
        } else {//Dragging fan, can it be dropped on tableau?
            for (int i=0; i<7; i++) {
                if ([self canDropInTableau:draggingCardLayer onTableau:i]) {
                    NSArray *tableau = [solitaire tableau:i];
                    CGPoint position = tableauLayers[i].position;
                    int j=[tableau count];
                    float fanOffset = 0.2*cardHeight;  //define fanOffset to 0.2
                    float y = position.y+j*fanOffset;
                
                    
                    CGPoint new = CGPointMake(position.x, y);
                    draggingCardLayer.position = new;
                    
                    const int n = [draggingFan count];
                    for (int i=1; i<n; i++){
                        CardLayer *clayer = [cardToLayerDictionary objectForKey:[draggingFan objectAtIndex:i]];
                        clayer.position = CGPointMake(new.x, new.y + i*fanOffset);
                    }
                    NSArray *cards = [solitaire fanBeginningWithCard:draggingCardLayer.card];
                    [solitaire didDropFan:cards onTableau:i];
                    [draggingFan removeAllObjects];
                    return;
                }
            }
            //If illegal drop, put everything back, dismiss dragging fan
            draggingCardLayer.position = touchStartPoint;
            const CGFloat off = 0.2*draggingCardLayer.bounds.size.height;
            const int n = [draggingFan count];
            for (int i=1; i<n; i++){
                CardLayer *clayer = [cardToLayerDictionary objectForKey:[draggingFan objectAtIndex:i]];
                clayer.position = CGPointMake(touchStartPoint.x, touchStartPoint.y + i*off);
            }
            [draggingFan removeAllObjects];
        }
        
        
    }
    draggingCardLayer = nil;
}


-(void)dragCardsToPosition:(CGPoint)position animate:(BOOL)animate {
    if(!animate){
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    }
    draggingCardLayer.position = position;
    
    if(draggingFan != nil) {
        const CGFloat off = 0.2*draggingCardLayer.bounds.size.height;
        const int n = [draggingFan count];
        for (int i=1; i<n; i++){
            CardLayer *clayer = [cardToLayerDictionary objectForKey:[draggingFan objectAtIndex:i]];
            clayer.position = CGPointMake(position.x, position.y + i*off);
            clayer.zPosition = topZPosition++;
        }
    } 
        

    
    if(!animate){
        [CATransaction commit];
    }
}

- (IBAction)newGame:(id)sender {
    [solitaire freshGame];
    [self layoutCards];
}


-(BOOL)canDropInFoundation:(CALayer*)draggingLayer onFoundation:(int)i{
    const CGFloat cardHeight = 150;
    const CGFloat cardWidth = 90;
    
    if (draggingLayer.position.x>foundationLayers[i].frame.origin.x && draggingLayer.position.x<foundationLayers[i].frame.origin.x+cardWidth && draggingLayer.position.y>foundationLayers[i].frame.origin.y && draggingLayer.position.y<foundationLayers[i].frame.origin.y+cardHeight) {
        return YES;
    }

    return NO;
}

-(BOOL)canDropInTableau:(CALayer*)draggingLayer onTableau:(int)i{
    const CGFloat cardWidth = 90;
    
 
    for (int i=0; i<4; i++) {
        if (touchStartPoint.x == foundationLayers[i].position.x && touchStartPoint.y == foundationLayers[i].position.y) {
            return NO;
        }
    }
    
    if (draggingLayer.position.x>tableauLayers[i].frame.origin.x && draggingLayer.position.x<tableauLayers[i].frame.origin.x+cardWidth && draggingLayer.position.y>tableauLayers[i].position.y && (touchStartPoint.x < tableauLayers[i].frame.origin.x || touchStartPoint.x > tableauLayers[i].frame.origin.x+cardWidth || touchStartPoint.x == wasteLayer.position.x )){
        return [solitaire canDropCard:draggingCardLayer.card onTableau:i];
    }
    return NO;
}

-(BOOL)isMiddleofTableau:(CardLayer*)draggingLayer inTableau:(int)i{//if dragging layer is in middle of a tableau?
    NSArray *tableau = [solitaire tableau:i];
    for (int j=0; j<[tableau count]-1; j++) {
        if ([[tableau objectAtIndex:j] isEqual:draggingLayer.card]) {
            return YES;
        }
    }
    return NO;
}

-(void)addToDragFanTableau:(int)i withLayer:(CardLayer*)draggingLayer{//add tableau[i] member to draggingFan
    draggingFan = [[NSMutableArray alloc] init];
    NSArray *tableau = [solitaire tableau:i];
    int flag = 100;
    for (int j=0; j<[tableau count]; j++) {
        if ([[tableau objectAtIndex:j] isEqual:draggingLayer.card]) {
            flag = j;
        }
        if (j >= flag) {
            [draggingFan addObject:[tableau objectAtIndex:j]];
        }
    }
}

-(void)party {
    const CGRect bounds = self.klondikeView.frame;
    const CGPoint center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
    const CGFloat radius = MIN(bounds.size.width, bounds.size.height)/2 - 200;
    const CGFloat spreadAngle = 1.2 * M_PI;
    const CGFloat dphi = spreadAngle/20;
    const CGFloat phi0 = 0;
    
    NSMutableArray *positions = [[NSMutableArray alloc] init];
    int i=0;
    for (int j=0; j<5; j++){
        for (int k=0; k<4; k++){
            for (int m = 0; m < [[solitaire foundation:k] count]; m++) {
                const CGFloat phi = phi0 - i*dphi;
                const CGPoint pos = CGPointMake(center.x + radius*cosf(phi), center.y - radius*sinf(phi));
                [positions addObject:[NSValue valueWithCGPoint:pos]];
                if (j==4) {
                    [positions addObject:[NSValue valueWithCGPoint:stockLayer.position]];
                }
                CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                [anim setValues:[positions mutableCopy]];
                [anim setDuration:3.0];
                CardLayer *cardLayer = [cardToLayerDictionary objectForKey:[[solitaire foundation:k] objectAtIndex:m]];
                cardLayer.position = stockLayer.position;
                cardLayer.zPosition = topZPosition++;
                
                [cardLayer addAnimation:anim forKey:@"foo"];
                i++;
            }
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
