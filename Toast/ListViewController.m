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
#import "MBProgressHUD.h"
#import "TopRequest.h"
#import "ToastRequest.h"
#import "Utils.h"
#import "URIDefine.h"

static NSString *ListViewCellIdentifier = @"ListViewCellIdentifier";

@interface ListViewController () <UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *refreshImages;//刷新动画的图片数组
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong)  MBProgressHUD *hud;
@property (nonatomic) NSInteger currentPage;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCellData:) name:@"reloadCell" object:nil];
    
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
    // 隐藏刷新状态的文字
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    
    // 加载数据
    [self loadNewData];
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadNewData];
}

#pragma mark - Data loading
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
    [self loadData:YES];
}

// 加载更多数据
- (void)loadMoreData {
    [self loadData:NO];
}

- (void) loadData:(BOOL)isRefresh {
    [self.navigationController.view addSubview:self.hud];
    self.hud.labelText = @"正在加载";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud showAnimated:YES whileExecutingBlock:^{
            // 拉取数据
            NSString *uid = [ToastRequest toastUidPreProcess];
            if(uid == nil) {
                [Utils showTextHud:self.navigationController.view withText:@"网络出错"];
            } else {
                if(isRefresh) {
                    self.currentPage = 1;
                }
                NSString *page = [[NSString alloc] initWithFormat:@"%d", (int)self.currentPage];
                NSString *url = [API_BASE_URL stringByAppendingString:LIST_TOASTS];
                NSDictionary *params = @{@"page":page, @"uid":uid};
                BOOL res = [TopRequest execute:url params:params callback:^(ResponseBody *response) {
                    if(response.error == nil && [response.code intValue] == 1) {
                        NSDictionary *dic = [Utils dictionaryWithJsonString:response.text];
                        if(isRefresh) {
                            [self.dataList removeAllObjects];
                        }
                        [self.dataList addObjectsFromArray:dic[@"data"]];
                        self.currentPage++;
                        [self.tableView reloadData];
                        // 结束刷新
                        if(isRefresh) {
                            [self.tableView.mj_header endRefreshing];
                            [self.tableView.mj_footer resetNoMoreData];
                        } else {
                            if([dic[@"data"] count] <20) {
                                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                            } else {
                                [self.tableView.mj_footer endRefreshing];
                            }
                        }
                    } else {
                        [Utils showTextHud:self.navigationController.view withText:@"服务器出错，加载失败"];
                    }
                }];
                if(!res) {
                    [Utils showTextHud:self.navigationController.view withText:@"网络出错"];
                }
                
            }
        } completionBlock:^{
            //操作执行完后取消对话框
            [self.hud removeFromSuperview];
        }];
    });
}

#pragma mark - getters
- (MBProgressHUD *)hud {
    if(_hud == nil) {
        //初始化进度框，置于当前的View当中
        _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
    return _hud;
}

- (NSMutableArray *)dataList {
    if(_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


#pragma mark - actions
- (IBAction)toast:(id)sender {
    PostViewController *postVC = [[PostViewController alloc] initWithNibName:@"PostView" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:postVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)reloadCellData:(id)sender {
    NSDictionary *newData = [[sender userInfo] objectForKey:@"data"];
    int row = [[[sender userInfo] objectForKey:@"row"] intValue];
    self.dataList[row] = newData;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - TableView Data Source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //tableView.rowHeight = UITableViewAutomaticDimension;
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellIdentifier forIndexPath:indexPath];
    NSDictionary *cellData = self.dataList[indexPath.row];
    cell.toastText = cellData[@"body"];
    cell.toastTime = cellData[@"time"];
    cell.zanText = [[NSString alloc] initWithFormat:@"%@", cellData[@"trumpet_count"]];
    cell.shitText = [[NSString alloc] initWithFormat:@"%@", cellData[@"shit_count"]];
    cell.toastId = cellData[@"toast_id"];
    [cell.trumpetButton setTag:indexPath.row];
    [cell.shitButton setTag:indexPath.row];
    
    if([cellData[@"trumpet"] intValue] == 1) {
        [cell.trumpetButton setSelected:YES];
    } else {
        [cell.trumpetButton setSelected:NO];
    }
    if([cellData[@"shit"] intValue] == 1) {
        [cell.shitButton setSelected:YES];
    } else {
        [cell.shitButton setSelected:NO];
    }
    cell.selectionStyle = NO;
    return cell;
}
@end
