//
//  TilesViewController.h
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/12/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameBrain.h"
#import "Tile.h"

@interface TilesViewController : UIViewController

-(instancetype) initWithFrame:(CGRect)frame
                       center:(CGPoint)center;
-(void) shuffleTiles:(int) numberOfSteps;
-(void) resetTiles;

@end
