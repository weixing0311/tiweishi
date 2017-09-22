//
//  NewMineRelationsCell.h
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol mineRelationsCellDelegate;
@interface NewMineRelationsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *value1lb;
@property (weak, nonatomic) IBOutlet UILabel *value2lb;
@property (weak, nonatomic) IBOutlet UILabel *value3lb;

@property (nonatomic,assign)id<mineRelationsCellDelegate>delegate;
- (IBAction)didClickzt:(id)sender;

- (IBAction)didClickGZ:(id)sender;



- (IBAction)didClickFuns:(id)sender;
@end
@protocol mineRelationsCellDelegate <NSObject>

-(void)showzt;
-(void)showGZ;
-(void)showFuns;

@end
