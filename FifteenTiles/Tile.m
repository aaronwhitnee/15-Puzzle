//
//  Tile.m
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/12/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import "Tile.h"

@interface Tile ()

@property(nonatomic) UILabel *numberLabel;

@end

@implementation Tile

- (instancetype) initWithFrame:(CGRect)frame tileNumber:(int)number {
    if( (self = [super init]) == nil )
        return nil;
    self.backgroundColor = [[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    self.number = number;
    self.frame = frame;
//    self.clipsToBounds = YES;
//    self.layer.cornerRadius = self.frame.size.height / 10.0f;
    self.tilesArrayIndex = number - 1;
    [self addSubview: self.numberLabel];
    return self;
}

- (UILabel *) numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    }
    _numberLabel.text = [NSString stringWithFormat:@"%d", self.number];
    _numberLabel.textColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.font = [UIFont systemFontOfSize:30];
    _numberLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    return _numberLabel;
}


@end
