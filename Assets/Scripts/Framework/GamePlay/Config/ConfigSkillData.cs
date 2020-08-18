using System;
using System.Collections.Generic;
using UnityEngine;

namespace GamePlay
{
    [Serializable]
    public partial class ConfigSkillData:AConfig
    {

        [SerializeField] public long Id;
        [SerializeField] public string name;
        [SerializeField] public List<string> tags;



        
    }
}
