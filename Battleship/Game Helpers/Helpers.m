//
//  Helpers.m
//  Battleship
//
//  Created by Rayyan Khoury on 2/28/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

-(instancetype) init{
    self = [super init];
    return self;
}

// Returns a coordinate of the click to coordinate value
- (Coordinate*) fromTextureToCoordinate:(CGPoint) point {
    return [[Coordinate alloc] initWithXCoordinate:(int)(point.x/(tileWidth))
                                      YCoordinate:(int)(point.y/(tileHeight))
                                   initiallyFacing: NONE];
    return nil;
}

@end
