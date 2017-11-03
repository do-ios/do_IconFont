//
//  do_IconFont_View.h
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "do_IconFont_IView.h"
#import "do_IconFont_UIModel.h"
#import "doIUIModuleView.h"

@interface do_IconFont_UIView : UILabel<do_IconFont_IView, doIUIModuleView>
//可根据具体实现替换UIView
{
	@private
		__weak do_IconFont_UIModel *_model;
}

@end
