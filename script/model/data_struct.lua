--从数据的结构中翻译数据
--data 二进制数组
--offset data中的偏移
--t_struct 数据的结构，在jyconst中有很多定义
--key  访问的key
function GetDataFromStruct(data,offset,t_struct,key)  --从数据的结构中翻译数据，用来取数据
    local t=t_struct[key];
    local r;
    if t[2]==0 then
        r=Byte.get16(data,t[1]+offset);
    elseif t[2]==1 then
        r=Byte.getu16(data,t[1]+offset);
    elseif t[2]==2 then
        if CC.SrcCharSet==0 then
            r=change_charsert(Byte.getstr(data,t[1]+offset,t[3]),0);
        else
            r=Byte.getstr(data,t[1]+offset,t[3]);
        end
    end
    return r;
end

function SetDataFromStruct(data,offset,t_struct,key,v)  --从数据的结构中翻译数据，保存数据
    local t=t_struct[key];
    if t[2]==0 then
        Byte.set16(data,t[1]+offset,v);
    elseif t[2]==1 then
        Byte.setu16(data,t[1]+offset,v);
    elseif t[2]==2 then
        local s;
        if CC.SrcCharSet==0 then
            s=change_charsert(v,1);
        else
            s=v;
        end
        Byte.setstr(data,t[1]+offset,t[3],s);
    end
end