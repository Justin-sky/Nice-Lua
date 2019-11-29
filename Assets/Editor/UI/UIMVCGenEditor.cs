using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class UIMVCGenEditor : EditorWindow
{
    private static Object modulePathObj = null;

    [MenuItem("Tools/MVC")]
    static void Init()
    {
        GetWindow(typeof(UIMVCGenEditor));
    
    }

    private void OnGUI()
    {
        //标题
        GUILayout.Space(10);
        GUILayout.BeginHorizontal();
        GUILayout.Label("此工具用于单独生成MVC相关模板到指定的模块中");
        GUILayout.EndHorizontal();

        //选择module
        GUILayout.Space(10);
        GUILayout.BeginHorizontal();
        GUILayout.Label("module path: ", EditorStyles.boldLabel, GUILayout.Width(100));

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

            string pagePath = UIMVCGen.output_dir + modulePathObj.name + "/Model";
            if (!Directory.Exists(pagePath)) Directory.CreateDirectory(pagePath);

            string modelPath = pagePath + "/" + trans.name + "Model.lua";
            if (File.Exists(modelPath))
            {
                EditorUtility.DisplayDialog("错误", "文件已存在："+pagePath, "确定");
                return;
            }
            UIMVCGen.GenUITemplate(trans.name, UIMVCGen.tpl_model, modelPath);

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

            string pagePath = UIMVCGen.output_dir + modulePathObj.name + "/View";
            if (!Directory.Exists(pagePath)) Directory.CreateDirectory(pagePath);

            string modelPath = pagePath + "/" + trans.name + "View.lua";
            if (File.Exists(modelPath))
            {
                EditorUtility.DisplayDialog("错误", "文件已存在：" + pagePath, "确定");
                return;
            }
            UIMVCGen.GenUITemplate(trans.name, UIMVCGen.tpl_view, modelPath);
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

            string pagePath = UIMVCGen.output_dir + modulePathObj.name + "/Controller";
            if (!Directory.Exists(pagePath)) Directory.CreateDirectory(pagePath);

            string modelPath = pagePath + "/" + trans.name + "Ctrl.lua";
            if (File.Exists(modelPath))
            {
                EditorUtility.DisplayDialog("错误", "文件已存在：" + pagePath, "确定");
                return;
            }
            UIMVCGen.GenUITemplate(trans.name, UIMVCGen.tpl_controller, modelPath);
        }

        GUILayout.EndHorizontal();




    }
}
