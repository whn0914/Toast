//
//  ToastRequest.m
//  Toast
//
//  Created by Haonan on 16/1/19.
//  Copyright © 2016年 Haonan. All rights reserved.
//

#import "ToastRequest.h"
#import "TopRequest.h"
@implementation ToastRequest

/*!
 * @brief 检查是否存有TOAST_UID
 */
+ (id)toastUidPreProcess {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"TOAST_UID"]) {
        // 向服务器请求TOAST_UID
        NSLog(@"Add User to Server");
        NSString *url = [API_BASE_URL stringByAppendingString:ADD_USER];
        [TopRequest execute:url params:nil callback:^(ResponseBody *response){
            if(response.error == nil && response.code.intValue == 1) {
                NSString *toast_uid = (NSString *)response.data;
                NSLog(@"uid: %@", toast_uid);
                [[NSUserDefaults standardUserDefaults] setObject:toast_uid forKey:@"TOAST_UID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    } else {
        NSLog(@"User Already Exists!");
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"TOAST_UID"];
}
@end
