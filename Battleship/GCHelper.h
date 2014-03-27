//
//  GCHelper.h
//  Battleship
//
//  Created by Robert Schneidman on 3/7/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GCHelperDelegate
//-(void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
@end



@interface GCHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate> {
    UIViewController *rootViewController;
    GKMatch *match;
    id <GCHelperDelegate> delegate;
    NSMutableDictionary *playersDict;
    GKInvite *pendingInvite;
    NSArray *pendingPlayersToInvite;
}

@property (strong, nonatomic) UIViewController* rootViewController;
@property (retain) GKMatch *match;
@property (strong, nonatomic) GKLocalPlayer* localPlayer;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (assign) id <GCHelperDelegate> delegate;
@property (retain) NSMutableDictionary *playersDict;
@property (retain) GKInvite *pendingInvite;
@property (retain) NSArray *pendingPlayersToInvite;

+ (GCHelper *)sharedInstance:(UIViewController*) rootView;
- (void)authenticateLocalUser;
- (IBAction)joinBattleshipMatch: (id) sender;


@end
