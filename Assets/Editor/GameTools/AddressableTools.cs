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


    [MenuItem("NICELua/Marked AssetsPackage Addressable", false, 52)]
    public static void RunCheckAssetBundle()
    {
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


        Debug.Log("Finished Update Asset Path Map... " + (DateTime.Now - start).TotalSeconds + "s");
        
    }

    public static void SingleFileAddress(string group, string path)
    {
        string relativePath = path.Substring(path.IndexOf("Assets\\") );
       
        AASUtility.AddAssetToGroup(AssetDatabase.AssetPathToGUID(relativePath), group);
    }
}

