//
//  ListViewCell.m
//  Toast
//
//  Created by Haonan on 16/1/15.
//  Copyright © 2016年 Haonan. All rights reserved.
//

#import "ListViewCell.h"

@interface ListViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *toastTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *toastTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *zanNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *shitNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *trumpetButton;
@property (weak, nonatomic) IBOutlet UIButton *shitButton;

@end

@implementation ListViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setToastText:(NSString *)toastText {
    if(![toastText isEqualToString:_toastText]) {
        _toastText = [toastText copy];
        self.toastTextLabel.text = _toastText;
    }
}

- (void)setToastTime:(NSString *)toastTime {
    if(![toastTime isEqualToString:_toastTime]) {
        _toastTime = [toastTime copy];
        self.toastTimeLabel.text = _toastTime;
    }
}

- (void)setZanText:(NSString *)zanText {
    if(![zanText isEqualToString:_zanText]) {
        _zanText = [zanText copy];
        self.zanNumLabel.text = _zanText;
    }
}

- (void)setShitText:(NSString *)shitText {
    if(![shitText isEqualToString:_shitText]) {
        _shitText = [shitText copy];
        self.shitNumLabel.text = _shitText;
    }
}

- (IBAction)trumpet:(id)sender {
    [self.trumpetButton setSelected:YES];
}

- (IBAction)shit:(id)sender {
    [self.shitButton setSelected:YES];
}

@end
