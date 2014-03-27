//
//  Names.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Names : NSObject

// Node Names
@property (strong, nonatomic) NSString* overallNodeName;
@property (strong, nonatomic) NSString* gesturesNodeName;
@property (strong, nonatomic) NSString* backgroundNodeName;
@property (strong, nonatomic) NSString* visualBarNodeName;
@property (strong, nonatomic) NSString* foregroundNodeName;
@property (strong, nonatomic) NSString* activeShipsNodeName;
@property (strong, nonatomic) NSString* destroyedShipsNodeName;
@property (strong, nonatomic) NSString* miniMapNodeName;

// Sprite Names
@property (strong, nonatomic) NSString* background1SpriteName;
@property (strong, nonatomic) NSString* background2SpriteName;
@property (strong, nonatomic) NSString* coralSpriteName;
@property (strong, nonatomic) NSString* hostBaseSpriteName;
@property (strong, nonatomic) NSString* joinBaseSpriteName;
@property (strong, nonatomic) NSString* visualBarSpriteName;
@property (strong, nonatomic) NSString* miniMapSpriteName;

// Image Names - Background
@property (strong, nonatomic) NSString* baseImageName;
@property (strong, nonatomic) NSString* coralImageName;
@property (strong, nonatomic) NSString* moveRangeImageName;
@property (strong, nonatomic) NSString* waterBackgroundImageName;

// Image Names - Mini Map
@property (strong, nonatomic) NSString* miniMapGreenBaseImageName;
@property (strong, nonatomic) NSString* miniMapGreenDotImageName;
@property (strong, nonatomic) NSString* miniMapImageName;
@property (strong, nonatomic) NSString* miniMapRangeImageName;
@property (strong, nonatomic) NSString* miniMapRedBaseImageName;
@property (strong, nonatomic) NSString* miniMapRedDotImageName;

// Image Names - Ships
@property (strong, nonatomic) NSString* cruiserImageName;
@property (strong, nonatomic) NSString* destroyerImageName;
@property (strong, nonatomic) NSString* mineLayerImageName;
@property (strong, nonatomic) NSString* radarBoatImageName;
@property (strong, nonatomic) NSString* torpedoBoatImageName;

// Image Names - Visual Bar
@property (strong, nonatomic) NSString* destroyedArmourImageName;
@property (strong, nonatomic) NSString* fireTorpedoImageName;
@property (strong, nonatomic) NSString* heavyArmourImageName;
@property (strong, nonatomic) NSString* moveImageName;
@property (strong, nonatomic) NSString* normalArmourImageName;
@property (strong, nonatomic) NSString* rotateImageName;
@property (strong, nonatomic) NSString* visualBarImageName;

// Methods
- (instancetype) initNames;

@end
