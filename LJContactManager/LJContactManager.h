//
//  LJAddressBookManager.h
//  LJContactManager
//
//  Created by LeeJay on 2017/3/22.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJPerson, LJSectionPerson;

@interface LJContactManager : NSObject

+ (instancetype)sharedInstance;

/**
 通讯录变更回调（未排序的通讯录）
 */
@property (nonatomic, copy) void (^contactsChangeHanlder) (BOOL succeed, NSArray <LJPerson *> *newContacts);

/**
 通讯录变更回调（已经排序的通讯录）
 */
@property (nonatomic, copy) void (^sectionContactsHanlder) (BOOL succeed, NSArray <LJSectionPerson *> *newSectionContacts);

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
 获取联系人列表（未排序的通讯录）
 
 @param completcion 回调
 */
- (void)accessContactsComplection:(void (^)(BOOL succeed, NSArray <LJPerson *> *contacts))completcion;

/**
 获取联系人列表（已排序的通讯录）

 @param completcion 回调
 */
- (void)accessSortContactsComplection:(void (^)(BOOL succeed, NSArray <LJSectionPerson *> *contacts, NSArray <NSString *> *keys))completcion;

@end
