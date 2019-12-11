using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;

public class UIGOGen
{

    public static void GenScrollView(
        Transform parent,
        string scrollViewName,
        int scrollViewWidth,
        int scrollViewHeigh,
        int cellWidth,
        int cellHeight,
        bool horizontal,
        bool vertical
        ) {

        //ScrollView
        GameObject scrollViewGO = new GameObject();
        scrollViewGO.name = $"{scrollViewName}ScrollView";
        RectTransform rectTransform = scrollViewGO.AddComponent<RectTransform>();
        rectTransform.sizeDelta = new Vector2(scrollViewWidth, scrollViewHeigh);
        rectTransform.localScale = new Vector3(1, 1, 1);
        rectTransform.position = new Vector3(0, 0, 0);
                
        //ScrollRect
        GameObject scrollRectGO = new GameObject();
        scrollRectGO.name = $"{scrollViewName}ScrollRect";
        ScrollRect scrollRect = scrollRectGO.AddComponent<ScrollRect>();
        scrollRect.horizontal = horizontal;
        scrollRect.vertical = vertical;

        RectTransform scrollRectRectTransform = scrollRectGO.GetComponent<RectTransform>();
        scrollRectRectTransform.anchorMin = new Vector2(0, 0);
        scrollRectRectTransform.anchorMax = new Vector2(1, 1);
        scrollRectRectTransform.anchoredPosition = new Vector2(0, 0);
        scrollRectRectTransform.pivot = new Vector2(0.5f, 0.5f);
        scrollRectRectTransform.localPosition = new Vector3(0, 0, 0);
        scrollRectRectTransform.sizeDelta = new Vector2(0,0);
        
        scrollRectGO.AddComponent<Mask>();
        scrollRectGO.AddComponent<CanvasRenderer>();
        scrollRectGO.AddComponent<Image>();
                
        //ScrollContent
        GameObject scrollContentGO = new GameObject();
        scrollContentGO.name = $"{scrollViewName}ScrollContent";

        GridLayoutGroup grid = scrollContentGO.AddComponent<GridLayoutGroup>();
        grid.cellSize = new Vector2(cellWidth, cellHeight);
        grid.spacing = new Vector2(10, 10);

        if (horizontal)
        {
            grid.startAxis = GridLayoutGroup.Axis.Horizontal;
            grid.constraint = GridLayoutGroup.Constraint.FixedColumnCount;
        }
        else
        {
            grid.startAxis = GridLayoutGroup.Axis.Vertical;
            grid.constraint = GridLayoutGroup.Constraint.FixedRowCount;
        }

        RectTransform scrollContentTransform = scrollContentGO.GetComponent<RectTransform>();
        scrollContentTransform.anchorMin = new Vector2(0, 1);
        scrollContentTransform.anchorMax = new Vector2(0, 1);
        scrollContentTransform.anchoredPosition = new Vector2(0, 0);
        scrollContentTransform.pivot = new Vector2(0,1);
        scrollContentTransform.sizeDelta = new Vector2(scrollViewWidth, scrollViewHeigh);
               
        for (int i=0; i<5; i++)
        {
            GameObject itemGO = new GameObject();
            itemGO.name = $"{scrollViewName}Item{i}";
            itemGO.AddComponent<RectTransform>();

            GameObject textGO = new GameObject();
            textGO.name = "Text";
            Text text = textGO.AddComponent<Text>();
            text.text = $"text{i}";
            textGO.transform.parent = itemGO.transform;

            itemGO.transform.parent = scrollContentGO.transform;
        }

        scrollViewGO.transform.SetParent(parent, false);
        scrollRectGO.transform.SetParent(scrollViewGO.transform, false);
        scrollRect.content = scrollContentTransform;
        scrollContentGO.transform.SetParent(scrollRectGO.transform,false);

        //scrollbar 
        GameObject handleGo = new GameObject();
        handleGo.name = "Handle";
        handleGo.AddComponent<Image>();

        GameObject slicingAreaGo = new GameObject();
        slicingAreaGo.name = "SlidingArea";
        
        GameObject scrollbarVGo = new GameObject();
        scrollbarVGo.name = $"ScrollbarVertical";
        scrollbarVGo.AddComponent<Image>();
        Scrollbar sbar = scrollbarVGo.AddComponent<Scrollbar>();
        sbar.handleRect = handleGo.GetComponent<RectTransform>();
        
        handleGo.transform.SetParent(slicingAreaGo.transform, false);
        slicingAreaGo.transform.SetParent(scrollbarVGo.transform, false);
        scrollbarVGo.transform.SetParent(scrollViewGO.transform, false);
    }

}
