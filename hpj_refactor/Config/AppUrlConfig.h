//
//  UrlConfig.h
//  lianhebao
//
//  Created by Steven on 14-9-26.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

// 配置 DEBUG和RELEASE参数
#if defined (DEBUG) && DEBUG == 1

    #define TTLog(...) NSLog(__VA_ARGS__)
#else
    #define TTLog(...)
#endif



//#define PYBaseURL @"http://www.dfjky.com/hp/"
//#define kBaseURL @"http://180.166.93.195:8888/hp/"
//#define PYBaseURL @"http://139.196.107.61:8888/hp/"
//#define PYBaseURL @"http://139.196.173.253/demouser3/qulian"

//#define PYBaseURL @"http://radar.alwaysmkt.com.cn"
#define PYBaseURL @"http://116.236.199.202/hp"
//banner
#define kHTTP_GETBANNER        @"publicapi.PublicApiPRC.getBanner.submit"

//company列表
#define kHTTP_GETCOMPANY       @"publicapi.PublicApiPRC.getCompany.submit"

//客户信息列表
#define kHTTP_GETCUSTOMER      @"publicapi.PublicApiPRC.getCustomer.submit"

//调查对象（门店）列表
#define kHTTP_GETSURVEY        @"publicapi.PublicApiPRC.getSurveyObject.submit"

//承接任务
#define kHTTP_DOWNLOADTASK     @"publicapi.PublicApiPRC.downloadTask.submit"

//我的任务
#define kHTTP_MYTASK           @"publicapi.PublicApiPRC.myTask.submit"

//进店签到
#define kHTTP_CHECKIN          @"publicapi.PublicApiPRC.checkIn.submit"

//提交问卷结果
#define PYSubmitResultURL     @"publicapi.PublicApiPRC.submitResult.submit"

//更新下载任务标记

//上传图片
#define PYSubmitImageURL        @"publicapi.PublicApiPRC.submitImage.submit"

//登录
#define PYLoginURL            @"publicapi.PublicApiPRC.login.submit"
#define PYLoginBody(loginId,loginPwd)      @{@"loginId":loginId,@"loginPwd":loginPwd}

//下载问卷
#define PYDownloadQestionnireURL(pageId,resultId,loginId)  [NSString stringWithFormat:@"jsp/paper/PaperDetail.jsp?deviceType=m&paperId=%@&resultId=%@&userLoginId=%d",paperId,resultId,(int)loginId]

#define PYUpdateDownloadStatusURL  @"publicapi.PublicApiPRC.updateDownloadStatus.submit"


//任务列表
#define PYTaskListURL         @"publicapi.PublicApiPRC.taskList.submit"
#define PYTaskListBody(userLoginId,type,pageIndex) @{@"userLoginId":userLoginId,@"pageIndex":pageIndex,@"type":type}


// 更新JS
#define PYCheckJsUpdateURL        @"publicapi.PublicApiPRC.upgrade.submit"
#define PYChekJsUpdateBody     @{@"appType":@"IOS"}







