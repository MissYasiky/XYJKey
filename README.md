# XYJKey

## 简介
这是一款密码管理 app，1.1 版本只提供银行账号密码的管理。

### 安全
1、该 app 启动时，以及从后台进入前台时，均需输入密码，密码采用的是**动态密码**，密码规则详见代码（开发者可自己定义属于自己的密码）。如不需要密码，可修改宏 **XYJ_PassWord_Necessary**。

2、该 app 无网络调用，无云同步，可放心使用。

### 缓存
所有用户数据均使用 sqlite 文件的形式缓存在本地沙盒文件夹中，并对原始数据进行了混淆、编码。即使被人拿到 sqlite 文件也不怕。

### 功能
支持银行账号密码的相关数据录入，支持增、删、改、读。
为了方便调试，app 中接入了内存管理实时监测悬浮窗。

## v1.1 界面截屏

![密码界面](https://github.com/MissYasiky/XYJKey/blob/master/ScreenShot/iPhone%206%20Screen%20Shot_1.png)  
![列表界面](https://github.com/MissYasiky/XYJKey/blob/master/ScreenShot/iPhone%206%20Screen%20Shot_2.png)  
![新增数据界面](https://github.com/MissYasiky/XYJKey/blob/master/ScreenShot/iPhone%206%20Screen%20Shot_3.png)
