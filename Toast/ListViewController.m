//
//  ListViewController.m
//  Toast
//
//  Created by Haonan on 16/1/15.
//  Copyright © 2016年 Haonan. All rights reserved.
//

#import "ListViewController.h"
#import "ListViewCell.h"
#import "PostViewController.h"

static NSString *ListViewCellIdentifier = @"ListViewCellIdentifier";

@interface ListViewController () <UINavigationControllerDelegate>

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // adjust the table cell height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setEstimatedRowHeight:85.0];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UINib *nib = [UINib nibWithNibName:@"ListViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:ListViewCellIdentifier];
    
}

- (IBAction)toast:(id)sender {
    PostViewController *postVC = [[PostViewController alloc] initWithNibName:@"PostView" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:postVC];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - TableView Data Source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //tableView.rowHeight = UITableViewAutomaticDimension;
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellIdentifier forIndexPath:indexPath];
    if(indexPath.row == 0) {
        cell.toastText = @"阿黄撸撸撸哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
        cell.toastTime = @"2015-11-12 12:00:12";
        cell.zanText = @"1000个呐喊";
        cell.shitText = @"0个shit";
    }
    if(indexPath.row == 1) {
        cell.toastText = @"今天真的好无聊哦";
        cell.toastTime = @"2015-11-12 12:00:12";
        cell.zanText = @"10个呐喊";
        cell.shitText = @"500个shit";
    }
    cell.selectionStyle = NO;
    return cell;
}
@end
