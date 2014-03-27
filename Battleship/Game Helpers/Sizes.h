//
//  Sizes.h
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"

@interface Sizes : NSObject

#define VISUAL_BAR_RATIO 4
#define MINI_MAP_RATIO 6

@property CGFloat tileWidth;
@property CGFloat tileHeight;

@property CGFloat visualBarWidth;
@property CGFloat visualBarHeight;

@property CGFloat fullScreenWidth;
@property CGFloat fullScreenHeight;

@property CGFloat miniMapWidth;
@property CGFloat miniMapHeight;

- (instancetype) initSizesWithFrameSize:(CGSize) frameSize;

@end
