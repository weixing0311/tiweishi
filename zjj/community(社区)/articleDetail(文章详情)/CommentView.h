//
//  CommentView.h
//  zjj
//
//  Created by iOSdeveloper on 2017/10/9.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol commentViewDelegate;
@interface CommentView : UIView
@property (weak, nonatomic) IBOutlet UITextField *commentTf;
- (IBAction)didSend:(id)sender;
@property (nonatomic,assign)id<commentViewDelegate>delegate;
@end
@protocol commentViewDelegate <NSObject>

-(void)didSendCommentWithText:(NSString *)textStr;

@end
