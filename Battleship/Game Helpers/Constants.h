//
//  Names.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject


// Constants
#define VISUAL_BAR_RATIO 4
#define MINI_MAP_RATIO 6
#define GRID_SIZE 30
#define MAX_TORPEDO_INTERVALS 50
#define MIN_TORPEDO_INTERVALS 0
#define MAX_SHIP_INTERVALS 100
#define MIN_SHIP_INTERVALS 0

// Scaling
#define MAX_X_SCALE 3
#define MAX_Y_SCALE 3
#define MIN_X_SCALE 1
#define MIN_Y_SCALE 1
#define SCALE_CHANGE 0.01
#define SCALE 1
#define MIN_X_POSITION 0
#define MIN_Y_POSITION 0

// Size constants
extern CGFloat const fullScreenWidth;
extern CGFloat const fullScreenHeight;
extern CGFloat const tileWidth;
extern CGFloat const tileHeight;
extern CGFloat const visualBarWidth;
extern CGFloat const visualBarHeight;
extern CGFloat const miniMapWidth;
extern CGFloat const miniMapHeight;

// Node Names
extern NSString *const overallNodeName;
extern NSString *const gesturesNodeName;
extern NSString *const backgroundNodeName;
extern NSString *const visualBarNodeName;
extern NSString *const foregroundNodeName;
extern NSString *const activeShipsNodeName;
extern NSString *const destroyedShipsNodeName;
extern NSString *const miniMapNodeName;

// Sprite Names
extern NSString *const background1SpriteName;
extern NSString *const background2SpriteName;
extern NSString *const coralSpriteName;
extern NSString *const hostBaseSpriteName;
extern NSString *const joinBaseSpriteName;
extern NSString *const visualBarSpriteName;
extern NSString *const miniMapSpriteName;

// Image Names - Background
extern NSString *const baseImageName;
extern NSString *const coralImageName;
extern NSString *const moveRangeImageName;
extern NSString *const waterBackgroundImageName;

// Image Names - Mini Map
extern NSString *const miniMapGreenBaseImageName;
extern NSString *const miniMapGreenDotImageName;
extern NSString *const miniMapImageName;
extern NSString *const miniMapRangeImageName;
extern NSString *const miniMapRedBaseImageName;
extern NSString *const miniMapRedDotImageName;

// Image Names - Ships
extern NSString *const cruiserImageName;
extern NSString *const destroyerImageName;
extern NSString *const mineLayerImageName;
extern NSString *const radarBoatImageName;
extern NSString *const torpedoBoatImageName;

// Image Names - Visual Bar
extern NSString *const destroyedArmourImageName;
extern NSString *const fireTorpedoImageName;
extern NSString *const heavyArmourImageName;
extern NSString *const moveImageName;
extern NSString *const normalArmourImageName;
extern NSString *const rotateImageName;
extern NSString *const visualBarImageName;

// Image Names - Weapons
extern NSString *const torpedoImageName;

@end
