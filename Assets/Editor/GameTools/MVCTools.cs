using UnityEngine;
using System.Collections;
using UnityEditor;
using System;
using System.IO;
using System.Collections.Generic;

public class MVCTools : EditorWindow
{
    [MenuItem("Tools/MVC Tools #q")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(MVCTools));
    }

    public static string author = "passion";
    public static string newUIStr = "UIName";
    public static string newFileStr = "FileName";
    public static string newWarpItemStr = "UIXXXWarpItem";
    static bool isCrtl = true;
    static bool isModel = true;
    static bool isView = true;
    static UILayers_TYPE mLayerType;
    public void OnGUI()
    {
        GUILayout.Label("创建新的UILuaData，并同时创建脚本文件夹和脚本");
        GUILayout.Space(5);
        GUILayout.Label("作者");
        author = GUILayout.TextArea(author, 100);

        GUILayout.Space(5);
        GUILayout.Label("UI名字  命名格式:UIXXX");
        newUIStr = GUILayout.TextArea(newUIStr, 100);
        GUILayout.Label("文件夹名名字");
        newFileStr = GUILayout.TextArea(newFileStr, 100);
        GUILayout.Space(10);
        isCrtl = GUILayout.Toggle(isCrtl, "IsController 是否需要创建Controller");
        GUILayout.Space(10);
        isModel = GUILayout.Toggle(isModel, "isModel 是否需要创建Moel");
        GUILayout.Space(10);
        isView = GUILayout.Toggle(isView, "isView 是否需要创建View");
        GUILayout.Space(5);
        GUILayout.Label("选择UILayers");
        mLayerType = (UILayers_TYPE)EditorGUILayout.EnumPopup(mLayerType);
        GUILayout.Space(5);
        GUILayout.Label("只写入Config数据");
        if (GUILayout.Button("OnlyWriteData"))
        {
            CreatWriteConfig();
            CreaWriteWindowsName();
        }
        GUILayout.Space(50);
        if (GUILayout.Button("CreatUILuaData"))
        {
            if (newUIStr == "UIName")
            {
                Debug.LogError("UIName is deafult");
                return;
            }
            if (newFileStr == "FileName")
            {
                Debug.LogError("FileName is deafult");
                return;
            }
            CreatUIScript();
            if (isModel)
            {
                CreatModellLua();
            }
            if (isView)
            {
                CreatViewlLua();
            }
            if (isCrtl)
            {
                CreatCrtlLua();
            }
            CreatUIConfiglLua();
            CreatWriteConfig();
            CreaWriteWindowsName();
            AssetDatabase.SaveAssets();

            EditorUtility.DisplayDialog("MVC Tool", newUIStr + "页面生成成功!!!", "确定");
        }
        //GUILayout.Space(5);
        //GUILayout.Label("创建WarpItem");
        //GUILayout.Space(5);
        //GUILayout.Label("WarpItem名字  命名格式:UIXXXWarpItem");
        //newWarpItemStr = GUILayout.TextArea(newWarpItemStr, 100);
        //GUILayout.Label("请先填写fileName 作为生成目录");
        //if (GUILayout.Button("CreatWarpItem"))
        //{
        //    CreatWrapItem();
        //    AssetDatabase.SaveAssets();
        //}
    }

    #region  创建WrapItem
    private static void CreatWrapItem()
    {

        if (newFileStr == "FileName")
        {
            Debug.LogError("FileName is deafult");
            return;
        }
        if (newWarpItemStr == "UIXXXWarpItem")
        {
            Debug.LogError("UIXXXWarpItem is deafult");
            return;
        }
        if (!Directory.Exists(DirectoryName + Path.DirectorySeparatorChar + newFileStr + Path.DirectorySeparatorChar + ComponentName))
        {
            Directory.CreateDirectory(DirectoryName + Path.DirectorySeparatorChar + newFileStr + Path.DirectorySeparatorChar + ComponentName);
        }
        string luaData = "";
        luaData = "--[[\r\n-- added by "+ author +" @" + System.DateTime.Now + "\r\n-- +" + newFileStr + "模块" + newFileStr + "View窗口中服务器列表的可复用Item\r\n--]]\r\n"
                    + "local " + newWarpItemStr + " = BaseClass(" + "\"" + newWarpItemStr + "\", UIWrapComponent)" + "\r\n"
                    + "local base = UIWrapComponent\r\n"
                    + "-- 创建\r\n"
                    + "local function OnCreate(self)\r\n\t"
                    + "base.OnCreate(self)\r\n\t"
                    + "-- 组件初始化\r\n"
                    + "end\r\n"
                    + newWarpItemStr + ".OnCreate = OnCreate\r\n"
                    + "return " + newWarpItemStr;
        string path = DirectoryName + newFileStr + Path.DirectorySeparatorChar + ComponentName + Path.DirectorySeparatorChar + newWarpItemStr + ".lua";
        CreatUIScript(path, luaData);
    }
    #endregion
    public enum UILayers_TYPE
    {
        SceneLayer,//用于场景UI
        BackgroudLayer,//背景UI
        NormalLayer,//普通一级、二级、三级UI
        InfoLayer,//信息UI
        TipLayer,//提示UI
        TopLayer,//顶层UI
    }
    #region 创建Crtl
    private static void CreatCrtlLua()
    {
        string luaData = "";
        luaData = "--[[\r\n-- added by "+author+" @" + System.DateTime.Now + "\r\n"
            +"-- +" + newUIStr + "控制层\r\n--]]\r\n"
            + "local " + newUIStr + "Ctrl = BaseClass(" + "\"" + newUIStr + "Ctrl\", UIBaseCtrl)" + "\r\n"
            + "return " + newUIStr + "Ctrl";
        
        Debug.Log(luaData);
        string path = DirectoryName + newFileStr + Path.DirectorySeparatorChar + ControllerName + Path.DirectorySeparatorChar + newUIStr + "Ctrl.lua";
        CreatUIScript(path, luaData);
    }
    #endregion
    #region 创建Model
    private static void CreatModellLua()
    {
        string luaData = "";
        luaData = "--[[\r\n"
        + "-- added by "+author+" @ " + System.DateTime.Now + "\r\n"
        + "-- " + newUIStr + "UIMain模型层" + "\r\n"
        + "-- 注意：" + "\r\n"
        + "-- 1、成员变量预先在OnCreate、OnEnable函数声明，提高代码可读性" + "\r\n"
        + "-- 2、OnCreate内放窗口生命周期内保持的成员变量，窗口销毁时才会清理" + "\r\n"
        + "-- 3、OnEnable内放窗口打开时才需要的成员变量，窗口关闭后及时清理" + "\r\n"
        + "-- 4、OnEnable函数每次在窗口打开时调用，可传递参数用来初始化Model" + "\r\n"
        + "--]]" + "\r\n"
        + "local " + newUIStr + "Model = BaseClass(\"" + newUIStr + "Model\", UIBaseModel)" + "\r\n\r\n\r\n"
        + "local base = UIBaseModel"
        + "-- 创建" + "\r\n"
        + "local function OnCreate(self)" + "\r\n\t"
        + "base.OnCreate(self)" + "\r\n\t"
        + "-- 窗口生命周期内保持的成员变量放这" + "\r\n"
        + "end" + "\r\n"
        + "-- 打开" + "\r\n"
        + "local function OnEnable(self)" + "\r\n\t"
        + "base.OnEnable(self)" + "\r\n\t"
        + "-- 窗口关闭时可以清理的成员变量放这" + "\r\n"
        + "end" + "\r\n"
        + "-- 关闭" + "\r\n"
        + "local function OnDestroy(self)" + "\r\n\t"
        + "base.OnDestroy(self)" + "\r\n\t"
        + "-- 清理成员变量" + "\r\n"
        + "end" + "\r\n\r\n\r\n"

        + newUIStr + "Model.OnCreate = OnCreate" + "\r\n"
        + newUIStr + "Model.OnEnable = OnEnable" + "\r\n"
        + newUIStr + "Model.OnDisable = OnDisable" + "\r\n"
        + newUIStr + "Model.OnDestroy = OnDestroy" + "\r\n\r\n"
        + "return " + newUIStr + "Model" + "\r\n";

        Debug.Log(luaData);
        string path = DirectoryName + newFileStr + Path.DirectorySeparatorChar + ModelName + Path.DirectorySeparatorChar + newUIStr + "Model.lua";
        CreatUIScript(path, luaData);

    }
    #endregion
    #region 创建View
    private static void CreatViewlLua()
    {
        string luaData = "";
        luaData = "--[[\r\n"
        + "-- added by " + author +" @ " + System.DateTime.Now + "\r\n"
        + "-- " + newUIStr + "视图层" + "\r\n"
        + "-- 注意：" + "\r\n"
        + "-- 1、成员变量最好预先在__init函数声明，提高代码可读性" + "\r\n"
        + "-- 2、OnEnable函数每次在窗口打开时调用，直接刷新" + "\r\n"
        + "-- 3、组件命名参考代码规范" + "\r\n"
        + "--]]" + "\r\n"
        + "local " + newUIStr + "View = BaseClass(\"" + newUIStr + "View\", UIBaseView)" + "\r\n"
        + "local base = UIBaseView" + "\r\n"
        + "local function OnCreate(self)" + "\r\n\t"
        + "base.OnCreate(self)" + "\r\n\t"
        + "-- 窗口生命周期内保持的成员变量放这" + "\r\n"
        + "end" + "\r\n"
        + "-- 打开" + "\r\n"
        + "local function OnEnable(self)" + "\r\n\t"
        + "base.OnEnable(self)" + "\r\n\t"
        + "-- 窗口关闭时可以清理的成员变量放这" + "\r\n"
        + "end" + "\r\n"
        + "-- 关闭" + "\r\n"
        + "local function OnDestroy(self)" + "\r\n\t"
        + "base.OnDestroy(self)" + "\r\n\t"
        + "-- 清理成员变量" + "\r\n"
        + "end" + "\r\n\r\n\r\n"

        + newUIStr + "View.OnCreate = OnCreate" + "\r\n"
        + newUIStr + "View.OnEnable = OnEnable" + "\r\n"
        + newUIStr + "View.OnDestroy = OnDestroy" + "\r\n\r\n"
        + "return " + newUIStr + "View" + "\r\n\r\n\r\n";
        Debug.Log(luaData);
        string path = DirectoryName + newFileStr + Path.DirectorySeparatorChar + ViewName + Path.DirectorySeparatorChar + newUIStr + "View.lua";
        CreatUIScript(path, luaData);
    }
    #endregion

    #region 创建UIConfig
    private static void CreatUIConfiglLua()
    {
        string luaData = "";
        string model = (isModel) ? ("Model = require " + "\"UI." + newUIStr + ".Model." + newUIStr + "Model\",") : (" Model =nil,");
        string view = (isView) ? ("View = require " + "\"UI." + newUIStr + ".View." + newUIStr + "View\",") : (" View =nil,");
        string crtl = (isCrtl) ? ("Ctrl =  require " + "\"UI." + newUIStr + ".Controller." + newUIStr + "Ctrl\",") : (" Ctrl =nil,");
        luaData = "--[[\r\n"
        + "-- added by " + author + " @ " + System.DateTime.Now + "\r\n"
        + "-- " + newUIStr + "模块窗口配置，要使用还需要导出到UI.Config.UIConfig.lua" + "\r\n"
        + "--]]" + "\r\n"
        + "-- 窗口配置" + "\r\n"
        + "local " + newUIStr + "= {" + "\r\n\t"
        + "Name = UIWindowNames." + newUIStr + "," + "\r\n\t"
        + "Layer = UILayers." + mLayerType.ToString() + "," + "\r\n\t"
        + model + "\r\n\t"
        + crtl + "\r\n\t"
        + view + "\r\n\t"
        + "PrefabPath = " + "\"UI/Prefabs/View/" + newUIStr + ".prefab\"," + "\r\n"
        + "}" + "\r\n\r\n\r\n"
        + "return {" + "\r\n\t"
        + newUIStr + "=" + newUIStr + ",\r\n"
        + "}" + "\r\n";
        Debug.Log(luaData);
        string path = DirectoryName + newFileStr + Path.DirectorySeparatorChar + newUIStr + "Config.lua";
        CreatUIScript(path, luaData);

    }
    #endregion

    public const string appendText = "--AppendCode";
    #region 写入Config
    public static string GetConfigPath = "Assets" + Path.DirectorySeparatorChar + "LuaScripts" + Path.DirectorySeparatorChar + "UI" + Path.DirectorySeparatorChar + "Config" + Path.DirectorySeparatorChar
                                           + "UIConfig.lua";
    private static void CreatWriteConfig()
    {
        if (File.Exists(GetConfigPath))
        {
            string str = ReadUITemp(GetConfigPath);
            if (str.Contains(newUIStr))
            {
                Debug.LogError(newUIStr + " is had");
                return;
            }
            string CodeContent = newUIStr + "=require " + "\"UI." + newUIStr + "." + newUIStr + "Config\"," + "\r\n\t"
                   + "--AppendCode";
            if (str.Contains(appendText))
            {
                str = str.Replace(appendText, CodeContent);
            }

            FileStream fs = File.Create(GetConfigPath);
            StreamWriter sw = new StreamWriter(fs);
            //开始写入
            sw.Write(str);
            //清空缓冲区
            sw.Flush();
            //关闭流
            sw.Close();
            fs.Close();
        }
    }

    #endregion
    #region 添加WindowsName
    public static string GetUIWindowsPath = "Assets" + Path.DirectorySeparatorChar + "LuaScripts" + Path.DirectorySeparatorChar + "UI" + Path.DirectorySeparatorChar + "Config" + Path.DirectorySeparatorChar
                                            + "UIWindowNames.lua";
    private static void CreaWriteWindowsName()
    {
        if (File.Exists(GetUIWindowsPath))
        {
            string str = ReadUITemp(GetUIWindowsPath);
            if (str.Contains(newUIStr))
            {
                Debug.LogError(newUIStr + " is had");
                return;
            }
            string CodeContent = "--" + newUIStr + "\r\n\t"
                   + newUIStr + " = " + "\"" + newUIStr + "\"," + "\r\n\t"
                   + "--AppendCode";
            if (str.Contains(appendText))
            {
                str = str.Replace(appendText, CodeContent);
            }

            FileStream fs = File.Create(GetUIWindowsPath);
            StreamWriter sw = new StreamWriter(fs);
            //开始写入
            sw.Write(str);
            //清空缓冲区
            sw.Flush();
            //关闭流
            sw.Close();
            fs.Close();
        }
    }

    #endregion
    #region CreatNewUI

    static string DirectoryName = "Assets" + Path.DirectorySeparatorChar + "LuaScripts" + Path.DirectorySeparatorChar + "UI" + Path.DirectorySeparatorChar;
    static string ModelName = "Model";
    static string ViewName = "View";
    static string ControllerName = "Controller";
    static string ComponentName = "Component";
    private static void CreatUIScript()
    {
        string filePath = DirectoryName + Path.DirectorySeparatorChar + newFileStr;
        if (!Directory.Exists(filePath))
        {
            Directory.CreateDirectory(filePath);
        }
        if (isModel)
        {
            if (!Directory.Exists(filePath + Path.DirectorySeparatorChar + ModelName))
            {
                Directory.CreateDirectory(filePath + Path.DirectorySeparatorChar + ModelName);
            }
        }
        if (isView)
        {
            if (!Directory.Exists(filePath + Path.DirectorySeparatorChar + ViewName))
            {
                Directory.CreateDirectory(filePath + Path.DirectorySeparatorChar + ViewName);
            }
        }
        if (isCrtl)
        {
            if (!Directory.Exists(filePath + Path.DirectorySeparatorChar + ControllerName))
            {
                Directory.CreateDirectory(filePath + Path.DirectorySeparatorChar + ControllerName);
            }
        }
    }

    private static void CreatUIScript(string BaseFilePath, string str)
    {
        if (!File.Exists(BaseFilePath))
        {
            FileStream fs = File.Create(BaseFilePath);
            StreamWriter sw = new StreamWriter(fs);
            //开始写入
            sw.Write(str);
            //清空缓冲区
            sw.Flush();
            //关闭流
            sw.Close();
            fs.Close();
        }
    }

    public static string ReadUITemp(string Path)
    {
        string str = "";
        if (File.Exists(Path))
        {
            str = File.ReadAllText(Path);
        }
        return str;
    }

    #endregion CreatNewUI
}
