//
//  Player.h
//  Battleship
//
//  Created by Micah Elbaz on 3/5/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fleet.h"

@interface Player : NSObject

#define GRID_SIZE 30

@property (strong, nonatomic) NSMutableArray* booleanGrid;
@property (strong, nonatomic) NSMutableArray* radarGrid;
@property (strong, nonatomic) NSMutableArray* baseCoordinates;
@property (strong, nonatomic) NSMutableArray* dockingCoordinates;
@property(strong, nonatomic) Fleet* playerFleet;
@property (strong, nonatomic) Fleet* enemyFleet;
@property NSString* playerID;
@property BOOL isHost;
-initWith: (NSString*) playerID andIsHost:(BOOL) player;
-(void) updateRadarRange;
@end
