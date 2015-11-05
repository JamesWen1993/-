//
//  QucikModel.h
//  Schoolyard
//
//  Created by mac on 15/10/15.
//  Copyright (c) 2015年 l.l.ang. All rights reserved.
//

/* 
 "billcode": "200093247451",
 "errMsg": "",
 "expressCode": "YT",
 "expressName": "圆通",
 "lastQueryTime": 1436582267375,
 "lastStatusTime": 1429060196000,
 "queryFrom": 1,
 "resultString": "",
 "status": 100,
 "success": true,
 "wayBills": [
 {
 "datetime": 1429060196000,
 "processInfo": "山东省潍坊市潍城区十笏园分部公司 签收人 : 张 已签收",
 "remark": "",
 "time": "2015-04-15 09:09:56.0 CST"
 }
 ]
 }
 ],
 "error": "",
 "result": 1,
 "type": 0,
 "url": ""
 }
 备注 :
 返回结果说明：
 result：结果（1表示成功； 0表示失败）
 error：失败时显示错误信息，成功时为空
 data：失败时：空 ，成功时：运单信息（
 billcode: 运单号,
 expressCode:快递公司代码，
 expressName:快递公司名称，
 status:（100：表示已签收），
 lastStatusTime：签收时间
 lastQueryTime：查询时间
 wayBills：运单轨迹）
 */

#import "BaseModel.h"

@interface QucikModel : BaseModel

@property(nonatomic,copy)NSString       *billcode;       //订单号
@property(nonatomic,copy)NSString       *expressCode;        //快递公司id
@property(nonatomic,copy)NSString       *expressName;        //快递公司
@property (nonatomic,copy)NSArray      *time;
@property (nonatomic,copy)NSArray      *processInfo;
@property (nonatomic,strong)NSArray     *wayBills;


@end
