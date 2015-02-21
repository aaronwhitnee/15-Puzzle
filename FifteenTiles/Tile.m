//
//  Tile.m
//  FifteenTiles
//
//  Created by Aaron Robinson on 2/12/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#import "Tile.h"

@interface Tile ()

//@property(nonatomic) UILabel *numberLabel;

@end

@implementation Tile

- (instancetype) initWithFrame:(CGRect)frame tileNumber:(int)number imageName:(NSString *)imageName {
    if( (self = [super init]) == nil )
        return nil;
    self.number = number;
    self.frame = frame;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height / 10.0f;
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor colorWithRed:0/255.0 green:61/255.0 blue:115/255.0 alpha:1.0].CGColor;
    self.tilesArrayIndex = number - 1;
    
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.adjustsImageWhenHighlighted = NO;
//    if (self.number != 16) {
//        [self addSubview: self.numberLabel];
//    }
    return self;
}

//- (UILabel *) numberLabel {
//    if (!_numberLabel) {
//        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//        _numberLabel.text = [NSString stringWithFormat:@"%d", self.number];
//        _numberLabel.textColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1];
//        _numberLabel.textAlignment = NSTextAlignmentCenter;
//        _numberLabel.font = [UIFont systemFontOfSize: self.frame.size.width / 2];
//        _numberLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
//    }
//    return _numberLabel;
//}


@end
