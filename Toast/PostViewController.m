//
//  PostViewController.m
//  Toast
//
//  Created by Haonan on 16/1/16.
//  Copyright © 2016年 Haonan. All rights reserved.
//

#import "PostViewController.h"
#import "TopRequest.h"
#import "ToastRequest.h"
#import "Utils.h"

#define MAX_WORD_COUNT 60

@interface PostViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;

@end

@implementation PostViewController

#pragma mark - TextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"Begin texting");
    if([textView.text isEqualToString:@"吐槽些什么吧..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        self.wordCountLabel.text = [[NSString alloc] initWithFormat:@"还剩 %d 字", MAX_WORD_COUNT];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"End texting");
    if(textView.text.length < 1) {
        textView.text = @"吐槽些什么吧...";
        textView.textColor = [UIColor grayColor];
        self.wordCountLabel.text = [[NSString alloc] initWithFormat:@"还剩 %d 字", MAX_WORD_COUNT];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger wordCountLeft = MAX_WORD_COUNT - [self.textView.text length];
    if(wordCountLeft <=0){
        wordCountLeft = 0;
    }
    self.wordCountLabel.text = [[NSString alloc] initWithFormat:@"还剩 %ld 字", (long)wordCountLeft];
}

- (BOOL)isAcceptableTextLength:(NSUInteger)length {
    return length <= 60;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    return [self isAcceptableTextLength:textView.text.length + string.length - range.length];
}

- (IBAction)backgroundTap:(id)sender {
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"吐(cao)一下";
    //UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    cancelButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationController.navigationBar.translucent = NO;   // 避免导航栏变灰
    
    self.textView.text = @"吐槽些什么吧...";
    self.textView.textColor = [UIColor grayColor];
    self.wordCountLabel.text = [[NSString alloc] initWithFormat:@"还剩 %d 字", MAX_WORD_COUNT];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];    // 在NavigationController里textView会被下拉
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)post:(id)sender {
    if([self.textView.text length] > MAX_WORD_COUNT) {
        [Utils showTextHud:self.view withText:[[NSString alloc] initWithFormat: @"字数不能多于 %d 字", MAX_WORD_COUNT]];
    }
    else if([self.textView.text length] > 0 && [self.textView.textColor isEqual:[UIColor blackColor]]) {
        NSString *uid = [ToastRequest toastUidPreProcess];
        if(uid == nil) {
            [Utils showTextHud:self.view withText:@"网络出错"];
        }
        else {
            NSString *url = [API_BASE_URL stringByAppendingString:TOAST];
            NSDictionary *params = @{@"body":self.textView.text, @"uid":uid};
            BOOL res = [TopRequest execute:url params:params callback:^(ResponseBody *response){
                if(response.error == nil && [response.code intValue] == 1) {
                    [Utils showTextHudAndDismiss:self.view viewController:self withText:@"吐槽成功"];
                } else {
                    [Utils showTextHud:self.view withText:@"服务器出错，吐槽失败QAQ"];
                }
            }];
            if(!res) {
                [Utils showTextHud:self.view withText:@"网络出错"];
            }
        }
    }
}



@end
