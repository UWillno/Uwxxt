uwzz

##### 介绍
  zazhi.apk为我室友所写的一个app，可以从武昌首义学院教务系统获取课表、成绩等信息，也可以使用学习通签到（手动，支持各类签到，二维码签到需二维码图片，无论图片是否过期），随堂测验（查看答案和其他同学答案）相关功能。但使用学习通相关功能必须先登录武昌首义学院教务系统。
  uwzz为一个方法用于淦掉zazhi的教务系统登录和检查函数，以达到直接使用学习通相关功能的目的。需要root和xposed框架，即让非武昌首义学院的学生也可以使用zazhi的学习通功能。

##### 软件架构
我不懂


##### 安装教程
见使用说明

##### 使用说明
0.下载uwzz.zip,解压zip，
1.  安装zazhi.apk和uwzz.apk
2.  xposed框架里勾选uwzz.apk。LSP作用域选为zazhi，重启设备
3.  修改xml里面对应的中文并保存
4.  以root运行“xxxx”.sh，推荐用MT管理器执行
5.  改密码后重复3、4操作
新版不需要改xml，暂不发行，测试中
#### 参与贡献
我不懂
bug反馈qq群960629141 
zazhi作者也在内，不保证下一版我也能淦掉。  

不会用git，这个md恢复到2个月前的了。。  
zazhi已停更，但仍可使用  
Uwzz随缘更新，且已开源？  
已将部分zazhi功能在Uwzz的webview中实现，以便非root用户使用和自用。  
目前Uwzz内已实现手势签到、二维码签到、查看随堂测验、（玄学）查看作业答案、  
查看课程积分统计、查看课程作业统计的功能  
增强了跳过zazhi教务系统的功能，不过实测在MIUI12.5安卓11和安卓12还是不成功，  
也没找到shell执行失败的原因，但加强了存储权限的获取，给存储权限的情况下，  
会在sd根目录和Android\data\com.uuuuu.uwzz\files\UWillno\中生成执行的sh，在  
MT管理器中执行可以成功跳过。文件也都移到了data里，因此不再需要下载压缩包了。  


