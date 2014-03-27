//
//  GCHelper.m
//  Battleship
//
//  Created by Robert Schneidman on 3/7/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "GCHelper.h"

@implementation GCHelper


@synthesize match;


#pragma mark Initialization

static GCHelper *sharedHelper = nil;
+ (GCHelper *)sharedInstance:(UIViewController*) rootView {
    if(!sharedHelper){
        sharedHelper = [[GCHelper alloc] initWith:rootView];
    }
    return sharedHelper;
}

-(id)initWith: (UIViewController*) rootView {
    if ((self = [super init])) {
        _rootViewController = rootView;
    }
    return self;
}


#pragma mark User Functions

- (void) authenticateLocalUser
{
    _localPlayer = [GKLocalPlayer localPlayer];
    _localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil)
        {
            [_rootViewController presentViewController:viewController animated:YES completion:nil];
            //showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
            //[self showAuthenticationDialogWhenReasonable: viewController];
        }
        else if (_localPlayer.isAuthenticated)
        {
            //authenticatedPlayer: is an example method name. Create your own method that is called after the loacal player is authenticated.
            //[self authenticatedPlayer: localPlayer];
        }
        else
        {
            //[self disableGameCenter];
        }
    } ;
}

- (IBAction)joinBattleshipMatch: (id) sender
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    
    mmvc.matchmakerDelegate = self;
    [_rootViewController presentViewController:mmvc animated:YES completion:nil];
}

-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [_rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    //[_rootViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    [_rootViewController dismissViewControllerAnimated:YES completion:nil];
     self.match = theMatch;
    match.delegate = self;
   
    if (theMatch.expectedPlayerCount == 0) {
        for (NSString* s in theMatch.playerIDs) {
            NSLog(@"%@", s);
        }
    }
}




@end
