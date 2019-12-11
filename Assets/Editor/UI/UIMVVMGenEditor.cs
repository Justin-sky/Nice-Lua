using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class UIMVVMGenEditor : EditorWindow
{
    public enum UILayers_TYPE
    {
        SceneLayer,//用于场景UI
        BackgroudLayer,//背景UI
        NormalLayer,//普通一级、二级、三级UI
        InfoLayer,//信息UI
        TipLayer,//提示UI
        TopLayer,//顶层UI
    }

    private static Object modulePathObj = null;
    private static UILayers_TYPE mLayerType;

    private static string scrollViewName = "Test";
    private static Vector2Int widthHeight = new Vector2Int(500, 200);
    private static Vector2Int cellWH = new Vector2Int(100, 50);
    private static bool horizontal = true;
    private static bool vertical = false;

    [MenuItem("NICELua/MVVM")]
    static void Init()
    {
        EditorWindow window =  GetWindow(typeof(UIMVVMGenEditor));
        window.position = new Rect(100, 100, 400, 500);
        
    }

    private void OnGUI()
    {
        //标题
        GUILayout.Space(10);
        GUILayout.BeginHorizontal();
        GUILayout.Label("此工具用于单独生成MVC相关模板到指定的模块中");
        GUILayout.EndHorizontal();

        //选择层
        GUILayout.Space(10);
        GUILayout.BeginHorizontal();
        GUILayout.Label("Choose Layer: ",EditorStyles.boldLabel, GUILayout.Width(100));
        mLayerType = (UILayers_TYPE)EditorGUILayout.EnumPopup(mLayerType);
        GUILayout.EndHorizontal();

        //选择module
        GUILayout.Space(10);
        GUILayout.BeginHorizontal();
        GUILayout.Label("Module Path: ", EditorStyles.boldLabel, GUILayout.Width(100));
        modulePathObj = EditorGUILayout.ObjectField(modulePathObj, typeof(Object),true) as Object;
        GUILayout.EndHorizontal();

        //操作按钮
        GUILayout.Space(10);
        GUILayout.BeginHorizontal();
        if(GUILayout.Button("生成 M", GUILayout.ExpandWidth(true)))
        {
            Transform trans = Selection.activeTransform;
            if (trans == null)
            {
                EditorUtility.DisplayDialog("错误", "请选择需要生成模板的UI对象!", "确定");
                return;
            }
            if (modulePathObj == null)
            {
                EditorUtility.DisplayDialog("错误", "请选择目标目录!", "确定");
                return;
            }

            string pagePath = UIMVVMGen.output_dir + modulePathObj.name + "/Model";
            if (!Directory.Exists(pagePath)) Directory.CreateDirectory(pagePath);

            string modelPath = pagePath + "/" + trans.name + "Model.lua";
            if (File.Exists(modelPath))
            {
                EditorUtility.DisplayDialog("错误", "文件已存在："+pagePath, "确定");
                return;
            }
            UIMVVMGen.GenUITemplate(trans.name, mLayerType.ToString(), UIMVVMGen.tpl_model, modelPath);

        }
        if(GUILayout.Button("生成 V", GUILayout.ExpandWidth(true)))
        {
            Transform trans = Selection.activeTransform;
            if (trans == null)
            {
                EditorUtility.DisplayDialog("错误", "请选择需要生成模板的UI对象!", "确定");
                return;
            }
            if (modulePathObj == null)
            {
                EditorUtility.DisplayDialog("错误", "请选择目标目录!", "确定");
                return;
            }

            string pagePath = UIMVVMGen.output_dir + modulePathObj.name + "/View";
            if (!Directory.Exists(pagePath)) Directory.CreateDirectory(pagePath);

            string modelPath = pagePath + "/" + trans.name + "View.lua";
            if (File.Exists(modelPath))
            {
                EditorUtility.DisplayDialog("错误", "文件已存在：" + pagePath, "确定");
                return;
            }
            UIMVVMGen.GenUITemplate(trans.name, mLayerType.ToString(), UIMVVMGen.tpl_view, modelPath);
        }
        if(GUILayout.Button("生成 C", GUILayout.ExpandWidth(true)))
        {
            Transform trans = Selection.activeTransform;
            if (trans == null)
            {
                EditorUtility.DisplayDialog("错误", "请选择需要生成模板的UI对象!", "确定");
                return;
            }
            if (modulePathObj == null)
            {
                EditorUtility.DisplayDialog("错误", "请选择目标目录!", "确定");
                return;
            }

            string pagePath = UIMVVMGen.output_dir + modulePathObj.name + "/Controller";
            if (!Directory.Exists(pagePath)) Directory.CreateDirectory(pagePath);

            string modelPath = pagePath + "/" + trans.name + "Ctrl.lua";
            if (File.Exists(modelPath))
            {
                EditorUtility.DisplayDialog("错误", "文件已存在：" + pagePath, "确定");
                return;
            }
            UIMVVMGen.GenUITemplate(trans.name, mLayerType.ToString(), UIMVVMGen.tpl_controller, modelPath);
        }

        if (GUILayout.Button("生成 Config", GUILayout.ExpandWidth(true)))
        {
            Transform trans = Selection.activeTransform;
            if (trans == null)
            {
                EditorUtility.DisplayDialog("错误", "请选择需要生成模板的UI对象!", "确定");
                return;
            }
            if (modulePathObj == null)
            {
                EditorUtility.DisplayDialog("错误", "请选择目标目录!", "确定");
                return;
            }

            string pagePath = UIMVVMGen.output_dir + modulePathObj.name ;
            if (!Directory.Exists(pagePath)) Directory.CreateDirectory(pagePath);


            string configPath = pagePath + "/" + trans.name + "Config.lua";
            if (File.Exists(configPath))
            {
                Logger.LogError("lua file in path:{0} is existed.", configPath);
                return;
            }

            UIMVVMGen.GenUITemplate(trans.name, mLayerType.ToString(), UIMVVMGen.tpl_config, configPath);
        }

        GUILayout.EndHorizontal();


        #region 生成 ScrollView
        GUILayout.Space(30);
        GUILayout.BeginHorizontal();
        GUILayout.Label("创建ScrollView GameObject");
        GUILayout.EndHorizontal();

        GUILayout.BeginVertical();
        
        scrollViewName = EditorGUILayout.TextField("ScrollView Name Prefix:", scrollViewName);  
        widthHeight = EditorGUILayout.Vector2IntField("Scroll Size: ", widthHeight);
        cellWH = EditorGUILayout.Vector2IntField("Cell Size:", cellWH);

        GUILayout.BeginHorizontal();
        horizontal = EditorGUILayout.Toggle("Horizontal: ", horizontal);
        vertical = EditorGUILayout.Toggle("Vertical: ", vertical);
        GUILayout.EndHorizontal();

        GUILayout.EndVertical();

        GUILayout.Space(30);
        GUILayout.BeginVertical();
        if (GUILayout.Button("创建 ScrollView", GUILayout.ExpandWidth(true)))
        {
            Transform trans = Selection.activeTransform;
            if (trans == null)
            {
                EditorUtility.DisplayDialog("错误", "请选择ScrollView所在的父结点!", "确定");
                return;
            }

            UIGOGen.GenScrollView(trans, scrollViewName, widthHeight.x, widthHeight.y, cellWH.x, cellWH.y, horizontal, vertical);
        }
        GUILayout.EndVertical();
        #endregion
    }
}
