# LJContactManager

[![Version](https://img.shields.io/cocoapods/v/LJContactManager.svg?style=flat)](http://cocoadocs.org/docsets/LJContactManager) [![License](https://img.shields.io/cocoapods/l/LJContactManager.svg?style=flat)](http://cocoadocs.org/docsets/LJContactManager) [![Platform](https://img.shields.io/cocoapods/p/LJContactManager.svg?style=flat)](http://cocoadocs.org/docsets/LJContactManager) ![Language](https://img.shields.io/badge/Language-%20Objective%20C%20-blue.svg)

## 介绍

LJContanctManager 是一款操作通讯录的类库，iOS 9 之前使用的是 AddressBook 和 AddressBookUI 系统库，iOS 9 之后使用苹果新推出的 Contacts 和 ContactsUI 框架，一行代码搞定通讯录。

## 安装

### CocoaPods

1. 在 Podfile 中添加  `pod 'LJContactManager'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 \<LJContactManager.h\>。

### 手动安装

1. 下载 LJContactManager 文件夹内的所有内容。
2. 将 LJContactManager 内的源文件添加(拖放)到你的工程。
3. 导入 `LJContactManager.h`。

## 使用

主要提供以下的方法：

* 选择联系人

```objc
/**
 选择联系人

 @param controller 控制器
 @param completcion 回调
 */
- (void)selectContactAtController:(UIViewController *)controller
                      complection:(void (^)(NSString *name, NSString *phone))completcion;
```

![](http://upload-images.jianshu.io/upload_images/1321491-f2d513a6e5c7959d.gif?imageMogr2/auto-orient/strip)

* 创建新联系人

```objc
/**
 创建新联系人

 @param phoneNum 手机号
 @param controller 当前 Controller
 */
- (void)createNewContactWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller;
```

![](http://upload-images.jianshu.io/upload_images/1321491-3f02dc899eedb2c8.gif?imageMogr2/auto-orient/strip)

* 添加到现有联系人

```objc
/**
 添加到现有联系人

 @param phoneNum 手机号
 @param controller 当前 Controller
 */
- (void)addToExistingContactsWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller;
```

![](http://upload-images.jianshu.io/upload_images/1321491-8108d6477fd5bba8.gif?imageMogr2/auto-orient/strip)

* 获取联系人列表（未分组的通讯录）

```objc
/**
 获取联系人列表（未分组的通讯录）
 
 @param completcion 回调
 */
- (void)accessContactsComplection:(void (^)(BOOL succeed, NSArray <LJPerson *> *contacts))completcion;
```

![](http://upload-images.jianshu.io/upload_images/1321491-bcc3c9ec2339a87c.gif?imageMogr2/auto-orient/strip)

* 获取联系人列表（已分组的通讯录）

```objc
/**
 获取联系人列表（已分组的通讯录）

 @param completcion 回调
 */
- (void)accessSectionContactsComplection:(void (^)(BOOL succeed, NSArray <LJSectionPerson *> *contacts, NSArray <NSString *> *keys))completcion;
```

![](http://upload-images.jianshu.io/upload_images/1321491-a4df44dca74e8f47.gif?imageMogr2/auto-orient/strip)

* 通讯录变更回调（未分组的通讯录）

```objc
/**
 通讯录变更回调（未分组的通讯录）
 
 @param succeed 是否成功
 @param newContacts  联系人列表（未分组）
 */
typedef void (^LJContactChangeHanlder) (BOOL succeed, NSArray <LJPerson *> *newContacts);
```

* 通讯录变更回调（已分组的通讯录）

```objc
/**
 通讯录变更回调（已分组的通讯录）
 
 @param succeed 是否成功
 @param newSectionContacts 联系人列表（已分组）
 @param keys 所有联系人的分区标题
 */
typedef void (^LJSectionContactChangeHanlder) (BOOL succeed, NSArray <LJSectionPerson *> *newSectionContacts, NSArray <NSString *> *keys);
```

## 系统要求

该项目最低支持 iOS 8.0 和 Xcode 7.0。

## 相关文章

[iOS 通讯录开发的所有姿势](http://www.jianshu.com/p/55d1c90f62c8)

