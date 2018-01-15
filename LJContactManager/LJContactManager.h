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
 
 @param succeed 是否成功
 @param newContacts  联系人列表（未分组）
 */
typedef void (^LJContactChangeHandler) (BOOL succeed, NSArray <LJPerson *> *newContacts);

/**
 通讯录变更回调（已分组的通讯录）
 
 @param succeed 是否成功
 @param newSectionContacts 联系人列表（已分组）
 @param keys 所有联系人的分区标题
 */
typedef void (^LJSectionContactChangeHandler) (BOOL succeed, NSArray <LJSectionPerson *> *newSectionContacts, NSArray <NSString *> *keys);

@interface LJContactManager : NSObject

+ (instancetype)sharedInstance;

/**
 通讯录变更回调（未分组的通讯录）
 */
@property (nonatomic, copy) LJContactChangeHandler contactChangeHandler;

/**
 通讯录变更回调（已分组的通讯录）
 */
@property (nonatomic, copy) LJSectionContactChangeHandler sectionContactChangeHandler;

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
