Wugong_S={};
Wugong_S["代号"]={0,0,2}
Wugong_S["名称"]={2,2,10}
Wugong_S["未知1"]={12,0,2}
Wugong_S["未知2"]={14,0,2}
Wugong_S["未知3"]={16,0,2}
Wugong_S["未知4"]={18,0,2}
Wugong_S["未知5"]={20,0,2}
Wugong_S["出招音效"]={22,0,2}
Wugong_S["武功类型"]={24,0,2}
Wugong_S["武功动画&音效"]={26,0,2}
Wugong_S["伤害类型"]={28,0,2}
Wugong_S["攻击范围"]={30,0,2}
Wugong_S["消耗内力点数"]={32,0,2}
Wugong_S["敌人中毒点数"]={34,0,2}

for i=1,10 do
    Wugong_S["攻击力" .. i]={36+2*(i-1),0,2};
    Wugong_S["移动范围" .. i]={56+2*(i-1),0,2};
    Wugong_S["杀伤范围" .. i]={76+2*(i-1),0,2};
    Wugong_S["加内力" .. i]={96+2*(i-1),0,2};
    Wugong_S["杀内力" .. i]={116+2*(i-1),0,2};
end

Wugong = {
    WugongSize=136;   --每个武功数据占用字节
}

function Wugong:find (o,id)
    o = o or {}
    local meta_t={
        __index=function(t,k)
            return GetDataFromStruct(JY.Data_Wugong,id*self.WugongSize,Wugong_S,k);
        end,

        __newindex=function(t,k,v)
            SetDataFromStruct(JY.Data_Wugong,id*self.WugongSize,Wugong_S,k,v);
        end
    }
    setmetatable(o, meta_t)
    return o
end