//
//  Names.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Constants.h"

@implementation Constants

// Container Names
NSString *const overallNodeName = @"OverallContainer";
NSString *const gesturesNodeName = @"GesturesContainer";
NSString *const backgroundNodeName = @"BackgroundContainer";
NSString *const visualBarNodeName = @"VisualBarContainer";
NSString *const foregroundNodeName = @"ForegroundContainer";
NSString *const activeShipsNodeName = @"ActiveShipsContainer";
NSString *const destroyedShipsNodeName = @"DestroyedShipsContainer";
NSString *const miniMapNodeName = @"MiniMapContainer";

// Sprite Names
NSString *const background1SpriteName = @"Background1Sprite";
NSString *const background2SpriteName = @"Background2Sprite";
NSString *const hostBaseSpriteName = @"HostBaseSprite";
NSString *const joinBaseSpriteName = @"JoinBaseSprite";
NSString *const coralSpriteName = @"CoralSprite";
NSString *const visualBarSpriteName = @"VisualBarSprite";
NSString *const miniMapSpriteName = @"MiniMapSprite";

// Background Images
NSString *const baseImageName = @"Base";
NSString *const coralImageName = @"Corals";
NSString *const moveRangeImageName = @"MoveRange";
NSString *const waterBackgroundImageName = @"WaterBackgrounds";
    
// Mini Map Images
NSString *const miniMapGreenBaseImageName = @"MiniMapGreenBase";
NSString *const miniMapGreenDotImageName = @"MiniMapGreenDot";
NSString *const miniMapImageName = @"MiniMap";
NSString *const miniMapRangeImageName = @"MiniMapRange";
NSString *const miniMapRedBaseImageName = @"MiniMapRedBase";
NSString *const miniMapRedDotImageName = @"MiniMapRedDot";
    
// Ship Images
NSString *const cruiserImageName = @"Cruiser New";
NSString *const destroyerImageName = @"Destroyer New";
NSString *const mineLayerImageName = @"MineLayer New";
NSString *const radarBoatImageName = @"RadarBoat New";
NSString *const torpedoBoatImageName = @"TorpedoBoat New";
    
// Visual Bar Images
NSString *const destroyedArmourImageName = @"DestroyedArmour";
NSString *const fireTorpedoImageName = @"FireTorpedo";
NSString *const heavyArmourImageName = @"HeavyArmour";
NSString *const moveImageName = @"Move";
NSString *const normalArmourImageName = @"NormalArmour";
NSString *const rotateImageName = @"Rotate";
NSString *const visualBarImageName = @"VisualBar";

// Weapons images
NSString *const torpedoImageName = @"TorpedoBig";

// Heights and Widths of screen
CGFloat const fullScreenWidth = (CGFloat)1024;
CGFloat const fullScreenHeight = (CGFloat)768/31*30;

CGFloat const visualBarWidth = fullScreenWidth / VISUAL_BAR_RATIO;
CGFloat const visualBarHeight = (CGFloat)768/31*30;

CGFloat const tileWidth  = (fullScreenWidth - visualBarWidth) / GRID_SIZE;
CGFloat const tileHeight = fullScreenHeight / GRID_SIZE;

CGFloat const miniMapWidth = fullScreenHeight / MINI_MAP_RATIO;
CGFloat const miniMapHeight = fullScreenHeight / MINI_MAP_RATIO;

@end