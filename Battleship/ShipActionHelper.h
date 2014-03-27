//
//  ShipActionHelper.h
//  Battleship
//
//  Created by Robert Schneidman on 2014-03-08.
//  Copyright (c) 2014 Rayyan Khoury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fleet.h"
#import "Ship.h"
#import "ShipSegment.h"
#import "Cruiser.h"
#import "Destroyer.h"
#import "MineLayer.h"
#import "TorpedoBoat.h"
#import "RadarBoat.h"

@interface ShipActionHelper : NSObject

@property (strong, nonatomic) Fleet* hostFleet;
@property (strong, nonatomic) Fleet* joinFleet;
+(ShipActionHelper*) sharedInstance;
-(NSMutableArray*) getRotationRangeOf: (Ship*) s;
-(NSMutableArray*) getRotationAroundCenterAxis: (Ship*) s;
-(NSMutableArray*) getRotationAroundTailAxis:(Ship *)s;
@end
