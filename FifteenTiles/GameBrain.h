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

enum direction {left, right, up, down};

@property(nonatomic) NSMutableArray *gameTilesArray;
@property(nonatomic) NSMutableArray *movesHistory;
@property(nonatomic) enum state {gameOver = 0, playing, busy};
@property(nonatomic) enum state gameState;

+ (GameBrain *) sharedInstance;
- (void) prepareGame;
- (void) addTileToGrid:(Tile *)tile;
- (BOOL) puzzleIsSolved;
- (void) clearMovesHistory;
- (BOOL) moveATileLeft;
- (BOOL) moveATileRight;
- (BOOL) moveATileUp;
- (BOOL) moveATileDown;
- (void) makeARandomMove;

@end
