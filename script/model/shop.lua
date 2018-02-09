require(CONFIG.ScriptPath .. "model/data_struct")

Shop_S={};
for i=1,5 do
  Shop_S["物品" .. i]={0+2*(i-1),0,2};
  Shop_S["物品数量" .. i]={10+2*(i-1),0,2};
  Shop_S["物品价格" .. i]={20+2*(i-1),0,2};
end

Shop = {
    ShopSize=30;   --每个小宝商店数据占用字节
}

function Shop:find (o,id)
    o = o or {}
    local meta_t={
        __index=function(t,k)
            return GetDataFromStruct(JY.Data_Shop,id*self.ShopSize,Shop_S,k);
        end,

        __newindex=function(t,k,v)
            SetDataFromStruct(JY.Data_Shop,id*self.ShopSize,Shop_S,k,v);
        end
    }
    setmetatable(o, meta_t)
    return o
end