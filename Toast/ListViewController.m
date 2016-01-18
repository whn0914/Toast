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
#import "MJRefresh.h"

static NSString *ListViewCellIdentifier = @"ListViewCellIdentifier";

@interface ListViewController () <UINavigationControllerDelegate>
@property (nonatomic,strong) NSMutableArray *refreshImages;//刷新动画的图片数组
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
    
    //下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置普通状态的动画图片
    [header setImages:self.refreshImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:self.refreshImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:self.refreshImages forState:MJRefreshStateRefreshing];
    // 设置header
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden= YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    // 上拉加载更多数据
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置刷新图片
    [footer setImages:self.refreshImages forState:MJRefreshStateRefreshing];
    // 设置尾部
    self.tableView.mj_footer = footer;
    // 隐藏刷新状态的文字
    footer.refreshingTitleHidden = YES;
    
}

//正在刷新状态下的图片
- (NSMutableArray *)refreshImages
{
    if (_refreshImages == nil) {
        _refreshImages = [[NSMutableArray alloc] init];
        // 循环添加图片
        UIImage *image_baby = [UIImage imageNamed:@"toast_baby"];
        UIImage *image_dad = [UIImage imageNamed:@"toast_dad"];
        UIImage *image_mom = [UIImage imageNamed:@"toast_mom"];
        for(int i=0; i<2; i++) {
            for(int j=0; j<3; j++) {
                [self.refreshImages addObject:image_baby];
            }
            for(int j=0; j<3; j++) {
                [self.refreshImages addObject:image_dad];
            }
            for(int j=0; j<3; j++) {
                [self.refreshImages addObject:image_mom];
            }
        }
    }
    return _refreshImages;
}

// 刷新数据
- (void)loadNewData {
    // 结束刷新
    
    [self.tableView.mj_header endRefreshing];
}

// 加载更多数据
- (void)loadMoreData {
    // 结束刷新
    [self.tableView.mj_footer endRefreshing];
}

- (IBAction)toast:(id)sender {
    PostViewController *postVC = [[PostViewController alloc] initWithNibName:@"PostView" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:postVC];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - TableView Data Source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
    if(indexPath.row == 2) {
        cell.toastText = @"深爱翔好胖啊啊啊哈哈哈";
        cell.toastTime = @"2015-11-12 12:00:12";
        cell.zanText = @"1个呐喊";
        cell.shitText = @"50个shit";
    }
    cell.selectionStyle = NO;
    return cell;
}
@end
