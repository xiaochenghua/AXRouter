//
//  AXRouterHomeViewController.m
//  AXRouterDemo
//
//  Created by arnoldxiao on 20/03/2018.
//  Copyright © 2018 arnoldxiao. All rights reserved.
//

#import "AXRouterHomeViewController.h"

@interface AXRouterHomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

static NSString * const kTableViewCellIdentifier = @"TableViewCellIdentifier";

@implementation AXRouterHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Home";
    
    [self.view addSubview:self.tableView];
}

//  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kTableViewCellIdentifier];
    }
    //   设置Cell
    cell.textLabel.text = @"点我啊";
    cell.detailTextLabel.text = @"Detail";
    cell.contentView.backgroundColor = AXRandomColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//  UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            [[AXRouterManager manager] openUrl:@"xiaochenghua://detail0?alias=ax&age=29&height=172.5"];
            break;
        }
        
        case 1: {
            [[AXRouterManager manager] openUrl:@"xiaochenghua://detail1?alias=ax&age=29&height=172.5&job=it"];
            break;
        }
        default: {
            break;
        }
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = AXAutoScaleHeight(44);
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
