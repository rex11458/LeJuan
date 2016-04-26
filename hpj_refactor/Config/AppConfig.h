//
//  AppConfig.h
//  lianhebao
//
//  Created by Steven on 14-9-26.
//  Copyright (c) 2014年 Steven. All rights reserved.
//
//组建配置

/*!!!*************颜色与字体*********************/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//背景色
#define PYBackgroudColor UIColorFromRGB(0xF5F5F5)
//主题色
#define PYMainColor UIColorFromRGB(0x45C1BC)
//分割线颜色
#define PYSeparatorLineColor UIColorFromRGB(0xEAEAEA)
/*!
 第一级文字
 重要文字信息呈现颜色
 */
#define PY_LEVEL_1_FONT_COLOR UIColorFromRGB(0x494949)

/*!
 第二级文字
 次要文字信息呈现颜色
 */
#define PY_LEVEL_2_FONT_COLOR UIColorFromRGB(0x888888)

/*!
 第三级文字
 */
#define PY_LEVEL_3_FONT_COLOR UIColorFromRGB(0xC6C6C6)

/*!
 分割线
 */
#define PY_SEPARATOR_LINE_COLOR UIColorFromRGB(0xE6E6E6)

/*!
 白色背景按钮选中后的状态色
 */
#define UU_WHITH_BUTTON_SELECTED_COLOR [UIColor colorWithWhite:0.8 alpha:0.2]
/*!
 分隔线宽度
 */
#define PY_SEPARATOR_LINE_WIDTH 1.0f

/*!
 底色背景、20px内容分隔模块
 */
#define PY_BG_COLOR UIColorFromRGB(0xF2F2F2)

/*----------各种高度、间距大小----------*/

/*!
 按钮、section 高度
 */
#define PY_BUTTON_HEIGHT 44.0f

/*!
 左右间距
 */
#define PY_HORIZONTAL_MARGIN 10.0f

/*!
 导航栏高度
 */
#define PY_NAVIGATION_HEIGHT 64.0f
/*!
 tabbar高度
 */
#define PY_TABBAR_HEIGHT 49.0f

/*!
 输入框高度
 */
#define PY_TEXTFIELD_HEIGHT 40.0f
/*----------字体大小---------------*/

/*!
 大号字体
 */
#define PY_LARGE_FONT_SIZE 16.0f
#define PY_LARGE_BOLD_FONT [UIFont boldSystemFontOfSize:PY_LARGE_FONT_SIZE]
#define PY_LARGE_SYSTEM_FONT [UIFont systemFontOfSize:PY_LARGE_FONT_SIZE]

/*!
 中号字体
 */
#define PY_MIDDLE_FONT_SIZE 14.0f
#define PY_MIDDLE_SYSTEM_FONT [UIFont systemFontOfSize:PY_MIDDLE_FONT_SIZE]


/*!
 小号字体
 */
#define PY_SMALL_FONT_SIZE 12.0f
#define PY_SMALL_SYSTEM_FONT [UIFont systemFontOfSize:PY_SMALL_FONT_SIZE]

/*****************************************************!!!*/


#define PYCurrentUserLoginName [PYLoginUserManager shareInstance].loginUser.loginName
#define PYCurrentUserLoginId [PYLoginUserManager shareInstance].loginUser.userLoginId


// StatusBar activityIndicator status
#define PYNetworkActivityIndicatorVisiable(isVisible) [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isVisible]

/**----------------------相关路径-------------------------**/
//Main.storyborad
#define PYMainStoryboard [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]

//Network status
#define PYReachabilityStatus [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]

//Fir自动更新-API token
#define FirToken @"a27e8c991fe08f76600af1ce8272365c"

// 图片文件名称
#define Survey_Pic @"pic"


/*友盟Id*/
#define PYUMengAnalyticsId @"569df223e0f55a7e57000d4e"



#define PYAppVsersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/*-----沙盒路径-----*/

//-Sandbox document directory
#define  DocumentDir    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//问卷根路径
#define PYQuestionnaireRootPath [NSString stringWithFormat:@"%@/wenjuan",DocumentDir]


//JS文件夹名
#define PYAssetName @"assets3"

//JS路径
#define PYLoginQuestionnaireJSSadboxPath [NSString stringWithFormat:@"%@/%@",PYQuestionnaireRootPath,PYAssetName]

// 当前登录用户已下载问卷的路径
#define PYUserQuestionnaireSadboxPath [NSString stringWithFormat:@"%@/jsp/%@",PYQuestionnaireRootPath,[PYLoginUserManager shareInstance].loginUser.loginName]

//问卷路径
#define PYQuestionnaireSadboxPath(resultId)[PYUserQuestionnaireSadboxPath stringByAppendingPathComponent:[resultId stringByAppendingPathExtension:@"html"]]
//图片地址
#define PYPictureSadboxPath [PYUserQuestionnaireSadboxPath stringByAppendingPathComponent:@"pic"]




//变量名转字符串
#define varname_to_string(name)  [NSString stringWithUTF8String:(#name)]



