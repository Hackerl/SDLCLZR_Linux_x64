-- record
-- 读取游戏进度
-- id=0 新进度，=1/2/3 进度
--
--这里是先把数据读入Byte数组中。然后定义访问相应表的方法，在访问表时直接从数组访问。
--与以前的实现相比，从文件中读取和保存到文件的时间显著加快。而且内存占用少了
require(CONFIG.ScriptPath .. "model/data_struct");
require(CONFIG.ScriptPath .. "model/person");
require(CONFIG.ScriptPath .. "model/thing");
require(CONFIG.ScriptPath .. "model/scene");
require(CONFIG.ScriptPath .. "model/base");
require(CONFIG.ScriptPath .. "model/wugong");
require(CONFIG.ScriptPath .. "model/shop");

function LoadRecord(id)       -- 读取游戏进度
    local t1=lib.GetTime();

    --读取R*.idx文件
    local data=Byte.create(6*4);
    Byte.loadfile(data,CC.R_IDXFilename[id],0,6*4);

    -- 读取5部分数据开始偏移
    local idx={};
    idx[0]=0;
    for i =1,6 do
        idx[i]=Byte.get32(data,4*(i-1));
    end

    --读取R*.grp文件
    -- 读取Base数据
    JY.Data_Base=Byte.create(idx[1]-idx[0]);              --基本数据
    Byte.loadfile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0]);
    JY.Base = Base:new(nil)


    -- 读取人物数据
    JY.PersonNum=math.floor((idx[2]-idx[1])/Person.PersonSize);   --人物
    JY.Data_Person=Byte.create(Person.PersonSize*JY.PersonNum);
    Byte.loadfile(JY.Data_Person,CC.R_GRPFilename[id],idx[1],Person.PersonSize*JY.PersonNum);
    local meta_t={
        __index=function(t,k)
            return Person:find(nil,k);
        end
    }
    setmetatable(JY.Person, meta_t);


    -- 读取物品数据
    JY.ThingNum=math.floor((idx[3]-idx[2])/Thing.ThingSize);     --物品
    JY.Data_Thing=Byte.create(Thing.ThingSize*JY.ThingNum);
    Byte.loadfile(JY.Data_Thing,CC.R_GRPFilename[id],idx[2],Thing.ThingSize*JY.ThingNum);
    local meta_t={
        __index=function(t,k)
            return Thing:find(nil,k);
        end
    }
    setmetatable(JY.Thing, meta_t);


    -- 读取场景数据
    JY.SceneNum=math.floor((idx[4]-idx[3])/Scene.SceneSize);     --场景
    JY.Data_Scene=Byte.create(Scene.SceneSize*JY.SceneNum);
    Byte.loadfile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],Scene.SceneSize*JY.SceneNum);
    local meta_t={
        __index=function(t,k)
            return Scene:find(nil,k);
        end
    }
    setmetatable(JY.Scene,meta_t);


    -- 读取武功数据
    JY.WugongNum=math.floor((idx[5]-idx[4])/Wugong.WugongSize);     --武功
    JY.Data_Wugong=Byte.create(Wugong.WugongSize*JY.WugongNum);
    Byte.loadfile(JY.Data_Wugong,CC.R_GRPFilename[id],idx[4],Wugong.WugongSize*JY.WugongNum);
    local meta_t={
        __index=function(t,k)
            return Wugong:find(nil,k);
        end
    }
    setmetatable(JY.Wugong, meta_t);


    -- 商店数据
    JY.ShopNum=math.floor((idx[6]-idx[5])/Shop.ShopSize);     --小宝商店
    JY.Data_Shop=Byte.create(Shop.ShopSize*JY.ShopNum);
    Byte.loadfile(JY.Data_Shop,CC.R_GRPFilename[id],idx[5],Shop.ShopSize*JY.ShopNum);
    local meta_t={
        __index=function(t,k)
            return Shop:find(nil,k);
        end
    }
    setmetatable(JY.Shop,meta_t);


    lib.LoadSMap(CC.S_Filename[id],CC.TempS_Filename,JY.SceneNum,CC.SWidth,CC.SHeight,CC.D_Filename[id],CC.DNum,11);
    collectgarbage();

    lib.Debug(string.format("Loadrecord time=%d",lib.GetTime()-t1));
end

-- 写游戏进度
-- id=0 新进度，=1/2/3 进度
function SaveRecord(id)         -- 写游戏进度
    --读取R*.idx文件
    local t1=lib.GetTime();

    local data=Byte.create(6*4);
    Byte.loadfile(data,CC.R_IDXFilename[id],0,6*4);

    local idx={};
    idx[0]=0;
    for i =1,6 do
        idx[i]=Byte.get32(data,4*(i-1));
    end

    --写R*.grp文件
    Byte.savefile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0]);
    Byte.savefile(JY.Data_Person,CC.R_GRPFilename[id],idx[1],Person.PersonSize*JY.PersonNum);
    Byte.savefile(JY.Data_Thing,CC.R_GRPFilename[id],idx[2],Thing.ThingSize*JY.ThingNum);
    Byte.savefile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],Scene.SceneSize*JY.SceneNum);
    Byte.savefile(JY.Data_Wugong,CC.R_GRPFilename[id],idx[4],Wugong.WugongSize*JY.WugongNum);
    Byte.savefile(JY.Data_Shop,CC.R_GRPFilename[id],idx[5],Shop.ShopSize*JY.ShopNum);

    lib.SaveSMap(CC.S_Filename[id],CC.D_Filename[id]);
    lib.Debug(string.format("SaveRecord time=%d",lib.GetTime()-t1));

end


