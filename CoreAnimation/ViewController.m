//
//  ViewController.m
//  CoreAnimation
//
//  Created by mingzhi.liu on 17/1/5.
//  Copyright © 2017年 mingzhi.liu. All rights reserved.
//

#import "ViewController.h"
#import "CAReplicatorLayerVC.h"
#import "showHiddenVC.h"
#import "UIKitHiddenVC.h"
#import "CAReplicatorMusicVC.h"
#import "CABaseLayerVC.h"
#import "CoreAnimationVC.h"
#import "CATransitionVC.h"
#import "RadarVC.h"
@interface ViewController ()
@property (nonatomic, strong) NSString *test;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedIndetifier = @"reusedCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIndetifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedIndetifier];
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"CALayer基础使用";

    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"显式&隐式动画";

    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"UIKit禁用隐式动画";

    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"CoreAnimation三种动画";
    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"CAReplicatorLayer (love)";

    }
    else if (indexPath.row == 5)
    {
        cell.textLabel.text = @"CAReplicatorLayer (music)";

    } else if (indexPath.row == 6) {
        cell.textLabel.text = @"文案翻滚";
    } else if (indexPath.row == 7) {
        cell.textLabel.text = @"雷达图";
    }


    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0)
    {
        CABaseLayerVC *layer = [[CABaseLayerVC alloc] init];
        [self.navigationController pushViewController:layer animated:YES];
    }
    else if (indexPath.row == 1)
    {
        showHiddenVC *showhidden = [[showHiddenVC alloc] init];
        [self.navigationController pushViewController:showhidden animated:YES];
        
    }
    else if (indexPath.row == 2)
    {
        UIKitHiddenVC *kit = [[UIKitHiddenVC alloc] init];
        [self.navigationController pushViewController:kit animated:YES];
        
    }
    else if (indexPath.row == 3)
    {
        CoreAnimationVC *core = [[CoreAnimationVC alloc ] init];
        [self.navigationController pushViewController:core animated:YES];
        
    }
    else if (indexPath.row == 4)
    {
        CAReplicatorLayerVC *layer = [[CAReplicatorLayerVC alloc] init];
        [self.navigationController pushViewController:layer animated:YES];
    }
    else if (indexPath.row == 5)
    {
        CAReplicatorMusicVC *music = [[CAReplicatorMusicVC alloc] init];
        [self.navigationController pushViewController:music animated:YES];
    
    }
    else if (indexPath.row == 6)
    {
        CATransitionVC *vc = [[CATransitionVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 7) {
        RadarVC *vc = [[RadarVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }


}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
