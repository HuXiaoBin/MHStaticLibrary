//
//  MHAlertView.h
//  MHLibrary
//
//  Created by huxb on 14-10-9.
//  Copyright (c) 2014年 huxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHAlertViewDelegate <NSObject>

- (void)MHAlertView:(UIView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface MHAlertView : UIView

- (void)show;

- (void)localShow;

- (void)dismiss;

@end
