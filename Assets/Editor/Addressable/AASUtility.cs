using System.Collections.Generic;
using UnityEngine;

public class AASUtility : UnityEditor.Editor
{
    public static UnityEditor.AddressableAssets.Settings.AddressableAssetSettings GetSettings()
    {
        //アドレサブルアセットセッティング取得
        var d = UnityEditor.AssetDatabase.LoadAssetAtPath<UnityEditor.AddressableAssets.Settings.AddressableAssetSettings>(
            "Assets/AddressableAssetsData/AddressableAssetSettings.asset"
            );
        return d;
    }


    public static UnityEditor.AddressableAssets.Settings.AddressableAssetGroup CreateGroup(string groupName)
    {
        //アドレサブルアセットセッティング取得
        var s = GetSettings();
        //スキーマ生成
        List<UnityEditor.AddressableAssets.Settings.AddressableAssetGroupSchema> schema = new List<UnityEditor.AddressableAssets.Settings.AddressableAssetGroupSchema>() {
             ScriptableObject.CreateInstance<UnityEditor.AddressableAssets.Settings.GroupSchemas.BundledAssetGroupSchema>(),
             ScriptableObject.CreateInstance<UnityEditor.AddressableAssets.Settings.GroupSchemas.ContentUpdateGroupSchema>(),

        };
        //グループの作成
        var f = s.groups.Find((g) => { return g.name == groupName; });
        if (f == null)
        {
            return s.CreateGroup(groupName, false, false, true, schema);
        }

        return f;
    }

    public static void AddAssetToGroup(string assetGuid, string groupName)
    {
        var s = GetSettings();
        var g = CreateGroup(groupName);
        var entry = s.CreateOrMoveEntry(assetGuid, g);
        entry.address = entry.address.Replace("Assets/AssetsPackage/","");
    }
    public static void SetLabelToAsset(List<string> assetGuidList, string label, bool flag)
    {
        var s = GetSettings();
        //ラベルを追加するように呼んでおく。追加されていないと設定されない。
        s.AddLabel(label);
        List<UnityEditor.AddressableAssets.Settings.AddressableAssetEntry> assetList = new List<UnityEditor.AddressableAssets.Settings.AddressableAssetEntry>();
        s.GetAllAssets(assetList, true);
        foreach (var assetGuid in assetGuidList)
        {
            var asset = assetList.Find((a) => { return a.guid == assetGuid; });
            if (asset != null)
            {
                asset.SetLabel(label, flag);
            }
        }
    }
    public static void RemoveAssetFromGroup(string assetGuid)
    {
        var s = GetSettings();
        s.RemoveAssetEntry(assetGuid);
    }

    public static void BuildPlayerContent()
    {
        var d = GetSettings();
        UnityEditor.AddressableAssets.Settings.AddressableAssetSettings.BuildPlayerContent();
    }

    static public void Test()
    {
        var d = GetSettings();

        var matguid = UnityEditor.AssetDatabase.AssetPathToGUID("Assets/Data/hogeMat.mat");
        AddAssetToGroup(matguid, "CreatedGroup");
        ////List<string> assetGuidList = new List<string>() { matguid };
        ////SetLabelToAsset(assetGuidList, "mat", true);
        //CreateGroup("CreatedGroup");
    }
}