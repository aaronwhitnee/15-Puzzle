//
//  Tile.h
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/12/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tile : UIButton

@property(nonatomic) int number;
@property(nonatomic) int tilesArrayIndex;

- (instancetype) initWithFrame:(CGRect)frame tileNumber:(int)number;

@end
