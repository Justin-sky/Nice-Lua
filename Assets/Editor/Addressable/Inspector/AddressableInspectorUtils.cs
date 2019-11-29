using UnityEngine;
using System.Collections;
using System.IO;

/// <summary>
/// 说明：AddressableInspectorUtils工具类
/// </summary>

namespace AssetBundles
{
    public class AddressableInspectorUtils
    {
        public const string DatabaseRoot = "Assets/Editor/Addressable/Database";

        static public bool CheckMaybeAddressableAsset(string assetPath)
        {
            return assetPath.StartsWith("Assets/" + AssetBundleConfig.AssetsFolderName);
        }

        static public string AssetPathToDatabasePath(string assetPath)
        {
            if (!CheckMaybeAddressableAsset(assetPath))
            {
                return null;
            }

            assetPath = assetPath.Replace("Assets/", "");
            return Path.Combine(DatabaseRoot, assetPath + ".asset");
        }
    }
}
