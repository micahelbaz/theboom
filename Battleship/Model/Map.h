//
//  Map.h
//  Battleship
//
//  Created by Robert Schneidman on 2/5/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TerrainType.h"
#import "Coordinate.h"
#import <SpriteKit/SpriteKit.h>
#import "GCHelper.h"

@interface Map : NSObject

#define GRID_SIZE 30
#define BASE_LENGTH 10
#define BASE_START 10
#define BASE_END 19

@property (strong, nonatomic) NSMutableArray* grid;

-(instancetype) init;
-(void) setCoords: (NSMutableArray*) coords
               to: (Terrain) t;
-(Coordinate*) collisionLocationOfTorpedo: (Coordinate*) firedFrom;
-(void) encodeWithCoder: (NSCoder*) coder;
-(id) initWithCoder:(NSCoder*)coder;
@end
