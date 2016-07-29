# iOS 集成TCAdapter，个性化功能示例

##送花示例

本demo目前主要有两个功能（后续会加上另外的个性化功能示例，目前只有送花示例）
1、体现如何集成随心播(在工程中全局搜索 集成S_ 即可查看集成步骤)
2、实现了送花消息的发送接收和界面展示效果，用户可参考（在工程中全局搜索 送花S_ 即可查看送花消息实现步骤）

集成过程容易出错的地方

1、配置需注意：
1.1 pch文件路径的配置
1.2 部分文件的arc配置 (AVGLShareInstance.m,AVGLRenderView.mm,AVGLRenderView+Animation.m,AVGLImage.m,AVGLBaseView.m,AVFrameDispatcher.m,JSONKit.m等文件)
1.3 新建的工程会生成ViewController.h/m和Main.storyboard文件，直接删除，运行时会crash，需要在plist文件中移除Main storyboard file base name 项

2、进入聊天室失败
2.1 请求主播画面，有声音，无画面(参数传错了,主播id传错了，主播id区分大小写的)
2.2 创建房间时提示进入聊天室失败，直播id和聊天室id填写得不合法（因为这里的id是自己手动填写的，所以id有可能已经被别的直播占用的，需要更换一下id，房间id和聊天室id可以填写一样的,也可以填写不一样，聊天室id可以是字符串）