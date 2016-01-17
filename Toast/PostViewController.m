//
//  PostViewController.m
//  Toast
//
//  Created by Haonan on 16/1/16.
//  Copyright © 2016年 Haonan. All rights reserved.
//

#import "PostViewController.h"

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
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
//    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_black"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
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



@end
