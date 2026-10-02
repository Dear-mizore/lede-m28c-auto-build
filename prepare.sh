#!/bin/bash -x
id
df -h
free -h
cat /proc/cpuinfo
if [ -d "lede" ]; then
    echo "repo dir exists"
    cd lede
    git pull || { echo "lede git pull failed"; exit 1; }
else
    echo "repo dir not exists"
    git clone --depth=1 https://github.com/coolsnowwolf/lede.git || {
        echo "lede clone failed, use ghproxy"
        git clone --depth=1 https://mirror.ghproxy.com/https://github.com/coolsnowwolf/lede.git
    }
    cd lede
fi
#cat ../m28c.config > .config
cat feeds.conf.default > feeds.conf
echo "" >> feeds.conf
echo "src-git qmodem https://github.com/FUjr/QModem.git;main" >> feeds.conf
rm -rf files
cp -r ../files .
if [ -d "package/zz/luci-theme-alpha" ]; then
    cd package/zz/luci-theme-alpha
    git pull || { echo "luci-theme-alpha git pull failed"; exit 1; }
    cd ../../..
else
    git clone --depth=1 https://github.com/derisamedia/luci-theme-alpha.git package/zz/luci-theme-alpha || {
        echo "theme clone failed, use ghproxy"
        git clone --depth=1 https://mirror.ghproxy.com/https://github.com/derisamedia/luci-theme-alpha.git package/zz/luci-theme-alpha
    }
fi

# 添加OpenAppFilter
if [ -d "package/OpenAppFilter" ]; then
    cd package/OpenAppFilter
    git pull || { echo "OAF git pull failed"; exit 0; }
    cd ../../
else
    git clone --depth=1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter || {
        echo "OAF clone failed, use ghproxy mirror"
        git clone --depth=1 https://mirror.ghproxy.com/https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
    }
fi

# 更新feeds
./scripts/feeds update -a
./scripts/feeds install -a
