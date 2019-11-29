#!/bin/env python
#-*- encoding=utf8 -*-

import os,sys

# lua_proj_dir ="C:/Users/Justin/Documents/u3dWorkspace/zhj_client/Assets/LuaScripts"
lua_proj_dir = "/Users/lanjing_mac_mini/Documents/Projects/zhj_client/Assets/LuaScripts"

filter=[".lua"] #设置过滤后的文件类型 当然可以设置多个类型

def all_path(dirname):

	result = []#所有的文件

	for maindir, subdir, file_name_list in os.walk(dirname):

		# print("1:",maindir) #当前主目录
		# print("2:",subdir) #当前主目录下的所有目录
		# print("3:",file_name_list)  #当前主目录下的所有文件

		for filename in file_name_list:
			apath = os.path.join(maindir, filename)#合并成一个完整路径
			ext = os.path.splitext(apath)[1]  # 获取文件后缀 [0]获取的是除了文件名以外的内容

			if ext in filter:
				result.append(apath)

	return result


all_luas = all_path(lua_proj_dir)


for src_lua in all_luas:
	out_lua = src_lua.replace("LuaScripts","LuaScriptsEncode")

	(outputh, filename) = os.path.split(out_lua)

	if not(os.path.isdir(outputh)):
		os.makedirs(outputh)

	print "luac -s -o " + out_lua + " " + src_lua
	os.system("luac -s -o " + out_lua + " " + src_lua)
