//
//  do_IconFont_UI.h
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol do_IconFont_IView <NSObject>

@required
//属性方法
- (void)change_iconCode:(NSString *)newValue;
- (void)change_iconColor:(NSString *)newValue;
- (void)change_iconName:(NSString *)newValue;
- (void)change_iconSize:(NSString *)newValue;

//同步或异步方法


@end