//
//  BattleshipGame.h
//  Battleship
//
//  Created by Robert Schneidman on 2/9/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "Fleet.h"
#import "Ship.h"
#import "Player.h"
#import "GCHelper.h"
#import "TerrainType.h"

@interface BattleshipGame : NSObject 

@property BOOL myTurn;
@property (strong, nonatomic) Map* gameMap;
@property BOOL dataSent;
@property(strong, nonatomic) GCHelper* gameCenter;
@property(strong, nonatomic) Player* localPlayer;

+ (BattleshipGame *)sharedInstance;
-(void)moveShipfrom: (Coordinate*) origin
                 to:(Coordinate*) destination;
-(NSMutableArray*) getValidMovesFrom:(Coordinate*)origin
                  withRadarPositions:(BOOL) radarPositions;
//-(Coordinate*) getCoordOfShip: (NSString*) shipName;
-(NSMutableArray*) getValidActionsFrom:(Coordinate*)origin;
-(Coordinate*) fireTorpedo: (Coordinate*) origin;
-(NSMutableArray*) getShipDamages: (Coordinate*) origin;
-(NSMutableArray*) getValidRotationsFrom:(Coordinate*)origin;
-(int)getShipIndexWithName:(NSString*)shipName;
-(NSMutableArray*) getCanonRange:(Coordinate*)origin;
-(void) damageShipSegment:(Coordinate*)impactCoord ownedBy:(BOOL) you with:(BOOL) heavyCannon and:(BOOL) adjacentSquare;
-(void)updateMap:(Fleet*) updatedFleet;
-(void)moveEnemyShipfrom:(Coordinate *)origin to:(Coordinate *)destination;
-(BOOL)isShipDestroyed:(NSString *) shipName;
-(void)removeBaseSquare:(Coordinate*) destroyedBaseSquare;
-(void)updateDockingZone;
-(void) isAbleToDropMine:(MineLayer *)mineLayer;
-(void) isAbleToPickupMine:(MineLayer *)mineLayer;
-(void) explodeKamikazeBoat: (Kamikaze*)k at: (Coordinate*) explosionLocation;

@end
