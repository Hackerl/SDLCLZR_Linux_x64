-- Person class
require(CONFIG.ScriptPath .. "model/data_struct")

Thing_S={};
Thing_S["代号"]={0,0,2}
Thing_S["名称"]={2,2,20}
Thing_S["名称2"]={22,2,20}
Thing_S["物品说明"]={42,2,30}
Thing_S["练出武功"]={72,0,2}
Thing_S["暗器动画编号"]={74,0,2}
Thing_S["使用人"]={76,0,2}
Thing_S["装备类型"]={78,0,2}
Thing_S["显示物品说明"]={80,0,2}
Thing_S["类型"]={82,0,2}
Thing_S["未知5"]={84,0,2}
Thing_S["未知6"]={86,0,2}
Thing_S["未知7"]={88,0,2}
Thing_S["加生命"]={90,0,2}
Thing_S["加生命最大值"]={92,0,2}
Thing_S["加中毒解毒"]={94,0,2}
Thing_S["加体力"]={96,0,2}
Thing_S["改变内力性质"]={98,0,2}
Thing_S["加内力"]={100,0,2}

Thing_S["加内力最大值"]={102,0,2}
Thing_S["加攻击力"]={104,0,2}
Thing_S["加轻功"]={106,0,2}
Thing_S["加防御力"]={108,0,2}
Thing_S["加医疗能力"]={110,0,2}

Thing_S["加用毒能力"]={112,0,2}
Thing_S["加解毒能力"]={114,0,2}
Thing_S["加抗毒能力"]={116,0,2}
Thing_S["加拳掌功夫"]={118,0,2}
Thing_S["加御剑能力"]={120,0,2}

Thing_S["加耍刀技巧"]={122,0,2}
Thing_S["加特殊兵器"]={124,0,2}
Thing_S["加暗器技巧"]={126,0,2}
Thing_S["加武学常识"]={128,0,2}
Thing_S["加品德"]={130,0,2}

Thing_S["加攻击次数"]={132,0,2}
Thing_S["加攻击带毒"]={134,0,2}
Thing_S["仅修炼人物"]={136,0,2}
Thing_S["需内力性质"]={138,0,2}
Thing_S["需内力"]={140,0,2}

Thing_S["需攻击力"]={142,0,2}
Thing_S["需轻功"]={144,0,2}
Thing_S["需用毒能力"]={146,0,2}
Thing_S["需医疗能力"]={148,0,2}
Thing_S["需解毒能力"]={150,0,2}

Thing_S["需拳掌功夫"]={152,0,2}
Thing_S["需御剑能力"]={154,0,2}
Thing_S["需耍刀技巧"]={156,0,2}
Thing_S["需特殊兵器"]={158,0,2}
Thing_S["需暗器技巧"]={160,0,2}

Thing_S["需资质"]={162,0,2}
Thing_S["需经验"]={164,0,2}
Thing_S["练出物品需经验"]={166,0,2}
Thing_S["需材料"]={168,0,2}

for i=1,5 do
    Thing_S["练出物品" .. i]={170+2*(i-1),0,2};
    Thing_S["需要物品数量" .. i]={180+2*(i-1),0,2};
end

Thing = {
    ThingSize=190;   --每个人物数据占用字节
}

function Thing:find (o,id)
    o = o or {}
    local meta_t={
        __index=function(t,k)
            return GetDataFromStruct(JY.Data_Thing,id*self.ThingSize,Thing_S,k);
        end,

        __newindex=function(t,k,v)
            SetDataFromStruct(JY.Data_Thing,id*self.ThingSize,Thing_S,k,v);
        end
    }
    setmetatable(o, meta_t)
    return o
end
