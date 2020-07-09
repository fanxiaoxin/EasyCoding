//
//  ApiController.swift
//  EasyCoding_Example
//
//  Created by JY_NEW on 2020/7/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyCoding
import HandyJSON

extension ECCustomApiType {
    public var baseURL: URL {
        return URL(string: "https://video8.guosha.com")!
    }
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
struct ApiStructure {
     ///接口返回的通用结构及错误封装
       class Common<DataType:HandyJSON>: ECApiResponseType {
           var data: DataType?
           var code: Int = 0
           var msg: String?
           ///服务器当前时间
           var time: Date?
           
           var error: Error? {
               if self.code != 1 {
                   return self.mappingError(self.msg ?? "数据请求失败")
               }
               return nil
           }
           
           func mappingError(_ info:String) -> Error {
               return NSError(domain: "ApiModel", code: 999, userInfo: [NSLocalizedDescriptionKey: info])
           }
           required init() {
               
           }
           func mapping(mapper: HelpingMapper) {
               mapper <<< self.time <-- ECHandyJSON.secondDateTransform()
           }
       }
}

class ApiController: ECViewController<ApiView> {
    let dataSource = ECTableViewDataSource<ECViewDataPagedDecorator<ListApi>>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "接口", style: .plain, target: self, action: #selector(self.test))
    }
    @objc func test() {

        let decorator = ECViewDataPagedDecorator<ListApi>()
        decorator.targetView = self.page.tableView
        let api = ListApi()
        decorator.dataProvider = api
        dataSource.tableView = self.page.tableView
        dataSource.dataProvider = decorator
        dataSource.reloadData()
    }
    ///列表
    class ListApi : ECPagedResponseApiType {
        typealias SectionType = ECNull
        var page: Int {
            get { return self.pg}
            set { self.pg = newValue}
        }
        
        class Model: HandyJSON, ECTextualizable {
            var vod_name: String?
            required init() {
                
            }
            var text: String {
                return self.vod_name ?? "没数据"
            }
        }
        class List: HandyJSON {
            var list: [Model]?
            required init() {
                
            }
        }
        class Response: ApiStructure.Common<List>, ECApiPagedListResponseType, CustomStringConvertible {
            typealias ModelType = Model
            var list: [Model]? {
                return self.data?.list
            }
            var description: String {
                return self.toJSON()?.description ?? "空"
            }
            ///页码
            var page: Int = 0
            ///当前取到的条数
            var pagecount: Int = 0
            ///能请求到的最大条数
            var limit: Int = 0
            ///总条数
            var total: Int = 0
            
            func isEnd(for api: ECApiPagedListRequestType) -> Bool {
                let obj = api as! ListApi
                return obj.limit > self.data?.list?.count ?? 0
            }
            
            func merge(data: ApiController.ListApi.Response) -> Self {
                if let list = data.list {
                    self.data?.list?.append(contentsOf: list)
                }
                return self
            }
            
        }
        
        typealias ResponseType = Response
        var path: String {
            return "api.php/v1/provide/vod"
        }
        required init() {
        }
        var ac = "list"
        var pg: Int = 1
        var limit: Int = 10
        ///类别ID
        var t: Int?
        ///搜索关键字
        var wd: String?
        ///几小时内的数据
        var h: Int?
        ///筛选语言
        var lang: String?
        ///筛选类型
        var `class`: String?
        ///筛选区域
        var area: String?
        ///筛选年份
        var year: String?
        ///1:评分排行，2：周排行，3：月排行，默认是更新时间排行
        var order: Int?
        ///up主ID
        var upman_id: Int?
    }
    class Api: ECResponseApiType {
        class Model:HandyJSON {
            ///开启预告片的版本号
            var ios_trailer:String?
            ///当前是否只显示预告片
            var isTrailerOnly: Bool {
                return self.ios_trailer == Bundle.main.easy.version
            }
            required init() { }
        }
        
        typealias ResponseType = ApiStructure.Common<Model>
        
        required init() {
            
        }
        
        var path: String {
            return "api.php/v1/app/config"
        }
    }
}
class ApiView: ECPage {
    let tableView = UITableView()
    override func load() {
        self.easy.style(.bg(.white)).add(tableView, layout: .margin)
    }
}
