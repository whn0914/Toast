//
//  Utils.h
//  Toast
//
//  Created by Haonan on 16/1/18.
//  Copyright © 2016年 Haonan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface Utils : NSObject
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (void)showTextHud:(UIView *)view withText:(NSString *)text;
+ (void)showTextHudAndDismiss:(UIView *)view viewController:(UIViewController *)viewController withText:text;
@end
