//
//  PresentTool.h
//  PresentTool
//
//  Created by 吴志华 on 2018/4/16.
//  Copyright © 2018年 wzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PresentToolAnimation) {
    PresentionBaseAnimationAlert = 0, // 系统Alert样式
    PresentionBaseAnimationActionSheet = 1, // 系统actionSheet样式
    PresentionBaseAnimationMode_0 = 2,   // 下到上
    PresentionBaseAnimationMode_1 = 3    // fade 透明度
};

@interface PresentTool : NSObject
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) PresentToolAnimation animationType;

- (instancetype)initWithPresentedVC: (UIViewController *)vc;
@end

@interface PresentConfigPresentationController: UIPresentationController
- (instancetype)initWithPresentTool: (PresentTool *)tool;
@end
