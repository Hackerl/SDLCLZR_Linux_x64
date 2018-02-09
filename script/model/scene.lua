require(CONFIG.ScriptPath .. "model/data_struct")

Scene_S={};
Scene_S["代号"]={0,0,2}
Scene_S["名称"]={2,2,10}
Scene_S["出门音乐"]={12,0,2}
Scene_S["进门音乐"]={14,0,2}
Scene_S["跳转场景"]={16,0,2}
Scene_S["进入条件"]={18,0,2}
Scene_S["外景入口X1"]={20,0,2}
Scene_S["外景入口Y1"]={22,0,2}
Scene_S["外景入口X2"]={24,0,2}
Scene_S["外景入口Y2"]={26,0,2}
Scene_S["入口X"]={28,0,2}
Scene_S["入口Y"]={30,0,2}
Scene_S["出口X1"]={32,0,2}
Scene_S["出口X2"]={34,0,2}
Scene_S["出口X3"]={36,0,2}
Scene_S["出口Y1"]={38,0,2}
Scene_S["出口Y2"]={40,0,2}
Scene_S["出口Y3"]={42,0,2}
Scene_S["跳转口X1"]={44,0,2}
Scene_S["跳转口Y1"]={46,0,2}
Scene_S["跳转口X2"]={48,0,2}
Scene_S["跳转口Y2"]={50,0,2}

Scene = {
    SceneSize=52;   --每个人物数据占用字节
}

function Scene:find (o,id)
    o = o or {}
    local meta_t={
        __index=function(t,k)
            return GetDataFromStruct(JY.Data_Scene,id*self.SceneSize,Scene_S,k);
        end,

        __newindex=function(t,k,v)
            SetDataFromStruct(JY.Data_Scene,id*self.SceneSize,Scene_S,k,v);
        end
    }
    setmetatable(o, meta_t)
    return o
end