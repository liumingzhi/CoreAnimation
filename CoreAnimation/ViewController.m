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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.width) style:UITableViewStylePlain];
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
    return 6;
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
        cell.textLabel.text = @"CAReplicatorLayer (love)";

    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"CAReplicatorLayer (music)";

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
        CAReplicatorLayerVC *layer = [[CAReplicatorLayerVC alloc] init];
        [self.navigationController pushViewController:layer animated:YES];
    }
    else if (indexPath.row == 4)
    {
        CAReplicatorMusicVC *music = [[CAReplicatorMusicVC alloc] init];
        [self.navigationController pushViewController:music animated:YES];
    
    }
    else if (indexPath.row == 5)
    {
    
    }


}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
