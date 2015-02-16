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
    
    _gameBrain = [GameBrain sharedInstance];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // Create Tile UIButtons
    int tileNum = 1;
    tileWidth = (self.view.frame.size.width - 20) / 4;
    for (float y = 0; y < tileWidth * 4; y += tileWidth) {
        for (float x = 0; (x < tileWidth * 4) && (tileNum < 16); x += tileWidth) {
            Tile *tempTile = [[Tile alloc] initWithFrame:CGRectMake(x, y, tileWidth, tileWidth) tileNumber:tileNum];
            tempTile.tilesArrayIndex = tileNum - 1;
            [self.view addSubview: tempTile];
            [_gameBrain addTileToGrid: tempTile];
            tileNum++;
        }
    }
    
    // Create empty spot ("invisible tile" treated as a tile that takes up space,
    // and can swap places with visible tiles)
    _invisibleTile = [[Tile alloc] initWithFrame:CGRectMake(tileWidth * 3, tileWidth * 3, tileWidth, tileWidth)];
    _invisibleTile.tilesArrayIndex = 15;
    _invisibleTile.backgroundColor = [UIColor blueColor];
    [_gameBrain addTileToGrid: self.invisibleTile];
    [self.view addSubview:_invisibleTile];
    [self.view sendSubviewToBack:_invisibleTile];
    
    [self.view addGestureRecognizer: self.swipeLeft];
    [self.view addGestureRecognizer: self.swipeRight];
    [self.view addGestureRecognizer: self.swipeUp];
    [self.view addGestureRecognizer: self.swipeDown];
}

-(void) didSwipeLeft: (UISwipeGestureRecognizer *) swipeObject {
    [UIView animateWithDuration:0.3 animations:^{
        [_gameBrain moveATileLeft];
    }];
}
-(void) didSwipeRight: (UISwipeGestureRecognizer *) swipeObject {
    [UIView animateWithDuration:0.3 animations:^{
        [_gameBrain moveATileRight];
    }];
}
-(void) didSwipeUp: (UISwipeGestureRecognizer *) swipeObject {
    [UIView animateWithDuration:0.3 animations:^{
        [_gameBrain moveATileUp];
    }];
}
-(void) didSwipeDown: (UISwipeGestureRecognizer *) swipeObject {
    [UIView animateWithDuration:0.3 animations:^{
        [_gameBrain moveATileDown];
    }];
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
    NSLog(@"Shuffle tiles %d times.", numberOfSteps);
    __block int successfulMoves = 0;
//    __block int timeDelayInterval = 0;
//
//    [UIView animateWithDuration:0.3
//                          delay:timeDelayInterval
//                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat
//                     animations:^{
//                         [UIView setAnimationRepeatCount:numberOfSteps];
//                         [_gameBrain makeARandomMove];
//                     }
//                     completion:^(BOOL finished){
//                         [_gameBrain makeARandomMove];
//                         timeDelayInterval += 0.5;
//                     }];

    while (successfulMoves < numberOfSteps) {
        [UIView animateWithDuration:0.3 animations:^{
            [_gameBrain makeARandomMove];
        }];
        successfulMoves++;
    }

    
//    __block int successfulMoves = 0;
//    while (successfulMoves < numberOfSteps) {
//        [UIView animateWithDuration:0.5
//                              delay:1
//                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat
//                         animations:^{
//                             [UIView setAnimationRepeatCount:numberOfSteps];
//                             [_gameBrain makeARandomMove];
//                         }
//                         completion:nil
//         ];
//    }
}

- (void) resetTiles {
    NSLog(@"I can't reset tiles yet :(");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
