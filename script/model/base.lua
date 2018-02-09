require(CONFIG.ScriptPath .. "model/data_struct")
   --定义记录文件R×结构。  lua不支持结构，无法直接从二进制文件中读取，因此需要这些定义，用table中不同的名字来仿真结构。
Base_S={};         --保存基本数据的结构，以便以后存取
Base_S["乘船"]={0,0,2}   -- 起始位置(从0开始)，数据类型(0有符号 1无符号，2字符串)，长度
Base_S["无用"]={2,0,2};
Base_S["人X"]={4,0,2};
Base_S["人Y"]={6,0,2};
Base_S["人X1"]={8,0,2};
Base_S["人Y1"]={10,0,2};
Base_S["人方向"]={12,0,2};
Base_S["船X"]={14,0,2};
Base_S["船Y"]={16,0,2};
Base_S["船X1"]={18,0,2};
Base_S["船Y1"]={20,0,2};
Base_S["船方向"]={22,0,2};

for i=1,CC.TeamNum do
    Base_S["队伍" .. i]={24+2*(i-1),0,2};
end

for i=1,CC.MyThingNum do
    Base_S["物品" .. i]={36+4*(i-1),0,2};
    Base_S["物品数量" .. i]={36+4*(i-1)+2,0,2};
end

Base = {
}

function Base:new (o)
    o = o or {}
    --设置访问基本数据的方法，这样就可以用访问表的方式访问了。而不用把二进制数据转化为表。节约加载时间和空间
    local meta_t={
        __index=function(t,k)
            return GetDataFromStruct(JY.Data_Base,0,Base_S,k);
        end,
        __newindex=function(t,k,v)
            SetDataFromStruct(JY.Data_Base,0,Base_S,k,v);
        end
    }
    setmetatable(o, meta_t)
    return o
end