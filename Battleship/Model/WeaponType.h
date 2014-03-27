//
//  Weapon.h
//  Battleship
//
//  Created by Robert Schneidman on 2/3/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeaponType : NSObject

typedef enum WeaponType
{
    HEAVY_CANNON,
    CANNON,
    TORPEDO,
} Weapon;

@end
