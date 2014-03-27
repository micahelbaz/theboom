//
//  Range.h
//  Battleship
//
//  Created by Robert Schneidman on 1/27/2014.
//  Copyright (c) 2014 COMP-361. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Range : NSObject

@property int rangeHeight;
@property int rangeWidth;
@property int startRange;
-(instancetype)init;
@end
