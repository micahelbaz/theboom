//
//  TerrainType.h
//  Battleship
//
//  Created by Robert Schneidman on 2/9/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject ()

typedef enum TerrainType
{
    HOST_BASE,
    JOIN_BASE,
    CORAL,
    WATER,
    MOVE_RANGE
} Terrain;

@end
