using Addressable;
using GameChannel;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.AddressableAssets.ResourceLocators;
using UnityEngine.ResourceManagement.AsyncOperations;
using UnityEngine.UI;

public class GameUpdater : MonoBehaviour
{
    Text statusText;
    Slider slider;

    float totalTime = 0f;
    bool needUpdateRes = false;

    void Awake()
    {
        statusText = transform.Find("ContentRoot/LoadingDesc").GetComponent<Text>();
        slider = transform.Find("ContentRoot/SliderBar").GetComponent<Slider>();
        slider.gameObject.SetActive(false);
    }

    void Start()
    {
        totalTime = 0f;
        statusText.text = "正在检测资源更新...";
    }


    public void StartCheckUpdate()
    {
        StartCoroutine(checkUpdate());
    }

    IEnumerator checkUpdate()
    {


        var start = DateTime.Now;
      
        AsyncOperationHandle<List<string>> handle = Addressables.CheckForCatalogUpdates(false);
        yield return handle;
        Logger.Log(string.Format("CheckIfNeededUpdate use {0}ms", (DateTime.Now - start).Milliseconds));

        if(handle.Status == AsyncOperationStatus.Succeeded)
        {
            List<string> catalogs = handle.Result;
            if (catalogs != null && catalogs.Count > 0)
            {
                UINoticeTip.Instance.ShowOneButtonTip("更新提示", $"本次更新资源包数量：{catalogs.Count}", "确定", null);
                yield return UINoticeTip.Instance.WaitForResponse();

                needUpdateRes = true;

                statusText.text = "正在更新资源...";
                slider.normalizedValue = 0f;
                slider.gameObject.SetActive(true);

               
                start = DateTime.Now;
                AsyncOperationHandle<List<IResourceLocator>> updateHandle = Addressables.UpdateCatalogs(catalogs, true);
                yield return updateHandle;
                Logger.Log(string.Format("UpdateFinish use {0}ms", (DateTime.Now - start).Milliseconds));

                yield return UpdateFinish();

                Addressables.Release(updateHandle);
            }

            Addressables.Release(handle);
        }
        

        needUpdateRes = false;

        ChannelManager.instance.resVersion = "112";
        ChannelManager.instance.appVersion = "1.0";
        yield return StartGame();

    }

    IEnumerator StartGame()
    {
        statusText.text = "正在准备资源...";

        XLuaManager.Instance.StartGame();
        CustomDataStruct.Helper.Startup();
        UINoticeTip.Instance.DestroySelf();
        Destroy(gameObject, 0.5f);
        yield break;
    }

    IEnumerator UpdateFinish()
    {
        slider.normalizedValue = 1f;
        statusText.text = "正在准备资源...";

        // 重启资源管理器
        yield return AddressablesManager.Instance.Cleanup();
        yield return AddressablesManager.Instance.Initialize();

        // 重启Lua虚拟机
        //预加载Lua
        AddressablesManager.Instance.ReleaseLuas();

        BaseAssetAsyncLoader loader = AddressablesManager.Instance.LoadAssetAsync(AddressableConfig.AssetsPathMapFileName, typeof(TextAsset));
        yield return loader;

        TextAsset maptext = loader.asset as TextAsset;
        string[] luas = maptext.text.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries);

        AddressablesManager.Instance.ReleaseAsset(loader.asset);
        loader.Dispose();
        LuaAsyncLoader luaLoader = AddressablesManager.Instance.LoadLuaAsync(luas);
        yield return luaLoader;

        XLuaManager.Instance.Restart();
        XLuaManager.Instance.StartHotfix();
        yield break;
    }

    private void Update()
    {
        if (needUpdateRes)
        {
            totalTime += Time.deltaTime;

            var progress = totalTime % 10;
            slider.normalizedValue = progress / 10;
        }
        
    }
}