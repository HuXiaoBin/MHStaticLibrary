//
//  MHTipUtils.m
//  MHLibrary
//
//  Created by huxb on 14-10-9.
//  Copyright (c) 2014年 Outsourcing. All rights reserved.
//

#import "MHTipUtils.h"

// 编码
#define GBK_ENCODING       CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)


@implementation MHTipUtils

//判断输入的是否是合法字符串
+ (BOOL)isValuedInputStr:(id)inputTF
{
    UITextField* TF;
    UITextView* TV;
    if([inputTF isKindOfClass:[UITextField class]])
    {
        TF = (UITextField *)inputTF;

        NSString* inputStr = TF.text;
        NSString* tmpStr;
        
        for(int i=0; i<inputStr.length; i++)
        {
            tmpStr = [inputStr substringWithRange:NSMakeRange(i, 1)];
            //尚未输入完成，返回no以便继续输入
            if([[tmpStr dataUsingEncoding:GBK_ENCODING] length]==4)
            {
                return NO;
            }
            //屏蔽特殊表情
            if([[tmpStr dataUsingEncoding:GBK_ENCODING] length]==0)
            {
                TF.text = [TF.text substringWithRange:NSMakeRange(0, TF.text.length-2)];
                return NO;
            }
        }
    }
    else
    {
        TV = (UITextView *)inputTF;
        
        NSString* inputStr = TV.text;
        NSString* tmpStr;
        
        for(int i=0; i<inputStr.length; i++)
        {
            tmpStr = [inputStr substringWithRange:NSMakeRange(i, 1)];
            //尚未输入完成
            if([[tmpStr dataUsingEncoding:GBK_ENCODING] length]==4)
            {
                return NO;
            }
            //屏蔽特殊表情
            if([[tmpStr dataUsingEncoding:GBK_ENCODING] length]==0)
            {
                TV.text = [TV.text substringWithRange:NSMakeRange(0, TV.text.length-2)];
                return NO;
            }
        }
    }
    
    return YES;
}

//截取中英文混合字符串(汉字算2个长度，其他算一个长度)
+ (NSString *)getStringFromHybirdStr:(NSString *)hybirdStr withLength:(int)length
{
    int strlength = length*2;
    NSString* tmpStr;
    NSString* resultStr;
    int count=0;
    for (int i=0; i<strlength; i++)
    {
        tmpStr = [hybirdStr substringWithRange:NSMakeRange(i, 1)];
//        NSLog(@"%d",(int)[[tmpStr dataUsingEncoding:GBK_ENCODING2] length]);
        if([[tmpStr dataUsingEncoding:GBK_ENCODING] length]==2)
        {
            count+=2;
        }
        else if([[tmpStr dataUsingEncoding:GBK_ENCODING] length]==4)
        {
            count+=4;
        }
        else
        {
            count+=1;
        }
        
        //最后字符是单字符,包括最后字符
        if(count == strlength)
        {
            resultStr = [hybirdStr substringWithRange:NSMakeRange(0, i+1)];
            break;
        }
        //最后字符是中文的一半，去除最后字符
        if(count > strlength)
        {
            resultStr = [hybirdStr substringWithRange:NSMakeRange(0, i)];
            break;
        }
    }
    
    //替换不正常空格字符为正常空格字符
    NSMutableString *mStr = [[NSMutableString alloc] initWithCapacity:0];
    BOOL hasBlank = NO;
    for(int i = 0;i <resultStr.length; i++)
    {
        tmpStr = [resultStr substringWithRange:NSMakeRange(i, 1)];
        if([[tmpStr dataUsingEncoding:GBK_ENCODING] length]==4)
        {
            hasBlank = YES;
            tmpStr = @" ";
        }
        [mStr appendString:tmpStr];
    }
    resultStr = [NSString stringWithString:mStr];
    
    if(hasBlank)
    {
        UIViewController* topVC = [self appRootViewController];
        [topVC.view endEditing:YES];
    }
    
    return resultStr;
}

/**
 *判断字符串长度，空格不计入长度
 **/
+ (int)lengthOfString:(NSString *)str
{
    NSString *tmpStr;
    int length = 0;
    for (int i = 0; i<[str length]; i++)
    {
        tmpStr = [str substringWithRange:NSMakeRange(i, 1)];
        if([tmpStr isEqualToString:@" "])
        {}
        else
        {
            length++;
        }
    }
    return length;
}

+ (UIViewController *)appRootViewController
{
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
    
}

#pragma mark -  延时执行

+ (void)doSomething:(dispatch_block_t)functions
     afterDelayTime:(double)delayInSeconds
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), functions);
}


//+ (BOOL) IsEnableWIFI {
//    Reachability* reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    if ([reach currentReachabilityStatus] == ReachableViaWiFi) {
//        return YES;
//    } ;
//    return NO;
//}
//
//+ (BOOL) isInterventionRequired
//{
//    Reachability* reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    if ([reach currentReachabilityStatus] == NotReachable)
//    {
//        return NO;
//    } ;
//    return YES;
//}

/**
 *  手机号合法性判断
 *
 *  @param number 手机号码
 *
 *  @return 是否合法
 */
+ (BOOL)isMobile:(NSString *)number
{
    NSString *mobileRegex = @"^(13|15|18|14|17)\\d{9}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileRegex];
    return [mobileTest evaluateWithObject:number];
}

/**
 *  说明:判断字符串是否纯数字
 *
 *  @param string 字符串
 *
 *  @return 是否纯数字
 **/
+(BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  邮箱地址合法性判断
 *
 *  @param Email 邮箱地址
 *
 *  @return 是否合法
 */
+ (BOOL) IsEmailAdress:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}

/**
 *  身份证号码合法性判断
 *
 *  @param value 身份证号码
 *
 *  @return 是否合法
 */
+ (BOOL)validateIDCardNumber:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    long length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
            
            break;
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
            break;
        default:
            return NO;
            break;
    }
}


/**
 *  银行卡号码合法性判断
 *
 *  @param cardNumber 银行卡号码
 *
 *  @return 是否合法
 */
+ (BOOL) IsBankCard:(NSString *)cardNumber
{
    if(cardNumber.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++)
    {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

@end
