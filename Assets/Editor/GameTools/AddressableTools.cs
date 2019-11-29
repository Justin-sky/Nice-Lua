using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[InitializeOnLoad]
public class AddressableTools
{


    [MenuItem("Tools/Marked AssetsPackage Addressable", false, 52)]
    public static void RunCheckAssetBundle()
    {
        var start = DateTime.Now;
        CheckAssetBundles.Run();
        Debug.Log("Finished CheckAssetBundles.Run! use " + (DateTime.Now - start).TotalSeconds + "s");

    }

}

