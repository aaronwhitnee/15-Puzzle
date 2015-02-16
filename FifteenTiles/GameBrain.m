//
//  GameBrain.m
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/12/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import "GameBrain.h"

@interface GameBrain ()

@property(atomic) NSMutableArray *gameTilesArray;
@property(atomic) int lastMoveMade;
@property(atomic) Tile *invisibleTile;
@property(atomic, strong) Tile *canMoveLeft;
@property(atomic, strong) Tile *canMoveRight;
@property(atomic, strong) Tile *canMoveUp;
@property(atomic, strong) Tile *canMoveDown;

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
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) prepareGame {
    self.canMoveLeft = nil;
    self.canMoveRight = _gameTilesArray[14];
    self.canMoveUp = nil;
    self.canMoveDown = _gameTilesArray[11];
    self.invisibleTile = _gameTilesArray[15];
}

- (void) addTileToGrid:(Tile *)tile {
    if (!_gameTilesArray) {
        _gameTilesArray = [[NSMutableArray alloc] init];
    }
    [_gameTilesArray addObject:tile];
}

// remembers the last move made to avoid backtracking during a shuffle
- (void) makeARandomMove {
    int randomMoveNumber = arc4random_uniform(4);
    printf("attempting to move (%i)\n", randomMoveNumber);
    switch (randomMoveNumber) {
        case 0:
            if(self.canMoveLeft && _lastMoveMade != 1) {
                [self moveATileLeft];
                _lastMoveMade = 0;
                break;
            }
        case 1:
            if(self.canMoveRight && _lastMoveMade != 0) {
                [self moveATileRight];
                _lastMoveMade = 1;
                break;
            }
        case 2:
            if(self.canMoveUp && _lastMoveMade != 3) {
                [self moveATileUp];
                _lastMoveMade = 2;
                break;
            }
        case 3:
            if(self.canMoveDown && _lastMoveMade != 2) {
                [self moveATileDown];
                _lastMoveMade = 3;
                break;
            }
        default:
            [self makeARandomMove];
    }
}

// Uses discreet math on the indices of the tiles array to keep track of which
// tiles are able to move next, and in which direction they can move.
- (void) moveInvisibleTile {
    if (_invisibleTile.tilesArrayIndex % 4 < 3)
        self.canMoveLeft = _gameTilesArray[_invisibleTile.tilesArrayIndex + 1];
    else
        self.canMoveLeft = nil;
    
    if (_invisibleTile.tilesArrayIndex < 12)
        self.canMoveUp = _gameTilesArray[_invisibleTile.tilesArrayIndex + 4];
    else
        self.canMoveUp = nil;
    
    if (_invisibleTile.tilesArrayIndex % 4 > 0)
        self.canMoveRight = _gameTilesArray[_invisibleTile.tilesArrayIndex - 1];
    else
        self.canMoveRight = nil;
    
    if (_invisibleTile.tilesArrayIndex > 3)
        self.canMoveDown = _gameTilesArray[_invisibleTile.tilesArrayIndex - 4];
    else
        self.canMoveDown = nil;
}

- (BOOL) moveATileLeft {
    // make the invisible tile swap with the right neighbor (index + 1)
    if (self.canMoveLeft) {
        NSLog(@"moving tile left");
        CGPoint tempPoint = self.canMoveLeft.center;
        [self.canMoveLeft setCenter:_invisibleTile.center];
        [_invisibleTile setCenter:tempPoint];
        
        [_gameTilesArray exchangeObjectAtIndex:_canMoveLeft.tilesArrayIndex withObjectAtIndex:_invisibleTile.tilesArrayIndex];
        
        int tempIndex = self.canMoveLeft.tilesArrayIndex;
        self.canMoveLeft.tilesArrayIndex = _invisibleTile.tilesArrayIndex;
        _invisibleTile.tilesArrayIndex = tempIndex;
        
        [self moveInvisibleTile];
        return YES;
    }
    return NO;
}

- (BOOL) moveATileRight {
    // make the invisible tile swap with left neighbor (index - 1)
    if (self.canMoveRight) {
        NSLog(@"moving tile right");
        CGPoint tempPoint = self.canMoveRight.center;
        [self.canMoveRight setCenter:_invisibleTile.center];
        [_invisibleTile setCenter:tempPoint];
        
        [_gameTilesArray exchangeObjectAtIndex:_canMoveRight.tilesArrayIndex withObjectAtIndex:_invisibleTile.tilesArrayIndex];
        
        int tempIndex = self.canMoveRight.tilesArrayIndex;
        self.canMoveRight.tilesArrayIndex = _invisibleTile.tilesArrayIndex;
        _invisibleTile.tilesArrayIndex = tempIndex;
        
        [self moveInvisibleTile];
        return YES;
    }
    return NO;
}

- (BOOL) moveATileUp {
    // make the invisible tile swap with the lower neighbor (index + 4)
    if (self.canMoveUp) {
        NSLog(@"moving tile up");
        CGPoint tempPoint = self.canMoveUp.center;
        [self.canMoveUp setCenter:_invisibleTile.center];
        [_invisibleTile setCenter:tempPoint];
        
        [_gameTilesArray exchangeObjectAtIndex:_canMoveUp.tilesArrayIndex withObjectAtIndex:_invisibleTile.tilesArrayIndex];
        
        int tempIndex = self.canMoveUp.tilesArrayIndex;
        self.canMoveUp.tilesArrayIndex = _invisibleTile.tilesArrayIndex;
        _invisibleTile.tilesArrayIndex = tempIndex;
        
        [self moveInvisibleTile];
        return YES;
    }
    return NO;
}

- (BOOL) moveATileDown {
    // make the invisible tile swap with the upper neighbor (index - 4)
    if (self.canMoveDown) {
        NSLog(@"moving tile down");
        CGPoint tempPoint = self.canMoveDown.center;
        [self.canMoveDown setCenter:_invisibleTile.center];
        [_invisibleTile setCenter:tempPoint];
        
        [_gameTilesArray exchangeObjectAtIndex:_canMoveDown.tilesArrayIndex withObjectAtIndex:_invisibleTile.tilesArrayIndex];
        
        int tempIndex = self.canMoveDown.tilesArrayIndex;
        self.canMoveDown.tilesArrayIndex = _invisibleTile.tilesArrayIndex;
        _invisibleTile.tilesArrayIndex = tempIndex;
        
        [self moveInvisibleTile];
        return YES;
    }
    return NO;
}

@end
