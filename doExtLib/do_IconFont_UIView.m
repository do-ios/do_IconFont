//
//  do_IconFont_View.m
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_IconFont_UIView.h"

#import "doInvokeResult.h"
#import "doUIModuleHelper.h"
#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"

@interface do_IconFont_UIView()
{
    NSMutableDictionary *_attributeDict;
    int curFontSize;
    NSString *curIconName;
    NSString *curText;
}

@end

@implementation do_IconFont_UIView
#pragma mark - doIUIModuleView协议方法（必须）
//引用Model对象
- (void) LoadView: (doUIModule *) _doUIModule
{
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = true;
    _model = (typeof(_model)) _doUIModule;
    curFontSize = [doUIModuleHelper GetDeviceFontSize:17 :_model.XZoom :_model.YZoom];
    _attributeDict = [NSMutableDictionary dictionary];
    [_attributeDict setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [_attributeDict setObject:[UIFont systemFontOfSize:curFontSize] forKey:NSFontAttributeName];
}
//销毁所有的全局对象
- (void) OnDispose
{
    //自定义的全局属性,view-model(UIModel)类销毁时会递归调用<子view-model(UIModel)>的该方法，将上层的引用切断。所以如果self类有非原生扩展，需主动调用view-model(UIModel)的该方法。(App || Page)-->强引用-->view-model(UIModel)-->强引用-->view
}
//实现布局
- (void) OnRedraw
{
    //实现布局相关的修改,如果添加了非原生的view需要主动调用该view的OnRedraw，递归完成布局。view(OnRedraw)<显示布局>-->调用-->view-model(UIModel)<OnRedraw>
    
    //重新调整视图的x,y,w,h
    [doUIModuleHelper OnRedraw:_model];
}

#pragma mark - TYPEID_IView协议方法（必须）
#pragma mark - Changed_属性
/*
 如果在Model及父类中注册过 "属性"，可用这种方法获取
 NSString *属性名 = [(doUIModule *)_model GetPropertyValue:@"属性名"];
 
 获取属性最初的默认值
 NSString *属性名 = [(doUIModule *)_model GetProperty:@"属性名"].DefaultValue;
 */
- (void)change_iconCode:(NSString *)newValue
{
    //自己的代码实现
    unsigned c = 0;
    NSScanner *scanner = [NSScanner scannerWithString:newValue];
    [scanner scanHexInt: &c];
    NSString* unicodeStr = [NSString stringWithFormat: @"%C", (unsigned short)c];
    curText = unicodeStr;
    [self changeText];
}
- (void)change_iconColor:(NSString *)newValue
{
    //自己的代码实现
    UIColor *fontColor = [doUIModuleHelper GetColorFromString:newValue :[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [_attributeDict setObject:fontColor forKey:NSForegroundColorAttributeName];
    [self changeText];
}
- (void)change_iconName:(NSString *)newValue
{
    //自己的代码实现
    curIconName = newValue;
    UIFont *iconfont = [UIFont fontWithName:newValue size: curFontSize];
    [_attributeDict setObject:iconfont forKey:NSFontAttributeName];
}
- (void)change_iconSize:(NSString *)newValue
{
    //自己的代码实现
    curFontSize = curFontSize = [doUIModuleHelper GetDeviceFontSize:[newValue intValue] :_model.XZoom :_model.YZoom];
    if (curIconName) {
        [self change_iconName:curIconName];
    }
    [self changeText];
}

#pragma mark - 私有方法
- (void)changeText
{
    if (curText) {
        NSAttributedString *attriStr = [[NSAttributedString alloc]initWithString:curText attributes:_attributeDict];
        self.attributedText = attriStr;
    }
}

#pragma mark -事件处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    doInvokeResult * _invokeResult = [[doInvokeResult alloc]init:_model.UniqueKey];
    [_model.EventCenter FireEvent:@"touch" :_invokeResult];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    //这里的BOOL值，可以设置为int的标记。从model里获取。
    if([_model.EventCenter GetEventCount:@"touch"] <= 0)
        if(view == self)
            view = nil;
    return view;
}

#pragma mark - doIUIModuleView协议方法（必须）<大部分情况不需修改>
- (BOOL) OnPropertiesChanging: (NSMutableDictionary *) _changedValues
{
    //属性改变时,返回NO，将不会执行Changed方法
    return YES;
}
- (void) OnPropertiesChanged: (NSMutableDictionary*) _changedValues
{
    //_model的属性进行修改，同时调用self的对应的属性方法，修改视图
    [doUIModuleHelper HandleViewProperChanged: self :_model : _changedValues ];
}
- (BOOL) InvokeSyncMethod: (NSString *) _methodName : (NSDictionary *)_dicParas :(id<doIScriptEngine>)_scriptEngine : (doInvokeResult *) _invokeResult
{
    //同步消息
    return [doScriptEngineHelper InvokeSyncSelector:self : _methodName :_dicParas :_scriptEngine :_invokeResult];
}
- (BOOL) InvokeAsyncMethod: (NSString *) _methodName : (NSDictionary *) _dicParas :(id<doIScriptEngine>) _scriptEngine : (NSString *) _callbackFuncName
{
    //异步消息
    return [doScriptEngineHelper InvokeASyncSelector:self : _methodName :_dicParas :_scriptEngine: _callbackFuncName];
}
- (doUIModule *) GetModel
{
    //获取model对象
    return _model;
}

@end
