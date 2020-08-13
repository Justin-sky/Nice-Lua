using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor.AddressableAssets.Settings;
using UnityEditor;
using UnityEngine;
using System.Linq;
using System.IO;
using AssetBundles;

[InitializeOnLoad]
public class AddressableTools
{


    [MenuItem("NICELua/Initialize Addressable Enviroment", false, 52)]
    public static void RunCheckAssetBundle()
    {

        var initGroups = new string[] {
         "static_effect",
         "static_lua",
         "static_models",
         "static_render_assets",
         "static_shaders",
         "static_ui",
         "static_config"
        };


        var start = DateTime.Now;
       

        //更新assetmap
        List<AddressableAssetEntry> assets = new List<AddressableAssetEntry>();
        AASUtility.GetSettings().GetAllAssets(assets, false,
            (g) => { return g.name.Equals("static_lua"); });

        string[] address = assets.Select(e => e.address).ToArray();

        string assetFolder = Path.Combine(Application.dataPath, AssetBundleConfig.AssetsFolderName);
        
        var assetPathMap = Path.Combine(assetFolder, AssetBundleConfig.AssetsPathMapFileName);

        GameUtility.SafeWriteAllLines(assetPathMap, address);
        AssetDatabase.Refresh();

        //初始化Groups
        foreach(var g in initGroups)
        {
            AASUtility.CreateGroup(g);
        }
        Debug.Log("Finished Update Asset Path Map... " + (DateTime.Now - start).TotalSeconds + "s");
        
    }

    public static void SingleFileAddress(string group, string path)
    {
        string relativePath = path.Substring(path.IndexOf("Assets\\") );
       
        AASUtility.AddAssetToGroup(AssetDatabase.AssetPathToGUID(relativePath), group);
    }
}

