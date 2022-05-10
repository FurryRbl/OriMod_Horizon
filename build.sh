#!/bin/bash
if [ ! -f "./Info.build" ]; then
	echo "无法找到Info.build文件，构建中断！"
	exit 1
fi

source info.build

if [ ! -n $version ]; then
	echo "无法在info.build找到version的配置信息，构建中断！"
	exit 2
fi

if [ ! -n $name ]; then
	echo "无法在info.build找到name的配置信息，构建中断！"
	exit 2
fi

BuildIcMod(){
	echo "开始构建..."
	echo "正在清理上一次构建文件..."

	rm -rf ./build/cache/*
	rm -rf ./build/cache/.*
	rm -rf ./build/release/*

	if [ ! -d "./build" ];then
		echo "无法找到./build文件，正在新建..."
		mkdir ./build
	fi

	if [ ! -d "./build/cache" ];then
		echo "无法找到./build/cache文件，正在新建..."
		mkdir ./build/cache
	fi

	if [ ! -d "./build/release" ];then
		echo "无法找到./build/release文件，正在新建..."
		mkdir ./build/release
	fi

	echo "复制Mod代码..."

	cp -r ./src/* ./build/cache
	cp -r ./src/.* ./build/cache

	if [ -f "./README.md" ];then
		echo "找到README.md文件，正在复制！"
		cp -r ./README.md ./build/cache
	fi

	if [ -f "./LICENSE" ];then
		echo "找到LICENSE文件，正在复制！"
		cp -r ./README.md ./build/cache
	fi

	echo "正在打包..."

	cd ./build/cache
	zip -q -r ./../../build/release/${name}_$version.icmod *

	echo "打包完成！"

	cd ./../../

	echo "构建完成！"
}


clearbuild(){
	if [ -d "./build" ];then
		rm -r ./build
	fi
}

run(){
	rm -rf /sdcard/games/horizon/packs/Inner_Core/innercore/mods/${name}_${version}*
	
	mkdir -p /sdcard/games/horizon/packs/Inner_Core/innercore/mods/${name}_${version}
	
	cp -r ./src/* /sdcard/games/horizon/packs/Inner_Core/innercore/mods/${name}_${version}/
	cp -r ./src/.* /sdcard/games/horizon/packs/Inner_Core/innercore/mods/${name}_${version}/
	
	su -c 'am start -n "com.zheka.horizon/com.zhekasmirnov.horizon.activity.main.StartupWrapperActivity"'
	
}










case $1 in
build)
BuildIcMod
;;
clear)
clearbuild
;;
run)
run
;;
*)
echo "找不到任务：$1"
;;
esac
