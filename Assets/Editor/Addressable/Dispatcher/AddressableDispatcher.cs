using UnityEngine;
using UnityEditor;
using System.IO;

/// <summary>
/// 说明：Assetbundle分发器，用于分发、管理某个目录下的各种Checker
/// 注意：
/// 1、一个分发器可以管理多个Checker，但是所有的这些Checker共享一套配置
/// TODO：
/// 1、提供一套可视化编辑界面，将Dispatcher配置化并展示到Inspector
/// </summary>

namespace AssetBundles
{
    public enum AddressableDispatcherFilterType
    {
        Root,
        Children,
        ChildrenFoldersOnly,
        ChildrenFilesOnly,
    }

    public class AddressableDispatcher
    {
        string assetsPath;
        AddressableDispatcherConfig config;

        public AddressableDispatcher(AddressableDispatcherConfig config)
        {
            this.config = config;
            assetsPath = AssetBundleUtility.PackagePathToAssetsPath(config.PackagePath);
         
        }

        public void RunCheckers()
        {
            switch (config.Type)
            {
                case AddressableDispatcherFilterType.Root:
                    CheckRoot();
                    break;
                case AddressableDispatcherFilterType.Children:
                case AddressableDispatcherFilterType.ChildrenFoldersOnly:
                case AddressableDispatcherFilterType.ChildrenFilesOnly:
                    CheckChildren();
                    break;
            }
        }

        void CheckRoot()
        {
            var checkerConfig = new AddressableCheckerConfig(config.PackagePath, config.CheckerFilters);
            AddressableChecker.Run(checkerConfig);
        }

        void CheckChildren()
        {
            string[] subFolders = AssetDatabase.GetSubFolders(assetsPath);
            var checkerConfig = new AddressableCheckerConfig();

            foreach (string f in subFolders)
            {
                var packPath = AssetBundleUtility.AssetsPathToPackagePath(f);
                
                if (config.Type == AddressableDispatcherFilterType.ChildrenFilesOnly 
                    && !File.Exists(f))
                {
                    //continue;
                }
                else if (config.Type == AddressableDispatcherFilterType.ChildrenFoldersOnly 
                    && File.Exists(f))
                {
                    //continue;
                }

                checkerConfig.CheckerFilters = config.CheckerFilters;
                checkerConfig.PackagePath = packPath;
                AddressableChecker.Run(checkerConfig);
            }

        }

        public static void Run(AddressableDispatcherConfig config)
        {
            var dispatcher = new AddressableDispatcher(config);
            dispatcher.RunCheckers();
            AssetDatabase.Refresh();
        }
    }
}
