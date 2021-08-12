<p align="center"><a href="https://yasio.org" target="_blank" rel="noopener noreferrer"><img width="160" src="docs/assets/images/logo.png" alt="yasio logo"></a></p>

# *YASIO* - *Y*et another *A*synchronous *S*ocket *I*/*O*.
[![Android Build Status](https://github.com/yasio/yasio/workflows/android/badge.svg)](https://github.com/yasio/yasio/actions?query=workflow%3Aandroid)
[![iOS Build Status](https://github.com/yasio/yasio/workflows/ios/badge.svg)](https://github.com/yasio/yasio/actions?query=workflow%3Aios)
[![Windows Build Status](https://github.com/yasio/yasio/workflows/windows/badge.svg)](https://github.com/yasio/yasio/actions?query=workflow%3Awin32)
[![Linux Build Status](https://github.com/yasio/yasio/workflows/linux/badge.svg)](https://github.com/yasio/yasio/actions?query=workflow%3Alinux)
[![macOS Build Status](https://github.com/yasio/yasio/workflows/osx/badge.svg)](https://github.com/yasio/yasio/actions?query=workflow%3Aosx)
[![FreeBSD Build Status](https://github.com/yasio/yasio/workflows/freebsd/badge.svg)](https://github.com/yasio/yasio/actions?query=workflow%3Afreebsd)  

[![Release](https://img.shields.io/badge/release-v3.37.1-blue.svg)](https://github.com/yasio/yasio/releases)
[![996.icu](https://img.shields.io/badge/link-996.icu-red.svg)](https://996.icu)
[![LICENSE](https://img.shields.io/badge/license-Anti%20996-blue.svg)](https://github.com/yasio/yasio/blob/master/LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/yasio/yasio.svg?label=Stars)](https://github.com/yasio/yasio)
[![GitHub forks](https://img.shields.io/github/forks/yasio/yasio.svg?label=Fork)](https://github.com/yasio/yasio)
[![Language grade: C/C++](https://img.shields.io/lgtm/grade/cpp/g/yasio/yasio.svg?logo=lgtm&logoWidth=18)](https://lgtm.com/projects/g/yasio/yasio/context:cpp)
[![Total alerts](https://img.shields.io/lgtm/alerts/g/yasio/yasio.svg?logo=lgtm&logoWidth=18)](https://lgtm.com/projects/g/yasio/yasio/alerts/)  
  
[![Supported Platforms](https://img.shields.io/badge/platform-ios%20%7C%20android%20%7C%20osx%20%7C%20windows%20%7C%20linux%20%7C%20freebsd-green.svg?style=flat-square)](https://github.com/yasio/yasio)
  
[![Powered](https://img.shields.io/badge/Powered%20by-C4games%20%7C%20Bytedance-blue.svg)](https://www.bytedance.com/)  
  
**[English](README_EN.md)**
  
**yasio** 是一个轻量级跨平台的异步socket库，专注于客户端和基于各种游戏引擎的游戏客户端网络服务, 支持windows & linux & apple & android & win10-universal。  

## 应用案例
* [放置少女](http://hcsj.c4connect.co.jp/): 用于客户端网络传输。
* [红警OL手游项目](https://hongjing.qq.com/): 用于客户端网络传输，并且随着该项目于2018年10月17日由腾讯游戏发行正式上线后稳定运行于上千万移动设备上。
* [x-studio软件项目](https://x-studio.net/): 用于实现局域网UDP+TCP发现更新机制。

## 集成案例
* Unity
  - [OpenNSM2](https://github.com/yasio/OpenNSM2): Unity 纯C#封装，打开场景`SampleScene`运行即可。
  - [xlua](https://github.com/yasio/xLua): 将yasio集成到xlua, 打开场景`U3DScripting`运行即可。
* Unreal Engine 4
  - [DemoUE4](https://github.com/yasio/DemoUE4): 将yasio集成到Unreal Engine 4。
  - [sluaunreal](https://github.com/yasio/sluaunreal): 集成到Tencent的sluaunreal。
  - [UnLua](https://github.com/yasio/UnLua): 集成到Tencent的UnLua。
* [Engine-x](https://github.com/c4games/engine-x): 作为Engine-x游戏引擎的异步TCP解决方案。

    
## 文档
* [https://yasio.org/](https://yasio.org/)

## 使用g++快速运行tcptest测试程序
```sh
g++ tests/tcp/main.cpp --std=c++11 -DYASIO_HEADER_ONLY -lpthread -I./ -o tcptest && ./tcptest
```

## 使用CMake编译yasio的测试程序和示例程序
```sh
git clone https://github.com/yasio/yasio
cd yasio
git submodule update --init --recursive

# 如果是macOS Xcode, 这里命令应该换成: cmake -B build -GXcode
cmake -B build

# 使用CMake命令行编译, 如果需要调试，则使用相应平台IDE打开即可:
# a. Windows: 使用VisualStudio打开build/yasio.sln
# b. macOS: 使用Xcode打开build/yasio.xcodeproj
cmake --build build --config Debug

# # 者直接用VS打开 
```

## 特性: 
* 支持TCP，UDP，KCP传输，且API是统一的。
* 支持TCP粘包处理，业务完全不必关心。
* 支持组播。
* 支持IPv4/IPv6或者苹果IPv6_only网络。
* 支持处理多个连接的所有网络事件。
* 支持微秒级定时器。
* 支持Lua绑定。
* 支持Cocos2d-x jsb绑定。
* 支持[CocosCreator jsb2.0绑定](https://github.com/yasio/inettester)。
* 支持[Unity3D](https://github.com/yasio/xLua)。
* 支持[虚幻4](https://github.com/yasio/DemoUE4)。
* 支持SSL客户端，基于OpenSSL/MbedTLS。
* 支持非阻塞域名解析，基于c-ares。
* 支持Header Only集成方式，只需要定义编译预处理器宏```YASIO_HEAD_ONLY=1```即可。
* 支持Unix Domain Socket。
* 支持二进制读写，两个工具类**obstream/ibstream**非常方便使用。
* 支持和.net兼容的整数压缩编码方式: **7Bit Encoded Int/Int64**。

## 关于C++17
yasio提供了如下可在C++11编译器下使用的C++17标准库组件, 请查看 [cxx17](https://github.com/yasio/yasio/tree/master/yasio/cxx17)
- cxx17::string_view
- cxx17::shared_mutex
- cxx20::starts_with, cxx20::ends_with

## 发送延迟
yasio比同样使用消息队列的Cocos2d-x WebSocket实现处理发送消息快**30倍**以上:  

|网络实现         | 发送延迟 |
| ------------- |:----------------:|
|yasio	| ```0.06 ~ 0.1(ms)``` |
|Cocos2d-X WebSocket	|```> 3~5(ms)``` |

参考: [Cocos2d-X WebSocket.cpp](https://github.com/cocos2d/cocos2d-x/blob/v4/cocos/network/WebSocket.cpp)

## 框架图
![image](docs/assets/images/framework.png)  

## QQ交流群
点击加入：[829884294](https://jq.qq.com/?_wv=1027&k=5LDEiNv)

