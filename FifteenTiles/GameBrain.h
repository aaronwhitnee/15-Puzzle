//
//  GameBrain.h
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/12/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@interface GameBrain : NSObject

@property(atomic) enum state {gameOver = 0, playing, busy};
@property(atomic) enum state gameState;

+ (GameBrain *) sharedInstance;
- (void) prepareGame;
- (void) addTileToGrid:(Tile *)tile;
- (BOOL) puzzleIsSolved;
- (BOOL) moveATileLeft;
- (BOOL) moveATileRight;
- (BOOL) moveATileUp;
- (BOOL) moveATileDown;
- (void) makeARandomMove;

@end
