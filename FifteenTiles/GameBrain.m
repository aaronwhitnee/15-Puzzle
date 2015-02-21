//
//  GameBrain.m
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/12/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import "GameBrain.h"

@interface GameBrain ()

@property(nonatomic) int lastMoveMade;
@property(nonatomic) Tile *invisibleTile;
@property(nonatomic, strong) Tile *canMoveLeft;
@property(nonatomic, strong) Tile *canMoveRight;
@property(nonatomic, strong) Tile *canMoveUp;
@property(nonatomic, strong) Tile *canMoveDown;

- (void) moveInvisibleTile;

@end

@implementation GameBrain

+ (GameBrain *) sharedInstance {
//    static GameBrain *sharedObject = nil;
//    if (sharedObject == nil) {
//        sharedObject = [[GameBrain alloc] init];
//    }
//    return sharedObject;
    
    static dispatch_once_t once;
    static id sharedObject;
    dispatch_once(&once, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (void) prepareGame {
    self.movesHistory = [[NSMutableArray alloc] init];
    self.gameState = playing;
    self.canMoveLeft = nil;
    self.canMoveRight = self.gameTilesArray[14];
    self.canMoveUp = nil;
    self.canMoveDown = self.gameTilesArray[11];
    self.invisibleTile = self.gameTilesArray[15];
}

- (void) addTileToGrid:(Tile *)tile {
    if (!self.gameTilesArray) {
        self.gameTilesArray = [[NSMutableArray alloc] init];
    }
    [self.gameTilesArray addObject:tile];
}

- (BOOL) puzzleIsSolved {
    if (self.gameState == busy) {
        return NO;
    }
    for (int i = 0; i < [self.gameTilesArray count]; i++) {
        if (i + 1 != [self.gameTilesArray[i] number]) {
            return NO;
        }
    }
    self.gameState = gameOver;
    return YES;
}

- (NSMutableArray *) movesHistory {
    if (!_movesHistory) {
        _movesHistory = [[NSMutableArray alloc] init];
    }
    return _movesHistory;
}

- (void) clearMovesHistory {
    self.movesHistory = nil;
}


// remembers the last move made to avoid backtracking during a shuffle
- (void) makeARandomMove {
    int randomMoveNumber = arc4random_uniform(4);
    printf("attempting to move (%i)\n", randomMoveNumber);
    switch (randomMoveNumber) {
        case left:
            if(self.canMoveLeft && self.lastMoveMade != right) {
                [self moveATileLeft];
                self.lastMoveMade = left;
                break;
            }
        case right:
            if(self.canMoveRight && self.lastMoveMade != left) {
                [self moveATileRight];
                self.lastMoveMade = right;
                break;
            }
        case up:
            if(self.canMoveUp && self.lastMoveMade != down) {
                [self moveATileUp];
                self.lastMoveMade = up;
                break;
            }
        case down:
            if(self.canMoveDown && self.lastMoveMade != up) {
                [self moveATileDown];
                self.lastMoveMade = down;
                break;
            }
        default:
            [self makeARandomMove];
    }
}

// Uses discreet math on the indices of the tiles array to keep track of which
// tiles are able to move next, and in which direction they can move.
- (void) moveInvisibleTile {
    if (self.invisibleTile.tilesArrayIndex % 4 < 3)
        self.canMoveLeft = self.gameTilesArray[self.invisibleTile.tilesArrayIndex + 1];
    else
        self.canMoveLeft = nil;
    
    if (self.invisibleTile.tilesArrayIndex < 12)
        self.canMoveUp = self.gameTilesArray[self.invisibleTile.tilesArrayIndex + 4];
    else
        self.canMoveUp = nil;
    
    if (self.invisibleTile.tilesArrayIndex % 4 > 0)
        self.canMoveRight = self.gameTilesArray[self.invisibleTile.tilesArrayIndex - 1];
    else
        self.canMoveRight = nil;
    
    if (self.invisibleTile.tilesArrayIndex > 3)
        self.canMoveDown = self.gameTilesArray[self.invisibleTile.tilesArrayIndex - 4];
    else
        self.canMoveDown = nil;
}

- (BOOL) moveATileLeft {
    // make the invisible tile swap with the right neighbor (index + 1)
    if (self.canMoveLeft) {
        NSLog(@"moving tile left");
        CGPoint tempPoint = self.canMoveLeft.center;
        [self.canMoveLeft setCenter:self.invisibleTile.center];
        [self.invisibleTile setCenter:tempPoint];
        
        [self.gameTilesArray exchangeObjectAtIndex:self.canMoveLeft.tilesArrayIndex withObjectAtIndex:self.invisibleTile.tilesArrayIndex];
        
        int tempIndex = self.canMoveLeft.tilesArrayIndex;
        self.canMoveLeft.tilesArrayIndex = self.invisibleTile.tilesArrayIndex;
        self.invisibleTile.tilesArrayIndex = tempIndex;
                
        [self moveInvisibleTile];
        [self.movesHistory addObject:@0];

        return YES;
    }
    return NO;
}

- (BOOL) moveATileRight {
    // make the invisible tile swap with left neighbor (index - 1)
    if (self.canMoveRight) {
        NSLog(@"moving tile right");
        CGPoint tempPoint = self.canMoveRight.center;
        [self.canMoveRight setCenter:self.invisibleTile.center];
        [self.invisibleTile setCenter:tempPoint];
        
        [self.gameTilesArray exchangeObjectAtIndex:self.canMoveRight.tilesArrayIndex withObjectAtIndex:self.invisibleTile.tilesArrayIndex];
        
        int tempIndex = self.canMoveRight.tilesArrayIndex;
        self.canMoveRight.tilesArrayIndex = self.invisibleTile.tilesArrayIndex;
        self.invisibleTile.tilesArrayIndex = tempIndex;
        
        [self moveInvisibleTile];
        [self.movesHistory addObject:@1];

        return YES;
    }
    return NO;
}

- (BOOL) moveATileUp {
    // make the invisible tile swap with the lower neighbor (index + 4)
    if (self.canMoveUp) {
        NSLog(@"moving tile up");
        CGPoint tempPoint = self.canMoveUp.center;
        [self.canMoveUp setCenter:self.invisibleTile.center];
        [self.invisibleTile setCenter:tempPoint];
        
        [self.gameTilesArray exchangeObjectAtIndex:self.canMoveUp.tilesArrayIndex withObjectAtIndex:self.invisibleTile.tilesArrayIndex];
        
        int tempIndex = self.canMoveUp.tilesArrayIndex;
        self.canMoveUp.tilesArrayIndex = self.invisibleTile.tilesArrayIndex;
        self.invisibleTile.tilesArrayIndex = tempIndex;
        
        [self moveInvisibleTile];
        [self.movesHistory addObject:@2];

        return YES;
    }
    return NO;
}

- (BOOL) moveATileDown {
    // make the invisible tile swap with the upper neighbor (index - 4)
    if (self.canMoveDown) {
        NSLog(@"moving tile down");
        CGPoint tempPoint = self.canMoveDown.center;
        [self.canMoveDown setCenter:self.invisibleTile.center];
        [self.invisibleTile setCenter:tempPoint];
        
        [self.gameTilesArray exchangeObjectAtIndex:self.canMoveDown.tilesArrayIndex withObjectAtIndex:self.invisibleTile.tilesArrayIndex];
        
        int tempIndex = self.canMoveDown.tilesArrayIndex;
        self.canMoveDown.tilesArrayIndex = self.invisibleTile.tilesArrayIndex;
        self.invisibleTile.tilesArrayIndex = tempIndex;
        
        [self moveInvisibleTile];
        [self.movesHistory addObject:@3];

        return YES;
    }
    return NO;
}

@end
