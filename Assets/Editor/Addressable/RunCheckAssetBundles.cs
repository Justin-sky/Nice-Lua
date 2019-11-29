using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEditor.AddressableAssets.Settings;

namespace AssetBundles
{
    public class RunCheckAssetBundles
    {
        [MenuItem("Tools/CheckAssetbundles", false, 10)]
        public static void RunCheckAssetBundle()
        {
            var start = DateTime.Now;
            CheckAssetBundles.Run();
            Debug.Log("Finished CheckAssetBundles.Run! use " + (DateTime.Now - start).TotalSeconds + "s");

        }



    }


   
}
