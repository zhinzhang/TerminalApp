# TerminalApp
找到iOS崩溃日志中错误的位置

#ZZN的笔记

### iOS13更新之后更新了一下微信分享SDK(WechatOpenSDK)，发现分享功能无法正常使用了，经历如下

 ##### pod update WechatOpenSDK 成功之后，发现有几个方法被弃用了
[参考微信配置文档](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html)
```
[WXApi registerApp:@"*********" enableMTA:YES];//弃用
[WXApi sendReq:req];//弃用
```
```
[WXApi registerApp:@"**********" universalLink:UNIVERSAL_LINK];//新方法
[WXApi sendReq:req completion:^(BOOL success) {
        
    }];//新方法
```
- info.plist 文件中
```
LSApplicationQueriesSchemes 字段添加 weixinULAPI
```
![info.plist](https://upload-images.jianshu.io/upload_images/3119643-6b0f45b385339932.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 接下来是UniversalLink的配置(以下假设域名为www.baidu.com)

- 创建一个名为apple-app-site-association的JSON文件，文件内容如下，将文件上传至服务器根目录下，并通过 https://www.baidu.com/apple-app-site-association 访问可以查看到文件内容或者下载到本地则配置成功，也可以使用[App Search API Validation Tool](https://search.developer.apple.com/appsearch-validation-tool/)工具测试。

```
{
    "applinks": {
        "apps": [],
        "details": [{
            "appID": "56Y6KQ*****.com.XXX",//56Y6KQ*****为Team ID,com.XXX为BundleID
            "paths": ["*"]
        }]
    }
}
```
-  在Target->Signing中添加 Associated Domains.
![Associated fang wei Domains](https://upload-images.jianshu.io/upload_images/3119643-9a4246c54da9d54c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 在  Associated Domains 中添加 applinks:www.baidu.com 。
![添加Domain](https://upload-images.jianshu.io/upload_images/3119643-44847ab01456ce11.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 此时运行程序，在Safari中输入地址 www.baidu.com，访问页面时下拉，会出现下图打开按钮。
![在APP中打开](https://upload-images.jianshu.io/upload_images/3119643-541a4d43e9a4ea40.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 在[微信开放平台](https://open.weixin.qq.com)设置应用的Universal Links，保存成功后微信就可以跟以前一样分享了
![Universal Links](https://upload-images.jianshu.io/upload_images/3119643-d42d36f23c4f9f9c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



