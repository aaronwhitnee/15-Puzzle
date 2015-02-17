//
//  ViewController.m
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/12/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    CGRect window;
    int numberOfShuffleSteps;
}

@property (nonatomic, strong) GameBrain *gameBrain;
@property (nonatomic, strong) TilesViewController *tilesViewController;
@property (nonatomic, strong) PopUpView *popUpView;
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
    
    self.gameBrain = [GameBrain sharedInstance];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTilesViewControllerToScreen];
    [self addShuffleSliderToScreen];
    [self addButtonsToScreen];
    [self.gameBrain prepareGame];
}

- (void) addTilesViewControllerToScreen {
    int tilesViewEdgeLength = (window.size.width / 4 - 5) * 4;
    CGRect tilesViewFrame = CGRectMake(0, 0, tilesViewEdgeLength, tilesViewEdgeLength);
    CGPoint tilesViewCenter = CGPointMake(window.size.width / 2, window.size.height / 2 - 50);
    self.tilesViewController = [[TilesViewController alloc] initWithFrame:tilesViewFrame center:tilesViewCenter];
    [self.view addSubview: self.tilesViewController.view];
}

- (void) addShuffleSliderToScreen {
    CGRect sliderFrame = CGRectMake(0, 0, window.size.width - 50, 20);
    self.shuffleSlider = [[UISlider alloc] initWithFrame: sliderFrame];
    CGPoint shuffleSliderCenter = CGPointMake(window.size.width / 2, CGRectGetMaxY(self.tilesViewController.view.frame) + 30);
    self.shuffleSlider.center = shuffleSliderCenter;
    self.shuffleSlider.value = 0.5;
    
    CGRect sliderLabelFrame = CGRectMake(0, 0, 20, 20);
    self.shuffleSliderLabel = [[UILabel alloc] initWithFrame: sliderLabelFrame];
    CGPoint labelCenter = CGPointMake(window.size.width / 2, CGRectGetMaxY(self.shuffleSlider.frame) + 20);
    self.shuffleSliderLabel.center = labelCenter;
    numberOfShuffleSteps = self.shuffleSlider.value * 50;
    self.shuffleSliderLabel.textAlignment = NSTextAlignmentCenter;
    self.shuffleSliderLabel.text = [NSString stringWithFormat:@"%d", numberOfShuffleSteps];

    [self.shuffleSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.shuffleSliderLabel];
    [self.view addSubview:self.shuffleSlider];
}

- (void) addButtonsToScreen {
    CGRect buttonFrame = CGRectMake(0, 0, 100, 50);
    self.shuffleButton = [[UIButton alloc] initWithFrame: buttonFrame];
    [self.shuffleButton setTitle:@"Shuffle" forState:UIControlStateNormal];
    [self.shuffleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shuffleButton.backgroundColor = [UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1.0];
    self.shuffleButton.center = CGPointMake(window.size.width / 4, window.size.height - 60);
    
    self.resetButton = [[UIButton alloc] initWithFrame: buttonFrame];
    [self.resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.resetButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0];
    self.resetButton.center = CGPointMake(window.size.width / 4 * 3, window.size.height - 60);
    
    [self.view addSubview:self.resetButton];
    [self.view addSubview:self.shuffleButton];
    
    [self.shuffleButton addTarget:self action:@selector(shuffleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton addTarget:self action:@selector(resetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) shuffleButtonPressed:(UIButton *)sender {
    self.gameBrain.gameState = busy;
    
    [self displayBusyScreen];

    [self performSelector:@selector(startShuffling:) onThread:[NSThread mainThread] withObject:[NSNumber numberWithInt:numberOfShuffleSteps] waitUntilDone:YES];

}

-(void) displayBusyScreen {
    if (!self.popUpView) {
        self.popUpView = [[PopUpView alloc] initWithFrame:window message:@"Shuffling..."];
    }
    [self.view addSubview:self.popUpView];
    [self.popUpView startAnimatingBusyIndicator];
}

-(void) removeBusyIndicator {
    [self.popUpView stopAnimatingBusyIndicator];
    [self.popUpView removeFromSuperview];
}

-(void) startShuffling:(NSNumber *)shuffleCount {
    [self.tilesViewController shuffleTiles: [shuffleCount intValue]];
    self.gameBrain.gameState = playing;
}

-(void) resetButtonPressed:(UIButton *)sender {
    [self.tilesViewController resetTiles];
}

-(void) sliderValueChanged:(UISlider *)sender {
    numberOfShuffleSteps = self.shuffleSlider.value * 50;
    self.shuffleSliderLabel.text = [NSString stringWithFormat:@"%d", numberOfShuffleSteps];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
