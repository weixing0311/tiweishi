//
//  UserListView.m
//  zjj
//
//  Created by iOSdeveloper on 2017/7/3.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UserListView.h"
#import "UserCellCell.h"
@interface UserListView()<userCellDelegate>
@end
@implementation UserListView
{
    UILabel * errorLabel;
    NSTimer * hiddenErrorTimer;
}
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        self.dataArray =[NSMutableArray array];
    }
    return _dataArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:[self addBaseUser]];
        [self.dataArray addObjectsFromArray:[UserModel shareInstance].child];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenMe)];
        tap.delegate =self;
        [self addGestureRecognizer:tap];
        [self buildTableView];
        
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch  {
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
-(void)hiddenMe
{
    self.hidden = YES;
}
-(void)refreshInfo
{
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[self addBaseUser]];
    [self.dataArray addObjectsFromArray:[UserModel shareInstance].child];
    self.userTableview.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, 44*self.dataArray.count+44);
    [self.userTableview reloadData];
}
-(NSMutableDictionary *)addBaseUser
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:[UserModel shareInstance].nickName forKey:@"nickName"];
    [dic safeSetObject:[UserModel shareInstance].healthId forKey:@"id"];
    [dic safeSetObject:[UserModel shareInstance].headUrl  forKey:@"headimgurl"];
    [dic safeSetObject:[UserModel shareInstance].birthday forKey:@"birthday"];
    [dic safeSetObject:@([UserModel shareInstance].age) forKey:@"age"];
    [dic safeSetObject:@([UserModel shareInstance].gender) forKey:@"sex"];
    return dic;
}
-(void)buildTableView
{
    self.userTableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 100) style:UITableViewStylePlain];
    self.userTableview.delegate =self;
    self.userTableview.dataSource =self;
    self.userTableview.backgroundColor =[UIColor whiteColor];
    [self setExtraCellLineHiddenWithTb:self.userTableview];
    [self addSubview:self.userTableview];

}
-(void)setExtraCellLineHiddenWithTb:(UITableView *)tb
{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tb setTableFooterView:view];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return self.dataArray.count;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier =@"UserCellCell";
    UserCellCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray * arr =[[NSBundle mainBundle]loadNibNamed:identifier owner:nil options:nil];
        cell = [arr lastObject];
    }
    if (indexPath.section ==0) {
        NSDictionary * dic =[_dataArray objectAtIndex:indexPath.row];
        [cell.headImage setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"headimgurl"]]];
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell.namelabel.text = [dic safeObjectForKey:@"nickName"];
        if ([[dic objectForKey:@"id"]intValue ]==[[UserModel shareInstance].healthId intValue]) {
            cell.deleteBtn.hidden = YES;
        }else{
            cell.deleteBtn.hidden =NO;
        }
    }else{
        cell.headImage.image = [UIImage imageNamed:@"add_"];
        cell.namelabel.text = @"添加子用户";
        cell.deleteBtn . hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    
    if (indexPath.section ==0) {
        
        NSDictionary * dic =[_dataArray objectAtIndex:indexPath.row];
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(changeShowUserWithSubId:isAdd:)]) {
            [self.delegate changeShowUserWithSubId:[dic safeObjectForKey:@"id"] isAdd:NO];
        }
    }else{
        if (self.delegate &&[self.delegate respondsToSelector:@selector(changeShowUserWithSubId:isAdd:)]) {
            [self.delegate changeShowUserWithSubId:nil isAdd:YES];
        }
    }
    
    
}

-(void)deleteSubUserWithCell:(UserCellCell*)cell
{
    NSDictionary *dic =[self.dataArray objectAtIndex:cell.tag];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[dic safeObjectForKey:@"id"] forKey:@"id"];
    [[BaseSservice sharedManager]post1:@"app/evaluatUser/deleteChild.do" paramters:param success:^(NSDictionary *dic) {
        self.hidden = YES;
        [self showError:@"删除成功"];
        [[UserModel shareInstance]removeChildDict:dic];
        
        
    } failure:^(NSError *error) {
        [self showError:@"删除失败"];
    }];
}
-(void)showError:(NSString *)text;
{
    errorLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
    errorLabel.backgroundColor = RGBACOLOR(0/225.0f, 0/225.0f, 0/225.0f, .5);
    errorLabel.center = self.window.center;
    errorLabel.textColor = [UIColor whiteColor];
    errorLabel.layer.masksToBounds = YES;
    errorLabel.layer.cornerRadius =4;
    errorLabel.text = text;
    errorLabel.textAlignment = NSTextAlignmentCenter;
    [self.window addSubview:errorLabel];
    hiddenErrorTimer =   [NSTimer timerWithTimeInterval:2 target:self selector:@selector(hiddenErrirLabel) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:hiddenErrorTimer forMode:NSRunLoopCommonModes];
    
}
-(void)hiddenErrirLabel
{
    errorLabel.hidden = YES;
    [errorLabel removeFromSuperview];
    [hiddenErrorTimer invalidate];
}

@end
