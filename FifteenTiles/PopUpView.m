//
//  PopUpView.m
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/15/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import "PopUpView.h"

@interface PopUpView () {
    CGRect mainFrame;
}

@property(nonatomic) UILabel *messageLabel;
@property(nonatomic) NSString *messageString;
@property(nonatomic) UIButton *continueButton;

@end

@implementation PopUpView

- (instancetype) initWithFrame:(CGRect)frame message:(NSString *)message {
    if ([self init] == nil) {
        return nil;
    }
    
    mainFrame = frame;
    self.frame = mainFrame;
    
    [self.continueButton addTarget:self action:@selector(didTapContinueButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.text = message;
    self.messageLabel.adjustsFontSizeToFitWidth = YES;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont systemFontOfSize: self.frame.size.width / 2];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    
    switch (self.gameBrain.gameState) {
        case gameOver:
            [self createGameOverScreen];
            break;
        case busy:
            [self createBusyScreen];
            break;
        default:
            break;
    }
    
    return self;
}

- (GameBrain *) gameBrain {
    if (!_gameBrain) {
        _gameBrain = [GameBrain sharedInstance];
    }
    return _gameBrain;
}

- (UIButton *) continueButton {
    if (!_continueButton) {
        _continueButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mainFrame.size.width / 4, mainFrame.size.width * 0.1)];
        [_continueButton setTitle:@"OK" forState:UIControlStateNormal];
        _continueButton.backgroundColor = [[UIColor alloc] initWithRed:0.7 green:0.3 blue:0.3 alpha:1.0];
        _continueButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _continueButton;
}

- (void) didTapContinueButton:(UIButton *) sender {
    [self removeFromSuperview];
}

- (void) createGameOverScreen {
    self.backgroundColor = [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:0.7];
    
    self.messageLabel.frame = CGRectMake(0, 0, mainFrame.size.width * 0.9, mainFrame.size.width * 0.4);
    self.messageLabel.center = CGPointMake(mainFrame.size.width / 2, mainFrame.size.height * 0.35);
    self.messageLabel.textColor = [UIColor whiteColor];
    
    [self.continueButton setCenter:CGPointMake(mainFrame.size.width / 2, CGRectGetMaxY(self.messageLabel.frame) + 30)];
    
    [self addSubview:self.continueButton];
    [self addSubview:self.messageLabel];
}

- (void) createBusyScreen {
    self.backgroundColor = [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:0.7];

    self.busyIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.busyIndicatorView.frame = CGRectMake(0, 0, mainFrame.size.width / 3, mainFrame.size.width / 3);
    self.busyIndicatorView.center = CGPointMake(mainFrame.size.width / 2, mainFrame.size.height * 0.4);
    self.busyIndicatorView.layer.cornerRadius = 10;
    self.busyIndicatorView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.4];

    self.messageLabel.frame = CGRectMake(0, 0, self.busyIndicatorView.frame.size.width - 15, self.busyIndicatorView.frame.size.width / 5);
    self.messageLabel.center = CGPointMake(self.busyIndicatorView.frame.size.width / 2, self.busyIndicatorView.frame.size.height / 5 * 4);
    self.messageLabel.textColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.7];

    [self.busyIndicatorView addSubview:self.messageLabel];
    [self addSubview:self.busyIndicatorView];
}

- (void) startAnimatingBusyIndicator {
    [self.busyIndicatorView startAnimating];
}

- (void) stopAnimatingBusyIndicator {
    [self.busyIndicatorView stopAnimating];
}

@end
