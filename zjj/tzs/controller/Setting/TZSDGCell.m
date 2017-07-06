//
//  TZSDGCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/23.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TZSDGCell.h"
#import "HDCell.h"
@implementation TZSDGCell
{
    int count ;
    NSMutableArray * hdArr;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    count = 0;

    // Initialization code
    
    self.hdTableView.delegate = self;
    self.hdTableView.dataSource =self;
    self.hdTableView.userInteractionEnabled = NO;
    self.hdTableView.scrollEnabled= NO;
    [self.hdTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setExtraCellLineHiddenWithTb:self.hdTableView];
    hdArr= [NSMutableArray array];
    
}
-(void)setExtraCellLineHiddenWithTb:(UITableView *)tb
{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tb setTableFooterView:view];
}

-(void)setHdArray:(NSArray *)arr
{
    [hdArr removeAllObjects];
    [hdArr addObjectsFromArray:arr];;
    [self.hdTableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return hdArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"HDCell";
    HDCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray * arr = [[NSBundle mainBundle]loadNibNamed:identifier owner:nil options:nil];
        cell = [arr lastObject];
    }
    NSDictionary *dic =[hdArr objectAtIndex:indexPath.row];
    int hdtype = [[dic objectForKey:@"promotionType"]intValue];
    if (hdtype ==1) {
        cell.titleLabel.text = @"满减";
    }else{
        cell.titleLabel.text= @"满赠";
    }
    cell.detailLabel.text = [dic objectForKey:@"promotionDetail"];
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didAdd:(id)sender {
    
    count = [self.countLabel.text intValue];
    count++;
    self.countLabel.text =[NSString stringWithFormat:@"%d",count];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addCountWithCell:)]) {
        [self.delegate addCountWithCell:self];
    }
}

- (IBAction)didRed:(id)sender {
    count = [self.countLabel.text intValue];
    count--;
    self.countLabel.text =[NSString stringWithFormat:@"%d",count];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(redCountWithCell:)]) {
        [self.delegate redCountWithCell:self];
    }

}

- (IBAction)didbuy:(id)sender {
}
@end
