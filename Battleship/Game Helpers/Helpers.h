//
//  Helpers.h
//  Battleship
//
//  Created by Rayyan Khoury on 2/28/2014.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coordinate.h"
#import "Constants.h"

@interface Helpers : NSObject

- (Coordinate*) fromTextureToCoordinate:(CGPoint) point;

@end
