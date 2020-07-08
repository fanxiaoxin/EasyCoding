//
//  JsonApiSerializer.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/6/5.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
import HandyJSON

///API请求参数格式化
public protocol ECApiParametersFomatterType {
    func format(api:ECApiType) -> [String:Any]?
}
public protocol ECApiResponseType: HandyJSON {
    ///判断当前接口数据是否失败，若为nil才会去取数据及列表字段
    var error: Error? { get }
}
public protocol ECApiListResponseType: ECApiResponseType {
    associatedtype ModelType: HandyJSON
    ///返回列表数据
    var list: [ModelType]? { get }
}
public protocol ECApiPagedListResponseType: ECApiListResponseType {
    ///返回是否列表是否已到底
    var isEnd: Bool { get }
}
///API列表请求结构
public protocol ECApiPagedListRequestType: HandyJSON {
    ///页数
    var page: Int { get set }
}
