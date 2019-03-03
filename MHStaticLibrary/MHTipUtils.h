//
//  MHTipUtils.h
//  MHLibrary
//
//  Created by huxb on 14-10-9.
//  Copyright (c) 2014年 huxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MHTipUtils : NSObject

/**
 *判断输入的字符串是否合法，是否可以进行下一步操作
 **/
+ (BOOL)isValuedInputStr:(id)inputTF;

/**
 *截取中英文混合字符串(汉字算2个长度，其他算一个长度)
 **/
+ (NSString *)getStringFromHybirdStr:(NSString *)hybirdStr withLength:(int)length;

/**
 *判断字符串长度，空格不计入长度
 **/
+ (int)lengthOfString:(NSString *)str;

/**
 *  说明:获取最顶层的VC
 **/
+ (UIViewController *)appRootViewController;

//延时执行
+ (void)doSomething:(dispatch_block_t)functions
     afterDelayTime:(double)delayInSeconds;

/**
 *  说明:判断wifi是否可用
 **/
//+ (BOOL) IsEnableWIFI;

/**
 *  说明:判断网络是否可用
 **/
//+ (BOOL) isInterventionRequired;

/**
 *  手机号合法性判断
 *
 *  @param number 手机号码
 *
 *  @return 是否合法
 */
+ (BOOL)isMobile:(NSString *)number;

/**
 *  说明:判断字符串是否纯数字
 *
 *  @param string 字符串
 *
 *  @return 是否纯数字
 **/
+(BOOL)isPureInt:(NSString*)string;

/**
 *  邮箱地址合法性判断
 *
 *  @param Email 邮箱地址
 *
 *  @return 是否合法
 */
+ (BOOL) IsEmailAdress:(NSString *)Email;

/**
 *  身份证号码合法性判断
 *
 *  @param value 身份证号码
 *
 *  @return 是否合法
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;

/**
 *  银行卡号码合法性判断
 *
 *  @param cardNumber 银行卡号码
 *
 *  @return 是否合法
 */
+ (BOOL) IsBankCard:(NSString *)cardNumber;

@end
