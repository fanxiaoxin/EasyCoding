# Application

APP具体页面功能代码
与BaseClasses目录下的结构基本一致

## Models

APP通用模型，目录层级结构与Main/Modules下一致

## Api

存放所有接口，目录层级结构与Main/Modules下一致

## Main

存放APP的主框架业务及页面代码

### Business

存放APP整个系统层级的管理类，Application类负责管理所有子模块的管理类

### Control

存放APP主框架页面使用的控件

### ViewController

存放APP主框架页面

#### View

存放APP主框架页面自定义页面类

### Modules

存放每个功能模块代码，以目录划分，目录下的层级结构与Main目录保持一致；

若有子模块也同样加Modules目录，往下层级结构同样一致；

当中所有目录若不存在文件皆可不创建
