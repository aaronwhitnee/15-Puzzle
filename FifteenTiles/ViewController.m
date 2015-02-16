//
//  ViewController.m
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/12/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import "ViewController.h"
#import "TilesViewController.h"

@interface ViewController () {
    CGRect window;
    int numberOfShuffleSteps;
}

@property (nonatomic, strong) GameBrain *gameBrain;
@property (nonatomic, strong) TilesViewController *tilesViewController;
@property (nonatomic, strong) UIButton *shuffleButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UISlider *shuffleSlider;
@property (nonatomic, strong) UILabel *shuffleSliderLabel;

- (void) addTilesViewControllerToScreen;
- (void) addShuffleSliderToScreen;
- (void) addButtonsToScreen;
- (void) shuffleButtonPressed: (UIButton *) sender;
- (void) resetButtonPressed: (UIButton *) sender;
- (void) sliderValueChanged: (UISlider *) sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    window = [[UIScreen mainScreen] applicationFrame];
    
    _gameBrain = [GameBrain sharedInstance];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTilesViewControllerToScreen];
    [self addShuffleSliderToScreen];
    [self addButtonsToScreen];
    [_gameBrain prepareGame];
}

- (void) addTilesViewControllerToScreen {
    int tilesViewEdgeLength = (window.size.width / 4 - 5) * 4;
    CGRect tilesViewFrame = CGRectMake(0, 0, tilesViewEdgeLength, tilesViewEdgeLength);
    CGPoint tilesViewCenter = CGPointMake(window.size.width / 2, window.size.height / 2 - 50);
    _tilesViewController = [[TilesViewController alloc] initWithFrame:tilesViewFrame center:tilesViewCenter];
    [self.view addSubview: self.tilesViewController.view];
}

- (void) addShuffleSliderToScreen {
    CGRect sliderFrame = CGRectMake(0, 0, window.size.width - 50, 20);
    _shuffleSlider = [[UISlider alloc] initWithFrame: sliderFrame];
    CGPoint shuffleSliderCenter = CGPointMake(window.size.width / 2, CGRectGetMaxY(_tilesViewController.view.frame) + 30);
    _shuffleSlider.center = shuffleSliderCenter;
    _shuffleSlider.value = 0.5;
    
    CGRect sliderLabelFrame = CGRectMake(0, 0, 20, 20);
    _shuffleSliderLabel = [[UILabel alloc] initWithFrame: sliderLabelFrame];
    CGPoint labelCenter = CGPointMake(window.size.width / 2, CGRectGetMaxY(_shuffleSlider.frame) + 20);
    _shuffleSliderLabel.center = labelCenter;
    numberOfShuffleSteps = _shuffleSlider.value * 50;
    _shuffleSliderLabel.textAlignment = NSTextAlignmentCenter;
    _shuffleSliderLabel.text = [NSString stringWithFormat:@"%d", numberOfShuffleSteps];

    [_shuffleSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_shuffleSliderLabel];
    [self.view addSubview:_shuffleSlider];
}

- (void) addButtonsToScreen {
    CGRect buttonFrame = CGRectMake(0, 0, 100, 50);
    _shuffleButton = [[UIButton alloc] initWithFrame: buttonFrame];
    [_shuffleButton setTitle:@"Shuffle" forState:UIControlStateNormal];
    [_shuffleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shuffleButton.backgroundColor = [UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1.0];
    CGPoint shuffleButtonCenter = CGPointMake(window.size.width / 2 - 80, window.size.height - 60);
    _shuffleButton.center = shuffleButtonCenter;
    
    _resetButton = [[UIButton alloc] initWithFrame: buttonFrame];
    [_resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [_resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _resetButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0];
    CGPoint resetButtonCenter = CGPointMake(window.size.width / 2 + 80, window.size.height - 60);
    _resetButton.center = resetButtonCenter;
    
    [self.view addSubview:_resetButton];
    [self.view addSubview:_shuffleButton];
    
    [_shuffleButton addTarget:self action:@selector(shuffleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_resetButton addTarget:self action:@selector(resetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) shuffleButtonPressed:(UIButton *)sender {
    [_tilesViewController shuffleTiles: numberOfShuffleSteps];
}

-(void) resetButtonPressed:(UIButton *)sender {
    [_tilesViewController resetTiles];
}

-(void) sliderValueChanged:(UISlider *)sender {
    numberOfShuffleSteps = _shuffleSlider.value * 50;
    _shuffleSliderLabel.text = [NSString stringWithFormat:@"%d", numberOfShuffleSteps];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
