# NextCloud 私人云盘部署教程

你是否还在使用微信来分享文件？微信虽然可以传输文件，却无法帮你存储文件，更无法整理你的诸多文件。一个月以前发给某个同事的文件，你要找很久才找到，而且可能会发现“文件已过期”了。

你是否还在为跨设备的文件传输而苦恼？用 U 盘？用数据线？用微信？传输起来非常麻烦，而且数据难以同步，各个设备上的数据不一致。

你是否讨厌那些公共云盘产品的封闭、限速、广告、随时歇业的可能？如果你的数据非常关键，你还要考虑公共云盘产品的数据隐私问题。

你是否想要随时随地、在任何设备访问你的照片和工作资料？无论是在地铁上还是在公司里，无论是用手机还是电脑……

为什么不搭建一套自己的云盘服务呢？只需 10 分钟 + 一台阿里云服务器，你就可以拥有一套属于你自己的云盘！不需要你会写代码，有手就能做！

自己部署的 NextCloud 云盘服务具有以下优点：

- 开放灵活。NextCloud 是一套开源的云盘系统，本身功能非常成熟可靠。而且支持插件定制，应用商店中有很多好用的插件可以使用。
- 便于访问。支持通过 PC 端、移动端、浏览器来使用。跨端同步你的文件，随时随地都能访问你的数据。你还可以将你的文件分享给朋友或同事。
- 高效工作。你可以在线查看 PDF、文档、照片、视频，甚至在线编辑流程图、思维导图！它不仅仅是一个云盘，更是一个高效的个人工作台。
- 自主可控。服务就部署在你自己的服务器上，你甚至可以将它部署在封闭的内网环境中（比如公司内网）。再也不用担心云盘数据安全，也不用担心云盘厂商哪天跑路了。
- 多人协作。支持任意多个用户，每个人拥有独立的云盘空间。多个用户之间可以共享文件夹，并协同编辑文档。适合家庭和小型企业使用。

## 部署步骤

### 购买阿里云 ECS 服务器

在[阿里云](https://ecs.console.aliyun.com/)购买一台 ECS 云服务器。

- 由于本教程是个人云盘场景，因此推荐`实例规格`选择`突发性能实例`系列的。因为云盘场景不需要时刻都满负载计算，仅仅在你使用云盘时需要跑满负载。因此，选择`突发性能实例`系列的性价比更高（相同配置价格更低）。
- 操作系统要选择 Ubuntu 20.04 的。否则本教程中的命令可能不适用。
- 在配置网络和安全组的时候，要勾选开放端口 80 和 443。否则云盘服务无法被访问到。如果你选择的是已有的安全组，确保它开放了端口 80 和 443。

### 登录云服务器

通过[阿里云 ECS 控制台](https://ecs.console.aliyun.com/)，远程连接到云服务器。以下操作皆在云服务器中完成。

### 安装并启用 docker

docker 是一款开源的容器运行工具，提供了一套便捷的服务打包、分发、部署方式。我们将要部署的 NextCloud 以及相关的数据库等服务就是通过 docker 容器来运行的。

依次执行以下命令，通过自动化脚本完成 docker 安装：

```sh
curl -fsSL get.docker.com -o get-docker.sh

sudo sh get-docker.sh --mirror Aliyun
```

依次执行以下命令，启用 docker：

```sh
sudo systemctl enable docker

sudo systemctl start docker
```

> 详情参考[Docker —— 从入门到实践](https://yeasy.gitbook.io/docker_practice/install/ubuntu)

### 安装 docker-compose

docker-compose 是一款基于 docker 的容器编排工具。有了它，我们通过一份配置文件就能启动所有需要的服务。因此我们先来安装它：

```sh
sudo curl -L https://download.fastgit.org/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```

> 详情参考[Docker —— 从入门到实践](https://yeasy.gitbook.io/docker_practice/compose/install)

### 安装 git

我们将使用 git 来拉取模板项目，因此请先安装 git：

```sh
sudo apt install git
```

### 准备 NextCloud 部署配置

将我们提前配置好的部署环境克隆到服务器上：

```sh
git clone https://gitee.com/csr632/nextcloud-example

cd nextcloud-example
```

执行配置修改脚本，它会自动将`docker-compose.yml`中的 IP 占位符`your.domain.name`替换成【你的服务器公网 IP】：

```sh
chmod +x ./prepare.sh

./prepare.sh 你的服务器公网IP
```

> 注意将上面命令的【你的服务器公网 IP】替换成你的云服务器 IP。

然后，就可以启动所有 docker 容器了：

```sh
docker-compose up -d
```

> 初次执行此命令时，会花费一些时间来拉取 docker 镜像。

大功告成！等待大约 5 分钟，所有容器初始化完毕以后，你的私人云盘服务就可以访问了！

## 使用 NextCloud

通过浏览器访问`https://你的ECS服务器公网IP`。就可以访问你的私人云盘服务了！

注意，初次访问时，浏览器会提示“您的连接不是私密连接”。你需要依次点击“高级 - 继续前往（不安全）”。

> 之所以有这个警告，是因为我们部署 NextCloud 服务的时候，使用 IP 地址作为服务主机名，因此只能使用自签名的 https 证书来实现加密通信，而浏览器默认不会信任自签名的证书。
> 目前没有免费的方式得到基于 IP 主机名的权威 https 证书。未来当你有了自己的域名以后，可以申请免费的权威 https 证书，避免初次访问时手动信任证书。

完成上述步骤以后，你就真正看到了你的 NextCloud 服务！初次使用时，它会引导你注册一个管理员账号。然后你就可以尽情探索了！

> 注册管理员账号时，不要勾选“install apps”，原因参考下面的注意事项。你可以登录成功以后再到应用商店下载。
> 初次注册管理账号时，会比较慢，可能会造成网页请求超时。没关系，注册管理账号的过程依然在背后默默进行。刷新页面以后你依然使用刚才注册的管理账号来登录即可。可能需要刷新页面重试几次。

成功进入云盘以后，建议你先将应用语言修改成中文：`右上角 - Settings - Language - 简体中文`。然后就开始尽情探索吧！

### 推荐应用

NextCloud 的其中一个核心亮点是，可以从应用商店安装新的应用到你的 NextCloud 服务中。你可以依次点击`右上角 - 应用`来管理你的应用。

下面推荐几款我正在使用的应用：

- Draw.io 大名鼎鼎的画图神器，各种 UML 图、线框图都可以画！在线画图，点击保存，随处访问！
- Mind Map 专门用来画思维导图的神器。
- Markdown Editor 让你可以直接在线编辑 Markdown 文件。
- Notes 笔记本功能。安装以后顶栏会出现一个笔记按钮，管理笔记更加方便。

还有更多优质应用等待你探索！

### 注意事项

由于 NextCloud 的应用商店服务器在国外，从国内的服务器连接过去经常会超时。因此如果遇到应用安装失败的话需要重试几次。

### 使用客户端

如果希望在手机或平板上使用，可以在 Google Play 或者苹果 App Store 下载 NextCloud 的客户端。
对于国内无法使用 Google Play 的用户，可以直接到[NextCloud 的 Github](https://github.com/nextcloud/android/releases)下载 apk 安装包。

## 参考资料

- [NextCloud 官方示例](https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy/mariadb/apache)。
