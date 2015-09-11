//
//  ViewController.m
//  UITableView_QQ
//
//  Created by qianfeng on 15/9/11.
//  Copyright © 2015年 xiaoma. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController
{
    UITableView * _tableView;
    NSMutableArray * _arrayData;
    NSMutableDictionary * _dict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _arrayData = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    
    //创建一个字典来记录每个section的状态
    _dict = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < _arrayData.count; i++) {
        NSNumber * value = [NSNumber numberWithBool:YES];
        NSString * key = [NSString stringWithFormat:@"%d",i];
        [_dict setObject:value forKey:key];
    }
    
    
    [self.view addSubview:_tableView];
}

//设置cell的高度
-(CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 40;
}

//设置每个section有多少个cell
-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * key = [NSString stringWithFormat:@"%ld",section];
    BOOL isSpread= [[_dict objectForKey:key] boolValue];
    //如果这个是NO的话,就收起来,也就是这个section里边的cell的个数变为0;
    if (isSpread == NO) {
        return 0;
    }
   
    return 10;
}

//设置有多少个section
-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView
{
    return _arrayData.count;
}

//给每个cell添加数据
-(UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld组的第%ld个数据",indexPath.section,indexPath.row];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 0.3)];
    label.backgroundColor = [UIColor greenColor];
    [cell.contentView addSubview:label];
    
    
    return cell;
    
}

//设置section的headerView的高度
-(CGFloat)tableView:(nonnull UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

//自定义section的headerView
-(UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //创建一个view
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.userInteractionEnabled = YES;
    view.tag = section + 1000;
    view.backgroundColor = [UIColor grayColor];
    
    //查看该section的值是来改变箭头
    NSString * key = [NSString stringWithFormat:@"%ld",section];
    BOOL isSpread = [[_dict objectForKey:key] boolValue];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    if (isSpread == NO) {
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_spread"]];
    }else
    {
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_fold"]];
    }
    
    
    //添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    //添加label作为cell的分割线
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 0.3)];
    label.backgroundColor = [UIColor whiteColor];
    
    
    
    [view addGestureRecognizer:tap];
    
    [view addSubview:imageView];
    [view addSubview:label];
    return view;
}

//点击手势
-(void)tapClick:(UITapGestureRecognizer *)gesture
{
    //拿到点击的view,改变状态后在写回字典
    NSInteger section =gesture.view.tag - 1000;
    
    NSString * key = [NSString stringWithFormat:@"%ld",section];
    BOOL isPickUp = [[_dict objectForKey:key] boolValue];
    
    NSNumber * num = [NSNumber numberWithBool:!isPickUp];
    
    [_dict setObject:num forKey:key];
    
    
    
    
    //重新加载数据,会执行tableView的代理方法,然后根据每个字典中section不同的状况来进行相应的展示
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
