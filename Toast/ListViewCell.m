//
//  ListViewCell.m
//  Toast
//
//  Created by Haonan on 16/1/15.
//  Copyright © 2016年 Haonan. All rights reserved.
//

#import "ListViewCell.h"
#import "ToastRequest.h"
#import "URIDefine.h"
#import "TopRequest.h"
#import "Utils.h"
#import "ListViewController.h"

@interface ListViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *toastTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *toastTimeLabel;
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
        [self.trumpetButton setTitle:[[NSString alloc] initWithFormat:@"%@ 个呐喊", _zanText] forState:UIControlStateNormal];
    }
}

- (void)setShitText:(NSString *)shitText {
    if(![shitText isEqualToString:_shitText]) {
        _shitText = [shitText copy];
        [self.shitButton setTitle:[[NSString alloc] initWithFormat:@"%@ 个shit", _shitText] forState:UIControlStateNormal];
    }
}

- (IBAction)trumpet:(id)sender {
    if([self.trumpetButton isSelected]) {
        return;
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"TOAST_UID"];
    NSString *url = [API_BASE_URL stringByAppendingString:TRUMPET];
    NSDictionary *params = @{@"uid":uid, @"toastId":self.toastId};
    BOOL res = [TopRequest execute:url params:params callback:^(ResponseBody *response) {
        if(response.error == nil && [response.code intValue] == 1) {
            // 拉取新的trumpet数据
            [TopRequest execute:[API_BASE_URL stringByAppendingString:GET_TOAST] params:@{@"toastId":self.toastId} callback:^(ResponseBody *response) {
                if(response.error == nil && [response.code intValue] == 1) {
                    NSDictionary *dic = [Utils dictionaryWithJsonString:response.text][@"data"];
                    [dic setValue:@"1" forKey:@"trumpet"];
                    if([self.shitButton isSelected]) {
                        [dic setValue:@"1" forKey:@"shit"];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCell" object:nil userInfo:@{@"data":dic, @"row":[NSNumber numberWithInteger:[sender tag]]}];
                }
            }];
        } else {
            [Utils showTextHud:self.superview withText:@"服务器出错了QAQ"];
        }
    }];
    if(!res) {
        [Utils showTextHud:self.superview withText:@"网络出错"];
    }
    
}

- (IBAction)shit:(id)sender {
    if([self.shitButton isSelected]) {
        return;
    }
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"TOAST_UID"];
    NSString *url = [API_BASE_URL stringByAppendingString:SHIT];
    NSDictionary *params = @{@"uid":uid, @"toastId":self.toastId};
    BOOL res = [TopRequest execute:url params:params callback:^(ResponseBody *response) {
        if(response.error == nil && [response.code intValue] == 1) {
            // 拉取新的trumpet数据
            [TopRequest execute:[API_BASE_URL stringByAppendingString:GET_TOAST] params:@{@"toastId":self.toastId} callback:^(ResponseBody *response) {
                if(response.error == nil && [response.code intValue] == 1) {
                    NSDictionary *dic = [Utils dictionaryWithJsonString:response.text][@"data"];
                    [dic setValue:@"1" forKey:@"shit"];
                    if([self.trumpetButton isSelected]) {
                        [dic setValue:@"1" forKey:@"trumpet"];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCell" object:nil userInfo:@{@"data":dic, @"row":[NSNumber numberWithInteger:[sender tag]]}];
                }
            }];
        } else {
            [Utils showTextHud:self.superview withText:@"服务器出错了QAQ"];
        }
    }];
    if(!res) {
        [Utils showTextHud:self.superview withText:@"网络出错"];
    }

}

- (UITableView *)getSuperTableView {
    id view = [self superview];
    
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    
    return (UITableView *)view;
}

@end
