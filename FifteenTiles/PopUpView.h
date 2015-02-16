//
//  PopUpView.h
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/15/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpView : UIView

@property (nonatomic, strong) UIActivityIndicatorView *busyIndicatorView;

- (instancetype) initWithFrame:(CGRect)frame message:(NSString *)message;
- (void) startAnimatingBusyIndicator;
- (void) stopAnimatingBusyIndicator;


@end
