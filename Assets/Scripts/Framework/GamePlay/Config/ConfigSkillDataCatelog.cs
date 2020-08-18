using System;
using System.Collections.Generic;
using UnityEngine;

namespace GamePlay
{
    [Config]
    public partial  class ConfigSkillDataCatelog: ACategory<ConfigSkillData>
    {
        public static ConfigSkillDataCatelog Instance;

        public ConfigSkillDataCatelog()
        {
            Instance = this;
        }

        public override void OnDeserialize(){
            if (datas != null)
            {
                dict = new Dictionary<long, ConfigSkillData>();
                foreach (var t in datas)
                {
                    dict.Add(t.Id, t);
                }
            }
        }
    }
}
