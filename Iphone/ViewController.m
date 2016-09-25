//
//  ViewController.m
//  Iphone
//
//  Created by 刘洋 on 16/9/18.
//  Copyright © 2016年 ddicar. All rights reserved.
//

#import "ViewController.h"
#import <AFHTTPSessionManager.h>
#import "StoreModel.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation ViewController
static int count = 0;
static int isHaveCount = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    //三里屯 R320
    //华贸 R479
    //朝阳大悦城 R645
    //王府井 R448
    //西单大悦城  R388
    _dataSource = [@[] mutableCopy];
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(request) userInfo:nil repeats:YES];
    [timer fire];
    
}
- (void)request {
    count++;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    self.title = [NSString stringWithFormat:@"更新于%@ 第%d次更新",[formatter stringFromDate:date],count];
    NSDictionary *bjStore =@{@"R320":@"三里屯",
                             @"R479":@"华贸",
                             @"R645":@"朝阳大悦城",
                             @"R448":@"王府井",
                             @"R388":@"西单大悦城",
                             };
    NSString *jetBlack = @"MNH22CH/A";  //128G PLUS 亮黑 MNFU2CH/A
    NSString *jetBlackPlus = @"MNFU2CH/A";
    //    NSString *storeUrl = @"https://reserve.cdn-apple.com/CN/zh_CN/reserve/iPhone/stores.json";
    NSString * availabilityUrl= @"https://reserve.cdn-apple.com/CN/zh_CN/reserve/iPhone/availability.json";
    
    
    [[AFHTTPSessionManager manager] GET:availabilityUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_dataSource removeAllObjects];
        for (NSString *key in bjStore.allKeys) {
            NSString * status = [[responseObject objectForKey:key] objectForKey:jetBlack];
            StoreModel *model = [[StoreModel alloc] init];
            model.storeName = [bjStore objectForKey:key];
            
            if ([status isEqualToString:@"NONE"]) {
                model.isHave = @"无货";
            }else if ([status isEqualToString:@"ALL"]){
                model.isHave = @"有货";
                model.count++;
                isHaveCount++;
            }
            [_dataSource addObject:model];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    StoreModel *model = _dataSource[indexPath.row];
    if ([model.isHave isEqualToString:@"有货"]) {
        cell.textLabel.textColor = [UIColor greenColor];
    }else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@ 出现有货%d次",model.storeName,model.isHave,isHaveCount/5];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
