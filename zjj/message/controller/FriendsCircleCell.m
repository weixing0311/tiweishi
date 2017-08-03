
//
//  FriendsCircleCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "FriendsCircleCell.h"

@implementation FriendsCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfoWithDict:(NSDictionary *)dict
{
    self.headImageView.image = [UIImage imageNamed:@"logo"];
    self.titleView.text = [dict safeObjectForKey:@"title"];
    self.contentLabel.text = [dict safeObjectForKey:@"content"];
    self.timeLabel.text = [dict safeObjectForKey:@"releaseTime"];
    for (UIView * view in self.imagesView.subviews) {
        [view removeFromSuperview];
    }
//    NSMutableArray * imageArr =[dict safeObjectForKey:@"pictures"];
//    NSString * cardUrl = [dict safeObjectForKey:@"cardUrl"];
//    [imageArr addObject:cardUrl];

    [self buildNineImagesWithArray:[dict safeObjectForKey:@"pictures"]];
}

-(void)buildNineImagesWithArray:(NSArray *)array
{
    int totalColumns = 3;
    
    //       每一格的尺寸
    CGFloat cellW = (JFA_SCREEN_WIDTH-108)/3;
    CGFloat cellH = (JFA_SCREEN_WIDTH-108)/3;
    
    //    间隙
    CGFloat margin =10;
    
    //    根据格子个数创建对应的框框
    for(int index = 0; index< array.count; index++) {
        UIButton *cellView = [UIButton buttonWithType:UIButtonTypeCustom ];
        cellView.backgroundColor = HEXCOLOR(0xeeeeee);
        [cellView setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:array[index]] placeholderImage:[UIImage imageNamed:@"default"]];
        cellView.tag = index+1;
        [cellView addTarget:self action:@selector(didClickImages:) forControlEvents:UIControlEventTouchUpInside];
        // 计算行号  和   列号
        int row = index / totalColumns;
        int col = index % totalColumns;
        //根据行号和列号来确定 子控件的坐标
        CGFloat cellX = col * (cellW + margin);
        CGFloat cellY = row * (cellH + margin);
        cellView.frame = CGRectMake(cellX, cellY, cellW, cellH);
        
        // 添加到view 中  
        [self.imagesView addSubview:cellView];
    }  
}

-(void)didClickImages:(UIButton *)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didCheckImagesWithButton:cell:)]) {
        [self.delegate didCheckImagesWithButton:sender cell:self];
    }
}

- (IBAction)didShare:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickShareWithCell:)]) {
        [self.delegate didClickShareWithCell:self];
    }
    
}
@end
