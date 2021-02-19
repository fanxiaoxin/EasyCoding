//
//  JsonApiSerializer.swift
//  EasyCoding
//
//  Created by Fanxx on 2019/6/5.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
import HandyJSON
import Moya

///基础响应类型
public protocol EasyApiResponseType: HandyJSON {
    ///判断当前接口数据是否失败，若为nil才会去取数据及列表字段
    var error: Error? { get }
}
///列表响应类型
public protocol EasyApiListResponseType: EasyApiResponseType {
    associatedtype ModelType: HandyJSON
    ///返回列表数据
    var list: [ModelType]? { get }
}
///分页列表请求类型
public protocol EasyApiPagedListRequestType: HandyJSON {
    ///页数
    var page: Int { get set }
}
///分页列表响应类型
public protocol EasyApiPagedListResponseType: EasyApiListResponseType {
    ///返回是否列表是否已到底
    func isEnd(for api: EasyApiPagedListRequestType) -> Bool
    ///整合两页数据
    func merge(data: Self) -> Self
}
