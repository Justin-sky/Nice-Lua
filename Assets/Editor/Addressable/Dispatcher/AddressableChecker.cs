using UnityEngine;
using System.IO;
using UnityEditor;
using System.Collections.Generic;

/// <summary>
/// 说明：Assetbundle检测器，由于Unity中的AssetBundle名字标签很不好管理，这里做一层检测以防漏
/// 注意：
/// 1、每个Assetbundle对应配置一个Checker，Checker对应的PackagePath及为Assetbundle所在路径
/// 2、每个Checker可以检测多个目录或者文件，这些目录或者文件被打入一个Assetbundle包
/// TODO：
/// 1、提供自动化的Checker，每次检测到有Asset变动（移动、新增、删除）时自动Check
/// 2、提供一套可视化编辑界面，将Checker配置化并展示到Inspector，从而新增/删除Checker不需要写代码
/// 3、支持Variant
/// </summary>

namespace AssetBundles
{
    public class AddressableCheckerFilter
    {
        public string RelativePath;
        public string ObjectFilter;
        
        public AddressableCheckerFilter(string relativePath, string objectFilter)
        {
            RelativePath = relativePath;
            ObjectFilter = objectFilter;
        }
    }

    public class AddressableCheckerConfig
    {
        public string PackagePath = string.Empty;
        public List<AddressableCheckerFilter> CheckerFilters = null;

        public AddressableCheckerConfig()
        {
        }

        public AddressableCheckerConfig(string packagePath, List<AddressableCheckerFilter> checkerFilters)
        {
            PackagePath = packagePath;
            CheckerFilters = checkerFilters;
        }
    }

    public class AddressableChecker
    {
        string assetsPath;
  
        AddressableCheckerConfig config;

        public AddressableChecker(AddressableCheckerConfig config)
        {
            this.config = config;
            assetsPath = AssetBundleUtility.PackagePathToAssetsPath(config.PackagePath);
            
        }

        public void CheckAddressablePath(DirectoryInfo di)
        {
            var groupName = config.PackagePath.Replace("/", "-").ToLower();

            FileInfo[] fis = di.GetFiles();
            foreach(FileInfo f in fis)
            {
                if (f.Extension.Equals(".meta")) continue;
               
                string relativePath = f.FullName.Substring(f.FullName.IndexOf("\\Assets\\")+1);
                AASUtility.AddAssetToGroup(AssetDatabase.AssetPathToGUID(relativePath), groupName);
               
            }
            DirectoryInfo[] dis = di.GetDirectories();
            foreach(DirectoryInfo d in dis)
            {
                CheckAddressablePath(d);
            }
            
        }

        public void CheckAssetBundleName()
        {  
            var checkerFilters = config.CheckerFilters;
            if (checkerFilters == null || checkerFilters.Count == 0)
            {
                CheckAddressablePath(new DirectoryInfo(assetsPath));
            }
            else
            {
                foreach (var checkerFilter in checkerFilters)
                {
                    var relativePath = assetsPath;
                    if (!string.IsNullOrEmpty(checkerFilter.RelativePath))
                    {
                        relativePath = Path.Combine(assetsPath, checkerFilter.RelativePath);
                    }

                    var groupName = config.PackagePath.Replace("/", "-").ToLower();
                    string[] objGuids = AssetDatabase.FindAssets(checkerFilter.ObjectFilter, new string[] { relativePath });
                    foreach (var guid in objGuids)
                    {
                         AASUtility.AddAssetToGroup(guid, groupName);
                    }
                }
            }
        }


        public static void Run(AddressableCheckerConfig config)
        {
            var checker = new AddressableChecker(config);
            checker.CheckAssetBundleName();

            AssetDatabase.Refresh();
        }
    }
}
