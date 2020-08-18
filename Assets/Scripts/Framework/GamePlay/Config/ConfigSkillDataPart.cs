using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace GamePlay
{
    public partial class ConfigSkillData : ISerializationCallbackReceiver
    {
    
        public string testpart = "hello world";

        public void OnAfterDeserialize()
        {
            this.testpart = "go go go";

            Logger.Log("OnAfterDeserialize..................");
        }

        public void OnBeforeSerialize()
        {
           
        }

  

    }
}
