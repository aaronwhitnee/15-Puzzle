//
//  PopUpView.h
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/15/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameBrain.h"

@interface PopUpView : UIView

@property (nonatomic, strong) GameBrain *gameBrain;
@property (nonatomic) NSString *messageString;
@property (nonatomic, strong) UIActivityIndicatorView *busyIndicatorView;

- (instancetype) initWithFrame:(CGRect)frame messageString:(NSString*)message;
- (void) startAnimatingBusyIndicator;
- (void) stopAnimatingBusyIndicator;


@end
