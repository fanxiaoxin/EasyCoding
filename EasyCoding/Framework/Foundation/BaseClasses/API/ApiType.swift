//
//  Api.swift
//  YCP
//
//  Created by Fanxx on 2019/7/2.
//  Copyright © 2019 Ycp. All rights reserved.
//

import UIKit
import EasyCoding
import Moya

extension ECCustomApiType {
    public var baseURL: URL {
        return URL(string: Setting.Api.url)!
    }
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    public var paramtersFormatter: ECApiParametersFomatterType? {
        return Api.Structure.Request.ParamterFomatter()
    }
    public var defaultManager: ECApiManagerType {
        return ECImplicitApiManager.shared
    }
}

///一般Api
typealias ApiType = ECResponseApiType

///带Section类型的列表Api
typealias SectionListApiType = ECPagedResponseApiType

///带Section类型的分页列表Api
typealias SectionPagedListApiType = ECPagedResponseApiType

///列表Api
protocol ListApiType: SectionListApiType where SectionType == ECNull { }

///分页列表Api
protocol PagedListApiType: SectionPagedListApiType where SectionType == ECNull { }

///上传Api
protocol UploadApiType:ECUploadApiType, ApiType { }

///下载Api
typealias DownloadApiType = ECDownloadApiType

///具体的API类的命名空间
struct Api {
    
}
