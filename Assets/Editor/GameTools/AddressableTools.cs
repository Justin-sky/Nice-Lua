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


    [MenuItem("Tools/Marked AssetsPackage Addressable", false, 52)]
    public static void RunCheckAssetBundle()
    {
        var start = DateTime.Now;
        CheckAssetBundles.Run();

        //更新assetmap
        List<AddressableAssetEntry> assets = new List<AddressableAssetEntry>();
        AASUtility.GetSettings().GetAllAssets(assets, false,
            (g) => { return g.name.Equals("lua");  });

        string[] address = assets.Select(e => e.address).ToArray();

        string assetPathMap = Path.Combine(Application.dataPath, AssetBundleConfig.AssetsFolderName);
        assetPathMap = Path.Combine(assetPathMap, AssetBundleConfig.AssetsPathMapFileName);

        GameUtility.SafeWriteAllLines(assetPathMap, address);
        AssetDatabase.Refresh();

        Debug.Log("Finished CheckAssetBundles.Run! use " + (DateTime.Now - start).TotalSeconds + "s");
        
    }

}

