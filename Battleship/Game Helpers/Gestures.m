//
//  Gestures.m
//  Battleship
//
//  Created by Rayyan Khoury on 2014-03-09.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import "Gestures.h"

@implementation Gestures

- (instancetype) initGesturesWithNode:(SKNode*) gesturesNode
                              andGame:(BattleshipGame*) game
                            andHelper:(Helpers*) helper {
    
    self = [super init];
    if (self) {
        _game = game;
        _gesturesNode = gesturesNode;
        //_gesturesNode.xScale = 2;
        //_gesturesNode.yScale = 2;
        _helper = helper;
        _initialMaxX = fullScreenWidth - visualBarWidth;
        _initialMaxY = fullScreenHeight;
    }
    return self;
}

// Moves the map around
- (void) updateGesturesPositionWithTranslation:(CGPoint)translation
{
    CGPoint position = [_gesturesNode position];
    
    CGFloat xPos = position.x + translation.x;
    CGFloat yPos = position.y + translation.y;
    
    if (xPos < _differenceX)
    {
        xPos = _differenceX;
    }
    
    if (yPos < _differenceY)
    {
        yPos = _differenceY;
    }
    
    if (xPos > MIN_X_POSITION)
    {
        xPos = MIN_X_POSITION;
    }
    
    if (yPos > MIN_Y_POSITION)
    {
        yPos = MIN_Y_POSITION;
    }
    
    [_gesturesNode setPosition:CGPointMake(xPos, yPos)];
}

// Updates the scale of the gestures node based on the pinch
-(void) handlePinchWithRecognizerScale:(CGFloat) scale  {
    
    if (_gesturesNode.xScale < MAX_X_SCALE && _gesturesNode.yScale < MAX_Y_SCALE && scale > SCALE)
    {
        _gesturesNode.xScale = _gesturesNode.xScale + (SCALE_CHANGE);
        _gesturesNode.yScale = _gesturesNode.yScale + (SCALE_CHANGE);
    }
    
    // Makes the screen node smaller
    if (_gesturesNode.xScale > MIN_X_SCALE && _gesturesNode.yScale > MIN_Y_SCALE && scale < SCALE)
    {
        _gesturesNode.xScale = _gesturesNode.xScale - (SCALE_CHANGE);
        _gesturesNode.yScale = _gesturesNode.yScale - (SCALE_CHANGE);
        
        if (_gesturesNode.xScale < MIN_X_SCALE || _gesturesNode.yScale < MIN_Y_SCALE)
        {
            _gesturesNode.xScale = MIN_X_SCALE;
            _gesturesNode.yScale = MIN_Y_SCALE;
        }
    }
    
    _newMaxX = (fullScreenWidth - visualBarWidth) * _gesturesNode.xScale;
    _newMaxY = (fullScreenHeight) * _gesturesNode.yScale;
    
    _differenceX = -(_newMaxX - _initialMaxX);
    _differenceY = -(_newMaxY - _initialMaxY);
}

@end
