# NextCloud 部署教程

只需 10 分钟，在阿里云上部署一套属于你自己的云盘服务！

无须代码基础，有手就能做！

基于[NextCloud 官方示例](https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy/mariadb/apache)。

## 部署步骤

### 购买阿里云 ECS 服务器

在[阿里云](https://ecs.console.aliyun.com/)购买一台 ECS 云服务器。

- 注意操作系统要选择 Ubuntu 20.04 的。否则本教程中的命令可能不适用。
- 由于本教程是个人云盘场景，因此推荐`实例规格`选择`突发性能实例`系列的。因为云盘场景不需要时刻都满负载计算，仅仅在你使用云盘时需要跑满负载。因此，选择`突发性能实例`系列的性价比更高（相同配置价格更低）。

### 登录云服务器

通过[阿里云 ECS 控制台](https://ecs.console.aliyun.com/)，远程连接到云服务器。以下操作皆在云服务器中完成。

### 安装并启用 docker

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

```sh
sudo curl -L https://download.fastgit.org/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```

> 详情参考[Docker —— 从入门到实践](https://yeasy.gitbook.io/docker_practice/compose/install)

### 配置 docker 镜像加速

等一下我们需要通过 docker 拉取镜像。但是由于网络原因，从默认的国外服务器拉取镜像会非常慢。因此我们先配置 docker 使用阿里云的镜像加速器。

用浏览器访问[阿里云容器镜像服务控制台 - 镜像加速器](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)。其中的操作文档提供了可执行的脚本代码，你在云服务器中执行它即可。执行的代码类似于这样：

```sh
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [你的私人镜像加速器地址]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

```

### 安装 git

我们将使用 git 来拉取模板项目，因此请先安装 git：

```sh
sudo apt install git
```

### 准备 NextCloud 部署配置

克隆我们提前配置好的部署环境：

```sh
git clone https://gitee.com/csr632/nextcloud-example

cd nextcloud-example
```

执行配置修改脚本，它会自动将`docker-compose.yml`中的 IP 占位符`your.domain.name`替换成【你的服务器公网 IP】：

```sh
chmod +x ./prepare.sh

./prepare.sh 你的服务器公网IP
```

启动所有 docker 容器：

```sh
docker-compose up -d
```

> 初次执行此命令时，会花费一些时间来拉取 docker 镜像。

完成！等待大约 2 分钟，所有容器初始化完毕以后，你的私人云盘服务就可以访问了！

## 使用 NextCloud

通过浏览器访问`https://你的ECS服务器公网IP`。就可以访问你的私人云盘服务了！

注意，初次访问时，浏览器会提示“您的连接不是私密连接”。你需要依次点击“高级 - 继续前往（不安全）”。

> 之所以有这个警告，是因为我们部署 NextCloud 服务的时候，使用 IP 地址作为服务主机名，因此只能使用自签名的 https 证书来实现加密通信，而浏览器默认不会信任自签名的证书。
> 目前没有免费的方式得到基于 IP 主机名的权威 https 证书。未来当你有了自己的域名以后，可以申请免费的权威 https 证书，避免初次访问时手动信任证书。

完成上述步骤以后，你就真正看到了你的 NextCloud 服务！初次使用时，它会引导你注册一个管理员账号。然后你就可以尽情探索了！

> 注册管理员账号时，不要勾选“install apps”，原因参考下面的注意事项。你可以登录成功以后再到应用商店下载。
> 初次注册管理账号时，会比较慢，可能会造成网页请求超时。没关系，注册管理账号的过程依然在背后默默进行。刷新页面以后你依然使用刚才注册的管理账号来登录即可。可能需要刷新页面重试几次。

建议你先将应用语言修改成中文：`右上角 - Settings - Language - 简体中文`。

### 推荐应用

NextCloud 的其中一个核心亮点是，可以从应用商店安装新的应用到你的 NextCloud 服务中。你可以依次点击`右上角 - 应用`来管理你的应用。

下面推荐几款我正在使用的应用：

- Draw.io 大名鼎鼎的画图神器，各种 UML 图、线框图都可以画！在线画图，点击保存，随处访问！
- Mind Map 专门用来画思维导图的神器。
- Markdown Editor 让你可以直接在线编辑 Markdown 文件。
- Notes 笔记本功能。安装以后顶栏会出现一个笔记按钮，管理笔记更加方便。

还有更多优质应用等你探索！

### 注意事项

但是由于 NextCloud 的应用商店服务器在国外，从国内的 ECS 链接过去经常会超时。因此如果遇到应用安装失败的话需要重试几次。

### 使用客户端

如果希望在手机或平板上使用，可以在 Google Play 或者苹果 App Store 下载 NextCloud 的客户端。
对于国内无法使用 Google Play 的用户，可以直接到[NextCloud 的 Github](https://github.com/nextcloud/android/releases)下载 apk 安装包。
