//
//  Sizes.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-07.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Sizes.h"

@implementation Sizes

- (instancetype) initSizesWithFrameSize:(CGSize) frameSize{
    self = [super init];
    if (self) {
        _fullScreenWidth = frameSize.width;
        _fullScreenHeight = frameSize.height;
        
        _visualBarWidth = _fullScreenWidth / VISUAL_BAR_RATIO;
        _visualBarHeight = _fullScreenHeight;
        
        _tileWidth  = (_fullScreenWidth - _visualBarWidth) / GRID_SIZE;
        _tileHeight = _visualBarHeight / GRID_SIZE;
        
        _miniMapWidth = _fullScreenHeight / MINI_MAP_RATIO;
        _miniMapHeight = _fullScreenHeight / MINI_MAP_RATIO;
    }
    return self;
}

@end