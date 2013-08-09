//
//  SolitaireAppDelegate.m
//  Solitaire
//
//  Created by Bo Wang on 4/24/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "SolitaireAppDelegate.h"

@implementation SolitaireAppDelegate

-(NSString*)solitairePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fileName = [docDir stringByAppendingPathComponent:@"solitaire.archive"];
    return fileName;
}

#define solitaireKey @"solitaire"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *fileName = [self solitairePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSLog(@"file exist");
        NSData *data = [[NSData alloc] initWithContentsOfFile:fileName];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        Solitaire *s = [unarchiver decodeObjectForKey:solitaireKey];
        self.solitaire = [s mutableCopy];
        [unarchiver finishDecoding];
        
    } else {
        self.solitaire = [[Solitaire alloc] init];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground:");
    NSString *fileName =[self solitairePath];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    Solitaire *solitaire =[[Solitaire alloc] init];
    solitaire = self.solitaire;
    
    [archiver encodeObject:solitaire forKey:solitaireKey];
    [archiver finishEncoding];
    [data writeToFile:fileName atomically:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
