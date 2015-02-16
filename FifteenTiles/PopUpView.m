//
//  PopUpView.m
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/15/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import "PopUpView.h"

@interface PopUpView ()

@property(nonatomic) UILabel *messageLabel;
@property(nonatomic) NSString *messageString;

@end

@implementation PopUpView

- (instancetype) initWithFrame:(CGRect)screen message:(NSString *)message {
    if ([self init] == nil) {
        return nil;
    }
    
    self.frame = screen;
    self.backgroundColor = [[UIColor alloc] initWithRed:0.2 green:0.2 blue:0.2 alpha:0.7];
    
    _busyIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _busyIndicatorView.frame = CGRectMake(0, 0, screen.size.width / 3, screen.size.width / 3);
    _busyIndicatorView.center = CGPointMake(screen.size.width / 2, screen.size.height / 5 * 2);
    _busyIndicatorView.layer.cornerRadius = 10;
    _busyIndicatorView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.4];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _busyIndicatorView.frame.size.width - 15,
                                                              _busyIndicatorView.frame.size.width / 5)];
    _messageLabel.center = CGPointMake(_busyIndicatorView.frame.size.width / 2, _busyIndicatorView.frame.size.height / 5 * 4);
    _messageLabel.textColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.7];
    _messageLabel.text = message;
    _messageLabel.adjustsFontSizeToFitWidth = YES;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.backgroundColor = [UIColor clearColor];
    
    [_busyIndicatorView addSubview:_messageLabel];
    [self addSubview:_busyIndicatorView];
    
    return self;
}

- (void) startAnimatingBusyIndicator {
    [_busyIndicatorView startAnimating];
}

- (void) stopAnimatingBusyIndicator {
    [_busyIndicatorView stopAnimating];
}

@end
