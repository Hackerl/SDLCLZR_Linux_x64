-- Person class
require(CONFIG.ScriptPath .. "model/data_struct")

Person_S={};      --保存人物数据的结构，以便以后存取
Person_S["代号"]={0,0,2}
Person_S["头像代号"]={2,0,2}
Person_S["生命增长"]={4,0,2}
Person_S["无用"]={6,0,2}
Person_S["姓名"]={8,2,10}
Person_S["外号"]={18,2,10}
Person_S["性别"]={28,0,2}
Person_S["等级"]={30,0,2}
Person_S["经验"]={32,1,2}
Person_S["生命"]={34,0,2}
Person_S["生命最大值"]={36,0,2}
Person_S["受伤程度"]={38,0,2}
Person_S["中毒程度"]={40,0,2}
Person_S["体力"]={42,0,2}
Person_S["物品修炼点数"]={44,0,2}
Person_S["武器"]={46,0,2}
Person_S["防具"]={48,0,2}

for i=1,5 do
    Person_S["出招动画帧数" .. i]={50+2*(i-1),0,2};
    Person_S["出招动画延迟" .. i]={60+2*(i-1),0,2};
    Person_S["武功音效延迟" .. i]={70+2*(i-1),0,2};
end

Person_S["内力性质"]={80,0,2}
Person_S["内力"]={82,0,2}
Person_S["内力最大值"]={84,0,2}
Person_S["攻击力"]={86,0,2}
Person_S["轻功"]={88,0,2}
Person_S["防御力"]={90,0,2}
Person_S["医疗能力"]={92,0,2}
Person_S["用毒能力"]={94,0,2}
Person_S["解毒能力"]={96,0,2}
Person_S["抗毒能力"]={98,0,2}

Person_S["拳掌功夫"]={100,0,2}
Person_S["御剑能力"]={102,0,2}
Person_S["耍刀技巧"]={104,0,2}
Person_S["特殊兵器"]={106,0,2}
Person_S["暗器技巧"]={108,0,2}


Person_S["武学常识"]={110,0,2}
Person_S["品德"]={112,0,2}
Person_S["攻击带毒"]={114,0,2}
Person_S["左右互搏"]={116,0,2}
Person_S["声望"]={118,0,2}

Person_S["资质"]={120,0,2}
Person_S["修炼物品"]={122,0,2}
Person_S["修炼点数"]={124,0,2}

for i=1,10 do
    Person_S["武功" .. i]={126+2*(i-1),0,2};
    Person_S["武功等级" .. i]={146+2*(i-1),0,2};
end

for i=1,4 do
    Person_S["携带物品" .. i]={166+2*(i-1),0,2};
    Person_S["携带物品数量" .. i]={174+2*(i-1),0,2};
end

Person = {
    PersonSize=182;   --每个人物数据占用字节
}

function Person:find (o,id)
    o = o or {}
    local meta_t={
        __index=function(t,k)
            return GetDataFromStruct(JY.Data_Person,id * self.PersonSize,Person_S,k);
        end,
        __newindex=function(t,k,v)
            SetDataFromStruct(JY.Data_Person,id * self.PersonSize,Person_S,k,v);
        end
    }
    setmetatable(o, meta_t)
    return o
end
