//
//  TilesViewController.m
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/12/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import "TilesViewController.h"

@interface TilesViewController () {
    float tileWidth;
}

@property (nonatomic, strong) GameBrain *gameBrain;
@property (nonatomic) Tile *invisibleTile;
@property (nonatomic) PopUpView *gameOverView;
@property (nonatomic) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic) UISwipeGestureRecognizer *swipeRight;
@property (nonatomic) UISwipeGestureRecognizer *swipeUp;
@property (nonatomic) UISwipeGestureRecognizer *swipeDown;

-(void) didSwipeLeft: (UISwipeGestureRecognizer *) swipeObject;
-(void) didSwipeRight: (UISwipeGestureRecognizer *) swipeObject;
-(void) didSwipeUp: (UISwipeGestureRecognizer *) swipeObject;
-(void) didSwipeDown: (UISwipeGestureRecognizer *) swipeObject;
    
@end

@implementation TilesViewController

- (instancetype) initWithFrame:(CGRect)frame center:(CGPoint)center {
    if( (self = [super init]) == nil )
        return nil;
    [self.view setFrame: frame];
    [self.view setCenter: center];
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.gameBrain = [GameBrain sharedInstance];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // Create Tile UIButtons
    int tileNum = 1;
    tileWidth = (self.view.frame.size.width - 20) / 4;
    for (float y = 0; y < tileWidth * 4; y += tileWidth) {
        for (float x = 0; (x < tileWidth * 4) && (tileNum < 16); x += tileWidth) {
            Tile *tempTile = [[Tile alloc] initWithFrame:CGRectMake(x, y, tileWidth, tileWidth) tileNumber:tileNum];
            [self.view addSubview: tempTile];
            [self.gameBrain addTileToGrid: tempTile];
            tileNum++;
        }
    }
    
    // Create empty spot ("invisible tile" treated as a tile that takes up space,
    // and can swap places with visible tiles)
    self.invisibleTile = [[Tile alloc] initWithFrame:CGRectMake(tileWidth * 3, tileWidth * 3, tileWidth, tileWidth)  tileNumber:16];
    self.invisibleTile.tilesArrayIndex = 15;
    self.invisibleTile.backgroundColor = [UIColor clearColor];
    [self.gameBrain addTileToGrid: self.invisibleTile];
    [self.view addSubview:self.invisibleTile];
    [self.view sendSubviewToBack:self.invisibleTile];
    
    [self.view addGestureRecognizer: self.swipeLeft];
    [self.view addGestureRecognizer: self.swipeRight];
    [self.view addGestureRecognizer: self.swipeUp];
    [self.view addGestureRecognizer: self.swipeDown];
}

-(void) didSwipeLeft: (UISwipeGestureRecognizer *) swipeObject {
    [UIView animateWithDuration:0.3 animations:^{
        [self.gameBrain moveATileLeft];
    }];
    [self performSelector:@selector(checkForGameWin) withObject:nil afterDelay:0.5];
}
-(void) didSwipeRight: (UISwipeGestureRecognizer *) swipeObject {
    [UIView animateWithDuration:0.3 animations:^{
        [self.gameBrain moveATileRight];
    }];
    [self performSelector:@selector(checkForGameWin) withObject:nil afterDelay:0.5];
}
-(void) didSwipeUp: (UISwipeGestureRecognizer *) swipeObject {
    [UIView animateWithDuration:0.3 animations:^{
        [self.gameBrain moveATileUp];
    }];
    [self performSelector:@selector(checkForGameWin) withObject:nil afterDelay:0.5];
}
-(void) didSwipeDown: (UISwipeGestureRecognizer *) swipeObject {
    [UIView animateWithDuration:0.3 animations:^{
        [self.gameBrain moveATileDown];
    }];
    [self performSelector:@selector(checkForGameWin) withObject:nil afterDelay:0.5];
}

-(void) checkForGameWin {
    if ( ! [self.gameBrain puzzleIsSolved])
        return;
    NSLog(@"finished!");
    if (!self.gameOverView) {
        self.gameOverView = [[PopUpView alloc] initWithFrame:self.view.superview.frame message:@"Puzzle Solved!"];
    }
    [self.view.superview addSubview:self.gameOverView];
}

-(UISwipeGestureRecognizer *) swipeLeft {
    if (!_swipeLeft) {
        _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
        _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return _swipeLeft;
}
-(UISwipeGestureRecognizer *) swipeRight {
    if (!_swipeRight) {
        _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
        _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    }
    return _swipeRight;
}
-(UISwipeGestureRecognizer *) swipeUp {
    if (!_swipeUp) {
        _swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeUp:)];
        _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    }
    return _swipeUp;
}
-(UISwipeGestureRecognizer *) swipeDown {
    if (!_swipeDown) {
        _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeDown:)];
        _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    }
    return _swipeDown;
}

- (void) shuffleTiles:(int)numberOfSteps {
    if (numberOfSteps == 0) {
        [[self.view.superview nextResponder] performSelector:@selector(removeBusyIndicator) withObject:nil afterDelay:0];
        self.gameBrain.gameState = playing;
        return;
    }
    NSLog(@"Shuffle tiles %d times.", numberOfSteps);
//    int successfulMoves = 0;
//    float timeDelayInterval = 0;
//    
//    while (successfulMoves < numberOfSteps) {
//        [UIView animateWithDuration:0.15
//                              delay:timeDelayInterval
//                            options:UIViewAnimationOptionCurveEaseInOut
//                         animations:^{
//                             [self.gameBrain makeARandomMove];
//                         }
//                         completion:nil];
//        successfulMoves++;
//        timeDelayInterval += 0.15;
//    }
    [UIView animateWithDuration:0.15
                     animations:^{
                         [self.gameBrain makeARandomMove];
                     }
                     completion:^(BOOL finished){
                         [self shuffleTiles:numberOfSteps - 1];
                     }];
}

- (void) resetTiles {
    NSLog(@"I can't reset tiles yet :(");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
