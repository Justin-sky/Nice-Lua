using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
using System.IO;
#endif

/// <summary>
/// added by wsh @ 2017.12.25
/// 注意：
/// 1、所有ab路径中目录、文件名不能以下划线打头，否则出包时StreamingAssets中的资源不能打到真机上，很坑爹
/// </summary>

namespace AssetBundles
{
    public class AssetBundleConfig
    {
        public const string localSvrAppPath = "Editor/AssetBundle/LocalServer/AssetBundleServer.exe";
        public const string AssetBundlesFolderName = "AssetBundles";
        public const string AssetBundleSuffix = ".assetbundle";
        public const string AssetsFolderName = "AssetsPackage";
        public const string ChannelFolderName = "Channel";
        public const string AssetsPathMapFileName = "Config/AssetsMap.bytes";
        public const string VariantMapParttren = "Variant";
        public const string CommonMapPattren = ",";


    }
}