using fb;

namespace GamePlay
{
    class Class1
    {

        public void test()
        {
            FlatBuffers.ByteBuffer bb = FlatBufferManager.Instance.GetSkillData("skillconfig");
            skillconfigTB tb = skillconfigTB.GetRootAsskillconfigTB(bb);
            skillconfigTR tr = (skillconfigTR)tb.SkillconfigTRSByKey(1003);
            Logger.Log($" {tr._id} : {tr.Name} : {tr.Skillprefab}");

        }
    }
}
