using System; 
using System.Collections.Generic; 
using UnityEngine; 
namespace GamePlay { 
	[Config]
	public partial class C_SkillDataCategory : ACategory<C_SkillData>
	{
		public static C_SkillDataCategory Instance;
		public C_SkillDataCategory()
		{
			Instance = this;
		}
		public override void OnDeserialize(){ 
			if (datas != null) 
			{ 
				dict = new Dictionary<long, C_SkillData>(); 
				foreach (var t in datas) 
				{
					dict.Add(t.Id, t); 
				} 
			} 
		}
 
	}

	[Serializable]
	public partial class C_SkillData: AConfig
	{
		[SerializeField] public long Id;
		[SerializeField] public string Name;
		[SerializeField] public string Description;
		[SerializeField] public int CoolTime;
		[SerializeField] public int CostSP;
		[SerializeField] public float AttackDistance;
		[SerializeField] public float AttackAngle;
		[SerializeField] public string[] AttackTargetTags;
		[SerializeField] public string[] ImpactType;
		[SerializeField] public int NextBattlerId;
		[SerializeField] public float AtkRatio;
		[SerializeField] public float DurationTime;
		[SerializeField] public float AtkInterval;
		[SerializeField] public string SkillPrefab;
		[SerializeField] public string AnimationName;
		[SerializeField] public string HitFxPrefab;
		[SerializeField] public int Level;
		[SerializeField] public int AttackType;
		[SerializeField] public int SelectorType;
	}
}
