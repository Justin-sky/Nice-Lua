using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace GamePlay
{
    [Serializable]
    public abstract class ACategory<T> : ISerializationCallbackReceiver where T:AConfig
    {
        [SerializeField]
        public List<T> datas;

        public Dictionary<long, T> dict;


        public void OnBeforeSerialize() { }

        public void OnAfterDeserialize()
        {

            this.OnDeserialize();
        }
        
        public virtual void OnDeserialize()
        {

        }

        public T get(long id)
        {
            T t;
            if (!this.dict.TryGetValue(id, out t))
            {
                throw new Exception($"not found config: {typeof(T)} id: {id}");
            }
            return t;
        }

        public  Dictionary<long , T> GetAll()
        {
            return dict;
        }

        public T GetOne()
        {
            return dict.Values.First();
        }
    }
}
