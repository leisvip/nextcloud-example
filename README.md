# NextCloud 部署教程

基于[nextcloud官方示例](https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy/mariadb/apache)

## 部署步骤

### 登录云服务器

在阿里云购买了一台ECS服务器以后，通过控制台登录云服务器。以下操作皆在云服务器中完成。

### 安装并启用docker

依次执行以下命令，通过自动化脚本完成docker安装：

```sh
curl -fsSL get.docker.com -o get-docker.sh

sudo sh get-docker.sh --mirror Aliyun
```

依次执行以下命令，启用docker：

```sh
sudo systemctl enable docker

sudo systemctl start docker
```

> 详情参考[Docker —— 从入门到实践](https://yeasy.gitbook.io/docker_practice/install/ubuntu)

### 安装docker-compose

```sh
sudo curl -L https://download.fastgit.org/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
```

> 详情参考[Docker —— 从入门到实践](https://yeasy.gitbook.io/docker_practice/compose/install)

### 准备NextCloud部署配置

克隆我们提前配置好的部署环境：
```sh
git clone https://gitee.com/csr632/nextcloud-example

cd nextcloud-example
```

执行配置修改脚本，它会自动将`docker-compose.yml`中的IP占位符`your.domain.name`替换成【你的服务器公网IP】：
```sh
chmod +x ./prepare.sh

./prepare.sh 你的服务器公网IP
```

启动所有docker容器：
```sh
docker-compose up -d
```
> 初次执行此命令时，会花费一些时间来拉取docker镜像。

完成！等待大约2分钟，所有容器初始化完毕以后，你的私人云服务就可以访问了！

## 使用NextCloud

通过浏览器访问`https://你的ECS服务器公网IP`。就可以访问你的私人云服务了！

注意，初次访问时，浏览器会提示“您的连接不是私密连接”。你需要依次点击“高级 - 继续前往（不安全）”。

> 之所以有这个警告，是因为我们部署NextCloud服务的时候，使用IP地址作为服务主机名，因此只能使用自签名的https证书来实现加密通信，而浏览器默认不会信任自签名的证书。
> 目前没有免费的方式得到基于IP主机名的权威https证书。未来当你有了自己的域名以后，可以申请免费的权威https证书，避免初次访问时手动信任证书。

完成上述步骤以后，你就真正看到了你的NextCloud服务！初次使用时，它会引导你注册一个管理员账号。然后你就可以尽情探索了！
> 注册管理员账号时，不要勾选“install apps”，原因参考下面的注意事项。你可以登录成功以后再到应用商店下载。

建议你先将应用语言修改成中文：`右上角 - Settings - Language - 简体中文`。

### 推荐应用

NextCloud的其中一个核心亮点是，可以从应用商店安装新的应用到你的NextCloud服务中。你可以依次点击`右上角 - 应用`来管理你的应用。

- Draw.io 大名鼎鼎的画图神器，各种UML图、线框图都可以画！在线画图，点击保存，随处访问！
- Markdown Editor 可以直接在线编辑Markdown文件。
- Mind Map 专门用来画思维导图的神器。
- Notes 笔记本功能。安装以后顶栏会出现一个笔记按钮。

还有更多优质应用等你探索！

### 注意事项

但是由于NextCloud的应用商店服务器在国外，从国内的ECS链接过去经常会超时。因此如果遇到应用安装失败的话需要重试几次。

