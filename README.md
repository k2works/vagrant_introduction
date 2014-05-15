Vagrant入門
====================
# 目的
Vagrant公式サイトの[Getting Started](http://docs.vagrantup.com/v2/getting-started/index.html)を超訳する。

# 前提
| ソフトウェア   | バージョン   | 備考        |
|:---------------|:-------------|:------------|
| OS X           |10.8.5        |             |
| vagrant        |1.6.0        |             |

# 構成
+ [セットアップ](#1)
+ [はじめに](#2)
  + [プロジェクトのセットアップ](#2-1)
  + [BOXES](#2-2)
  + [UPとSSH](#2-3)
  + [同期フォルダ](#2-4)
  + [プロビジョニング](#2-5)
  + [ネットワーキング](#2-6)
  + [シェア](#2-7)
  + [片付け](#2-8)
  + [再構築](#2-9)
  + [プロバイダ](#2-10)
+ [Saharaプラグインを使う](#3)
+ [AWS対応](#4)

# 詳細
## <a name="1">セットアップ</a>
インストール
+ [こっち](http://www.vagrantup.com/downloads.html)

アンインストール
+ Windows:コントロールパネルから削除
+ Mac OS X:```/Application/Vagrant```ディレクトリと```/usr/bin/vagrant```ファイルを削除する
+ Linux:```/opt/vagrant```ディレクトリと```/usr/bin/vagrant```ファイルを削除する

## <a name="2">はじめに</a>
Vagrantを使うことのメリットを知りたければ[ここ](http://docs.vagrantup.com/v2/why-vagrant/)を参照。  
はじめにVagrantの[インストール](http://www.vagrantup.com/downloads.html)と[VirtualBox](https://www.virtualbox.org/)のインストールを済ませておく。

#### 実行
```bash
$ vagrant init hashicorp/precise32
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'hashicorp/precise32' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'hashicorp/precise32'
    default: URL: https://vagrantcloud.com/hashicorp/precise32
==> default: Adding box 'hashicorp/precise32' (v1.0.0) for provider: virtualbox
    default: Downloading: https://vagrantcloud.com/hashicorp/precise32/version/1/provider/virtualbox.box
==> default: Successfully added box 'hashicorp/precise32' (v1.0.0) for 'virtualbox'!
==> default: Importing base box 'hashicorp/precise32'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'hashicorp/precise32' is up to date...
==> default: Setting the name of the VM: vagrant_introduction_default_1399426841280_52495
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 => 2222 (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection timeout. Retrying...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => /Users/k2works/projects/github/vagrant_introduction
```
上記のコマンドを実行したらUbuntu 12.04 LTS 32-bitのVirtualBox環境を実行できるようになる。
```vagrant ssh```コマンドでSSHログインできます、そして```vagrant destroy```コマンドで削除できます。

### <a name="2-1">プロジェクトのセットアップ</a>
プロジェクトセットアップの最初のステップは[Vagrantfile](http://docs.vagrantup.com/v2/vagrantfile/)を使って設定する。Vagrantfileの目的は以下の２点。

1. プロジェクトのルートディレクトリをマークする。Vagrantの設定のほとんどはこのルートディレクトリに関連している。
1. どのソフトウエアをインストールするかどのようにアクセスするかを含めて、マシンの種類と実行するリソースを明記する。

```bash
$ mkdir vagrant_getting_started
$ cd vagrant_getting_started
$ vagrant init
```
上記の操作でカレントディレクトリに```Vagrantfile```を配置できる。また```vagrant init```コマンドは既に存在すうるディレクトリでも実行できる。

### <a name="2-2">BOXES</a>
Vagrantのベースイメージとなるのが_boxes_

#### BOXインストール
はじめにの実行を済ましているのであれば以下は実行する必要はありませんBOXを使うへ進んでください。

```bash
$ vagrant box add hashicorp/precise32
```
上記の操作で"hashicorp/precise32"という名前のboxを[Vagrant Cloud](https://vagrantcloud.com/)からダウンロードします。
追加したboxは複数のプロジェクトで再利用できます。

#### BOXを使う
追加したboxを使うには```Vagrantfile```を以下のように編集します。
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise32"
end
```

#### BOXを探す
[ここ](https://vagrantcloud.com/)で探す。

### <a name="2-3">UPとSSH</a>
以下のコマンドを実行することでUbuntu実行環境のマシンが起動します。
```bash
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'hashicorp/precise32'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'hashicorp/precise32' is up to date...
==> default: Setting the name of the VM: vagrant_getting_started_default_1399429293801_36944
==> default: Fixed port collision for 22 => 2222. Now on port 2200.
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 => 2200 (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2200
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection timeout. Retrying...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => /Users/k2works/projects/github/vagrant_introduction/vagrant_getting_started
```
起動完了後以下のコマンドでsshログインできます。
```bash
$ vagrant ssh
Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic-pae i686)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Fri Sep 14 06:22:31 2012 from 10.0.2.2
```
構築した仮想マシンを削除したい場合はログアウト後に```vagrant destroy```を実行する。

### <a name="2-4">同期フォルダ</a>
デフォルでVagrantはプロジェクトディレクトリを```/vagrant```ディレクトリと同期させています。
```bash
$ vagrant ssh
Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic-pae i686)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Wed May  7 02:49:45 2014 from 10.0.2.2
vagrant@precise32:~$ ls /vagrant/
Vagrantfile
vagrant@precise32:~$ touch /vagrant/foo
vagrant@precise32:~$ exit
logout
Connection to 127.0.0.1 closed.
bash-3.2$ ls
Vagrantfile     foo
```
上記の操作で```/vagrant/foo```がローカルプロジェクトと動機されていることが確認できます。

### <a name="2-5">プロビジョニング</a>
Vagrantは_自動プロビジョニング_をサポートしています。この機能を使うことで```vagrant up```実行時にソフトウエアを自動的にインストールして繰り返し利用可能な状態にしてくれます。

#### Apacheインストール
以下のシェルスクリプトをVagrantfileと同じディレクトリに```bootstrap.sh```で保存する。
公式サイトのガイドだとネームサーバエラーが出るので```echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null```を最初に追加する。
```bash
#!/usr/bin/env bash
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
apt-get update
apt-get install -y apache2
rm -rf /var/www
ln -fs /vagrant /var/www
```
次にVagrantfileを以下のように編集する。
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise32"
  config.vm.provision :shell, :path => "bootstrap.sh"
end
```

ネームサーバーエラーはバーチャルマシンのバグなので以下の方法で修正するように変更

_Vagrantfile_に以下を追加
```ruby
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
```

再実行
```bash
$ vagrant destroy
$ vagrant up
```

"provision"の行を新しく追加してVagrantに```shell```プロビジュナーを使って```bootstrap.sh```ファイルの内容でマシンをセットアップするようにします。
ファイルパスはプロジェクトルートの場所（Vagrantfileが設定されている場所）と関連付けれられています。

#### プロビジョン！
全ての設定が終わった後に```vagrant up```を実行するだけでVagrantは自動的にプロビジョンしてくれます。
すでに```vagrant up```を実行中ならば```vagrant reload --provision```を実行すれば初期セットアップを飛ばしてバーチャルマシンを再起動します。
それでもうまく行かなければ```vagrant provision```を実行する。

仮想マシンのwebサーバーは起動しましたが、まだブラウザから確認することはできませんプロビジョニング環境内だけ有効になっています。

### <a name="2-6">ネットワーキング</a>

#### ポートフォワーディング
Vagrantfileを編集する
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise32"
  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.network :forwarded_port, host: 4567, guest: 80
end
```
```vagrant reload```または```vagrant up```を実行する。
ブラウザから```http://127.0.0.1:4567```にアクセスして確認する。

#### その他のネットワーキング
静的なIPアドレスの設定もできます。詳細は[こっち](http://docs.vagrantup.com/v2/networking/)

### <a name="2-7">シェア</a>
Vagrantでは[Vagrant Share](http://docs.vagrantup.com/v2/share/)という構築した環境を簡単に共有できる仕組みを用意しています。

#### Vagrant Cloudにログイン
はじめに[Vagrant Cloud](https://vagrantcloud.com/)にアカウントを作成する（無料）。  
アカウントを作成したら```vagrant login```でログインする。
```bash
$ vagrant login
In a moment we'll ask for your username and password to Vagrant Cloud.
After authenticating, we will store an access token locally. Your
login details will be transmitted over a secure connection, and are
never stored on disk locally.

If you don't have a Vagrant Cloud account, sign up at vagrantcloud.com

Username or Email: k2works
Password (will be hidden):
You're now logged in!
```

#### シェア
ログインできたら```vagrant share```を実行する。
```bash
$ vagrant share
==> default: Detecting network information for machine...
    default: Local machine address: 127.0.0.1
    default:
    default: Note: With the local address (127.0.0.1), Vagrant Share can only
    default: share any ports you have forwarded. Assign an IP or addres to your
    default: machine to expose all TCP ports. Consult the documentation
    default: for your provider ('virtualbox') for more information.
    default:
    default: Local HTTP port: 4567
    default: Local HTTPS port: disabled
    default: Port: 2200
    default: Port: 4567
==> default: Checking authentication and authorization...
==> default: Creating Vagrant Share session...
    default: Share will be at: hot-duckbill-4965
==> default: Your Vagrant Share is running! Name: hot-duckbill-4965
==> default: URL: http://hot-duckbill-4965.vagrantshare.com
==> default:
==> default: You're sharing your Vagrant machine in "restricted" mode. This
==> default: means that only the ports listed above will be accessible by
==> default: other users (either via the web URL or using `vagrant connect`).
```
表示されているURLにアクセスするとこれまでに構築した環境がシェアされていることが確認できます。
シェアを実行しているターミナルで```Ctrl-C```を押せば終了します。

Vagrantシェアは単純なHTTPシェアよりもとパワフルです。詳細は[こっち](http://docs.vagrantup.com/v2/share/)。

### <a name="2-8">片付け</a>
Vagrantには_suspend,haltそしてdestroy_の終了オプションが有ります。それぞれに長所と短所がありますので自分にとってベストな選択をしてください。

+ Suspending:```vagrant suspend```の長所は早いことです。短所は終了後も仮想マシンのディスク領域とRAM領域を保持し続けることです。
+ Halting:```vagrant halt```の長所は仮想マシン内のファイルを保持してくれることです。短所は起動に時間がかかることとディスク領域を保持しし続けることです。
+ Destroying:```vagrant destroy```の長所は痕跡を残さないことです。短所は再起動時の仮想マシン再インポートや再プロビジョンに時間がかかることです。

### <a name="2-9">再構築</a>
作業を翌日、翌週あるいは翌年に再開するとしても以下のコマンドを実行するだけです。
```bash
$ vagrant up
```

### <a name="2-10">プロバイダ</a>
はじめにではVirtualBoxを背景に解説してきました。しかし、Vagrantは[VMware](http://docs.vagrantup.com/v2/vmware/)や[AWS](https://github.com/mitchellh/vagrant-aws)などさまざまなバックエンドプロバイダを使うことができます。  
プロバイダをインストールすればVagrantfileを編集する必要はありません、ただ```vagrant up```をプロバイダオプションを付けて実行するだけです。
```bash
$ vagrant up --provider=vmware_fusion
```
クラウドに移行したい？ならばAWS
```bash
$ vagrant up --provider=aws
```
一度```vagrant up```をプロバイダオプション付きで実行したらそのほかのVagrantコマンドでは明示する必要はありません。
そんなわけでSSHの準備が完了または不要になったら```vagrant destroy```のように普通にコマンドを実行すればオッケーです。

もっと詳しく知りたければ[こっち](http://docs.vagrantup.com/v2/providers/)

## <a name="3">Saharaプラグインを使う</a>

### プラグインのインストール
```bash
$ vagrant plugin install sahara
```

### saharaプラグインを使う
```bash
$ vagrant up
$ vagrant sandbox on
$ vagrant sandbox rollback
$ vagrant sandbox commit
$ vagrant sandbox off
```

## <a name="4">AWS対応</a>

### インストール
```bash
$ vagrant plugin install vagrant-aws
```
### 環境変数の設定
```bash
export AWS_ACCESS_KEY_ID=xxxxxxxxx AWSアクセスキー
export AWS_SECRET_ACCESS_KEY=xxxxxxxx AWSシークレットアクセスキー
export AWS_KEYPAIR_NAME=xxx AWSキーペア名
export AWS_PRIVATE_KEY_PATH=./aws/xxx.pem AWS秘密鍵保存場所
```

### EC2-Classic環境で、vagrant-awsを利用する
```bash
$ mkdir vagrant_aws_classic
$ cd vagrant_aws_classic/
$ vagrant init
```
_Vagrantfile_
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #--- 以下を指定 --
  box_name = "dummy"
  box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
  ssh_username = "ec2-user"
  security_groups = ["web"]
  region = "ap-northeast-1"
  availability_zone = "ap-northeast-1a"
  ami = "ami-b1fe9bb0"
  instance_type = "m1.medium"
  #--- ここまで --

  config.vm.box = box_name
  config.vm.box_url = box_url

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
    override.ssh.username = ssh_username
    override.ssh.private_key_path = ENV['AWS_PRIVATE_KEY_PATH']

    #---- EC2-Classic固有の設定 ----#
    # リージョンを設定
    aws.region = region
    # AZを設定
    aws.availability_zone = availability_zone
    # セキュリティグループを設定
    aws.security_groups = security_groups
    #---- EC2-Classic固有の設定ここまで ----#

    # User-data
    aws.user_data = "#!/bin/sh\nsed -i 's/^.*requiretty/#Defaults requiretty/' /etc/sudoers\n"
    # タグを指定(任意)
    aws.tags = aws.tags = { "Name" => "test-classic-default-minimal", "env" => "dev"}
    # AMIを指定。起動したいリージョンにあるAMI
    aws.ami = ami
    # インスタンスタイプを設定
    aws.instance_type = instance_type
  end
end

```

```bash
$ vagrant up --provider=aws
Bringing machine 'default' up with 'aws' provider...
[fog][WARNING] Unable to load the 'unf' gem. Your AWS strings may not be properly encoded.
==> default: HandleBoxUrl middleware is deprecated. Use HandleBox instead.
==> default: This is a bug with the provider. Please contact the creator
==> default: of the provider you use to fix this.
==> default: Warning! The AWS provider doesn't support any of the Vagrant
==> default: high-level network configurations (`config.vm.network`). They
==> default: will be silently ignored.
==> default: Launching an instance with the following settings...
==> default:  -- Type: m1.medium
==> default:  -- AMI: ami-b1fe9bb0
==> default:  -- Region: ap-northeast-1
==> default:  -- Availability Zone: ap-northeast-1a
==> default:  -- Keypair: k2works
==> default:  -- User Data: yes
==> default:  -- Security Groups: ["web"]
==> default:  -- User Data: #!/bin/sh
==> default: sed -i 's/^.*requiretty/#Defaults requiretty/' /etc/sudoers
==> default:  -- Block Device Mapping: []
==> default:  -- Terminate On Shutdown: false
==> default:  -- Monitoring: false
==> default:  -- EBS optimized: false
==> default: Waiting for instance to become "ready"...
==> default: Waiting for SSH to become available...
==> default: Machine is booted and ready for use!
==> default: Rsyncing folder: /Users/k2works/projects/github/vagrant_introduction/vagrant_aws_classic/ => /vagrant
```
インスタンスにログインする
```bash
$ vagrant ssh
[fog][WARNING] Unable to load the 'unf' gem. Your AWS strings may not be properly encoded.

       __|  __|_  )
       _|  (     /   Amazon Linux AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-ami/2013.09-release-notes/
20 package(s) needed for security, out of 146 available
Run "sudo yum update" to apply all updates.
Amazon Linux version 2014.03 is available.
```

インスタンスを削除する
```bash
$ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
[fog][WARNING] Unable to load the 'unf' gem. Your AWS strings may not be properly encoded.
==> default: Terminating the instance...
```

うまく動かないとき
```bash
$ export VAGRANT_LOG=debug
$ vagrant up --provider=aws
```

### VPC環境で、vagrant-awsを利用する
```bash
$ mkdir vagrant_aws_vpc
$ cd vagrant_aws_vpc/
$ vagrant init
```
_Vagrantfile_
```ruby
```


# 参考
+ [VAGRANT](http://www.vagrantup.com/)
+ [GETTING STARTED](http://docs.vagrantup.com/v2/getting-started/index.html)
+ [apt-get update fails to fetch files, “Temporary failure resolving …” error](http://askubuntu.com/questions/91543/apt-get-update-fails-to-fetch-files-temporary-failure-resolving-error)
+ [[Vagrant]saharaプラグインで仮想OS状態を管理する](http://dev.classmethod.jp/tool/vagrant-sahar/)
+ [Vagrant / virtualbox DNS 10.0.2.3 not working](http://serverfault.com/questions/453185/vagrant-virtualbox-dns-10-0-2-3-not-working)
+ [mitchellh/vagrant-aws](https://github.com/mitchellh/vagrant-aws)
+ [vagrant-awsの環境別オプション指定方法](http://www.ryuzee.com/contents/blog/6807)
