//
//  LJAddressBookManager.h
//  LJContactManager
//
//  Created by LeeJay on 2017/3/22.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJPerson, LJSectionPerson;

/**
 通讯录变更回调（未分组的通讯录）
 */
typedef void (^LJContactChangeHandler) (void);

@interface LJContactManager : NSObject

+ (instancetype)sharedInstance;

/**
 通讯录变更回调
 */
@property (nonatomic, copy) LJContactChangeHandler contactChangeHandler;

/**
 请求授权

 @param completion 回调
 */
- (void)requestAddressBookAuthorization:(void (^) (BOOL authorization))completion;

/**
 选择联系人

 @param controller 控制器
 @param completcion 回调
 */
- (void)selectContactAtController:(UIViewController *)controller
                      complection:(void (^)(NSString *name, NSString *phone))completcion;

/**
 创建新联系人

 @param phoneNum 手机号
 @param controller 当前 Controller
 */
- (void)createNewContactWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller;

/**
 添加到现有联系人

 @param phoneNum 手机号
 @param controller 当前 Controller
 */
- (void)addToExistingContactsWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller;

/**
 获取联系人列表（未分组的通讯录）
 
 @param completcion 回调
 */
- (void)accessContactsComplection:(void (^)(BOOL succeed, NSArray <LJPerson *> *contacts))completcion;

/**
 获取联系人列表（已分组的通讯录）

 @param completcion 回调
 */
- (void)accessSectionContactsComplection:(void (^)(BOOL succeed, NSArray <LJSectionPerson *> *contacts, NSArray <NSString *> *keys))completcion;

@end
