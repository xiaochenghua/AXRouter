//
//  AXRouterDetailViewController.m
//  AXRouterDemo
//
//  Created by xiaochenghua on 2018/4/23.
//  Copyright © 2018 arnoldxiao. All rights reserved.
//

#import "AXRouterDetailViewController.h"

#define kParameterLabelWidth ((AXScreenWidth * 0.5) - (AXAutoScaleSize(kParameterLabelSpace)) * 1.5)

static CGFloat const kParameterLabelSpace = 10.0f;
static CGFloat const kParameterLabelHeight = 44.0f;

@interface AXRouterDetailViewController ()

@end

@implementation AXRouterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = [self navigationItemTitle];
    
    UIColor *color = nil;
    
    for (NSInteger i = 0; i < self.routerParameter.allKeys.count; i++) {
        color = AXRandomColor;
        
        CGFloat y = AXAutoScaleSize(kParameterLabelSpace) + (AXAutoScaleHeight(kParameterLabelHeight) + AXAutoScaleSize(kParameterLabelSpace)) * i;
        
        UILabel *keyLabel = [[UILabel alloc] init];
        keyLabel.frame = CGRectMake(AXAutoScaleSize(kParameterLabelSpace), y, kParameterLabelWidth, AXAutoScaleHeight(kParameterLabelHeight));
        keyLabel.backgroundColor = color;
        keyLabel.font = AXAutoScaleFont(18);
        keyLabel.textColor = UIColor.whiteColor;
        keyLabel.textAlignment = NSTextAlignmentCenter;
        keyLabel.text = self.routerParameter.allKeys[i];
        [self.view addSubview:keyLabel];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.frame = CGRectMake((AXScreenWidth + AXAutoScaleSize(kParameterLabelSpace)) * 0.5f, y, kParameterLabelWidth, AXAutoScaleHeight(kParameterLabelHeight));
        valueLabel.backgroundColor = color;
        valueLabel.font = AXAutoScaleFont(18);
        valueLabel.textColor = UIColor.whiteColor;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = [NSString stringWithFormat:@"%@", self.routerParameter.allValues[i]];
        [self.view addSubview:valueLabel];
    }
    
    UILabel *tagNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(AXAutoScaleWidth(3), AXScreenHeight - AXNavigationHeight - AXAutoScaleHeight(20), AXScreenWidth, AXAutoScaleHeight(20))];
    tagNameLabel.textColor = UIColor.lightGrayColor;
    tagNameLabel.font = AXAutoScaleFont(12);
    tagNameLabel.text = NSStringFromClass(self.class);
    [self.view addSubview:tagNameLabel];
}

- (NSString *)navigationItemTitle {
    return @"";
}

@end
