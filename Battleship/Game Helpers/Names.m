//
//  Names.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Names.h"

@implementation Names

- (instancetype) initNames {
    self = [super init];
    if (self) {
        [self initContainerNames];
        [self initSpriteNames];
        [self initImageNames];
    }
    return self;
}

// Initializes the names of the overall containers
- (void) initContainerNames {
    
    // Container Names
    _overallNodeName = @"OverallContainer";
    _gesturesNodeName = @"GesturesContainer";
    _backgroundNodeName = @"BackgroundContainer";
    _visualBarNodeName = @"VisualBarContainer";
    _foregroundNodeName = @"ForegroundContainer";
    _activeShipsNodeName = @"ActiveShipsContainer";
    _destroyedShipsNodeName = @"DestroyedShipsContainer";
    _miniMapNodeName = @"MiniMapContainer";
    
}

// Initilaizes the sprite names
- (void) initSpriteNames {
    
    // Sprite Names
    _background1SpriteName = @"Background1Sprite";
    _background2SpriteName = @"Background2Sprite";
    _hostBaseSpriteName = @"HostBaseSprite";
    _joinBaseSpriteName = @"JoinBaseSprite";
    _coralSpriteName = @"CoralSprite";
    _visualBarSpriteName = @"VisualBarSprite";
    _miniMapSpriteName = @"MiniMapSprite";
    
}

// Initializes the image names
- (void) initImageNames {
    
    // Background Images
    _baseImageName = @"Base";
    _coralImageName = @"Corals";
    _moveRangeImageName = @"MoveRange";
    _waterBackgroundImageName = @"WaterBackgrounds";
    
    // Mini Map Images
    _miniMapGreenBaseImageName = @"MiniMapGreenBase";
    _miniMapGreenDotImageName = @"MiniMapGreenDot";
    _miniMapImageName = @"MiniMap";
    _miniMapRangeImageName = @"MiniMapRange";
    _miniMapRedBaseImageName = @"MiniMapRedBase";
    _miniMapRedDotImageName = @"MiniMapRedDot";
    
    // Ship Images
    _cruiserImageName = @"Cruiser";
    _destroyerImageName = @"Destroyer";
    _mineLayerImageName = @"MineLayer";
    _radarBoatImageName = @"RadarBoat";
    _torpedoBoatImageName = @"TorpedoBoat";
    
    // Visual Bar Images
    _destroyedArmourImageName = @"DestroyedArmour";
    _fireTorpedoImageName = @"FireTorpedo";
    _heavyArmourImageName = @"HeavyArmour";
    _moveImageName = @"Move";
    _normalArmourImageName = @"NormalArmour";
    _rotateImageName = @"Rotate";
    _visualBarImageName = @"VisualBar";
}

@end