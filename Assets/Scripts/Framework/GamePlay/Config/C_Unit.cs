using System; 
using System.Collections.Generic; 
using UnityEngine; 
namespace GamePlay { 
	[Config]
	public partial class C_UnitCategory : ACategory<C_Unit>
	{
		public static C_UnitCategory Instance;
		public C_UnitCategory()
		{
			Instance = this;
		}
		public override void OnDeserialize(){ 
			if (datas != null) 
			{ 
				dict = new Dictionary<long, C_Unit>(); 
				foreach (var t in datas) 
				{
					dict.Add(t.Id, t); 
				} 
			} 
		}
 
	}

	[Serializable]
	public partial class C_Unit: AConfig
	{
		[SerializeField] public long Id;
		[SerializeField] public float BaseATK;
		[SerializeField] public float SP;
		[SerializeField] public float HP;
		[SerializeField] public float AttackDistance;
		[SerializeField] public float AttackInterval;
	}
}
