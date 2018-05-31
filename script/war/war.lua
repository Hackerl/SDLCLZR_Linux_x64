require(CONFIG.ScriptPath .. "war/fight")
require(CONFIG.ScriptPath .. "war/auto")

---------------------------------------------------------------------------
---------------------------------战斗-----------------------------------
--入口函数为WarMain，由战斗指令调用

--设置战斗全程变量
function WarSetGlobal()            --设置战斗全程变量
    WAR={};

    WAR.Data={};              --战斗信息，war.sta文件

    WAR.SelectPerson={}            --设置选择参战人  0 未选，1 选，不可取消，2 选，可取消。选择参展人菜单调用使用

    WAR.Person={};                 --战斗人物信息
    for i=0,26-1 do
        WAR.Person[i]={};
        WAR.Person[i]["人物编号"]=-1;
        WAR.Person[i]["我方"]=true;            --true 我方，false敌人
        WAR.Person[i]["坐标X"]=-1;
        WAR.Person[i]["坐标Y"]=-1;
        WAR.Person[i]["死亡"]=true;
        WAR.Person[i]["人方向"]=-1;
        WAR.Person[i]["贴图"]=-1;
        WAR.Person[i]["贴图类型"]=0;        --0 wmap中贴图，1 fight***中贴图
        WAR.Person[i]["轻功"]=0;
        WAR.Person[i]["移动步数"]=0;
        WAR.Person[i]["点数"]=0;
        WAR.Person[i]["经验"]=0;
        WAR.Person[i]["自动选择对手"]=-1;     --自动战斗中每个人选择的战斗对手
   end

    WAR.PersonNum=0;               --战斗人物个数

    WAR.AutoFight=0;               --我方自动战斗参数 0 手动，1 自动。

    WAR.CurID=-1;                  --当前操作战斗人id

    WAR.ShowHead=0;                --是否显示头像

    WAR.Effect=0;              --效果，用来确认人物头上数字的颜色
                               --2 杀生命 , 3 杀内力, 4 医疗 ， 5 用毒 ， 6 解毒

    WAR.EffectColor={};      ---定义人物头上数字的颜色
    WAR.EffectColor[2]=RGB(236, 200, 40);
    WAR.EffectColor[3]=RGB(112, 12, 112);
    WAR.EffectColor[4]=RGB(236, 200, 40);
    WAR.EffectColor[5]=RGB(96, 176, 64)
    WAR.EffectColor[6]=RGB(104, 192, 232);

    WAR.EffectXY=nil            --保存武功效果产生的坐标
    WAR.EffectXYNum=0;          --坐标个数

end

--加载战斗数据
function WarLoad(warid)              --加载战斗数据
    WarSetGlobal();         --初始化战斗变量
    local data=Byte.create(CC.WarDataSize);      --读取战斗数据
    Byte.loadfile(data,CC.WarFile,warid*CC.WarDataSize,CC.WarDataSize);
    LoadData(WAR.Data,CC.WarData_S,data);
end

--战斗主函数
--warid  战斗编号
--isexp  输后是否有经验 0 没经验，1 有经验
--返回  true 战斗胜利，false 失败
function WarMain(warid,isexp)           --战斗主函数
    lib.Debug(string.format("war start. warid=%d",warid));
    WarLoad(warid);
    WarSelectTeam();          --选择我方
    WarSelectEnemy();         --选择敌人

    CleanMemory()
    lib.PicInit();
    lib.ShowSlow(50,1) ;      --场景变暗

    WarLoadMap(WAR.Data["地图"]);       --加载战斗地图

    JY.Status=GAME_WMAP;

    --加载贴图文件
    lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],0);
    lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
    if CC.LoadThingPic==1 then
        lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],2);
    end
    lib.PicLoadFile(CC.EffectFile[1],CC.EffectFile[2],3);

    PlayMIDI(WAR.Data["音乐"]);

    local first=0;            --第一次显示战斗标记
    local warStatus;          --战斗状态

    WarPersonSort();    --战斗人按轻功排序

    for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["人物编号"];
        lib.PicLoadFile(string.format(CC.FightPicFile[1],JY.Person[pid]["头像代号"]),
                        string.format(CC.FightPicFile[2],JY.Person[pid]["头像代号"]),
                        4+i);
    end

    while true do             --战斗主循环

        for i=0,WAR.PersonNum-1 do
            WAR.Person[i]["贴图"]=WarCalPersonPic(i);
        end
        for i=0,WAR.PersonNum-1 do                ---计算各人的轻功，包括装备加成
            local id=WAR.Person[i]["人物编号"];
            local move=math.modf(WAR.Person[i]["轻功"]/15)-math.modf(JY.Person[id]["受伤程度"]/40);
            if move<0 then
                move=0;
            end
            WAR.Person[i]["移动步数"]=move;
        end

        WarSetPerson();     --设置战斗人物位置

        local p=0;
        while p<WAR.PersonNum do       --每回合战斗循环，每个人轮流战斗
            collectgarbage("step",0);
            WAR.Effect=0;
            if WAR.AutoFight==1 then                 --我方自动战斗时读取键盘，看是否取消
                local keypress=lib.GetKey();
                if keypress==VK_SPACE or keypress==VK_RETURN then
                    WAR.AutoFight=0;
                end
            end


            if WAR.Person[p]["死亡"]==false then

                WAR.CurID=p;

                if first==0 then              --第一次渐亮显示
                    WarDrawMap(0);
                    lib.ShowSlow(50,0)
                    first=1;
                else
--                    WarDrawMap(0);
                    --WarShowHead();
--                    ShowScreen();
                end

                local r;
                if WAR.Person[p]["我方"]==true then
                    if WAR.AutoFight==0 then
                        r=War_Manual();                  --手动战斗
                    else
                        r=War_Auto();                  --自动战斗
                    end
                else
                    r=War_Auto();                  --自动战斗
                end

                warStatus=War_isEnd();        --战斗是否结束？   0继续，1赢，2输

                if math.abs(r)==7 then         --等待
                    p=p-1;
                end

                if warStatus>0 then
                    break;
                end

            end
            p=p+1;
        end

        if warStatus>0 then
            break;
        end

        War_PersonLostLife();

    end

    local r;

    WAR.ShowHead=0;

    if warStatus==1 then
        DrawStrBoxWaitKey("战斗胜利",C_WHITE,CC.DefaultFont);
        r=true;
    elseif warStatus==2 then
        DrawStrBoxWaitKey("战斗失败",C_WHITE,CC.DefaultFont);
        r=false;
    end

    War_EndPersonData(isexp,warStatus);    --战斗后设置人物参数

    lib.ShowSlow(50,1);

    if JY.Scene[JY.SubScene]["进门音乐"]>=0 then
        PlayMIDI(JY.Scene[JY.SubScene]["进门音乐"]);
    else
        PlayMIDI(0);
    end

    CleanMemory();
    lib.PicInit();
    lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],0);
    lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
    if CC.LoadThingPic==1 then
        lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],2);
    end

    JY.Status=GAME_SMAP;

    return r;
end


function War_PersonLostLife()             --计算战斗后每回合由于中毒或受伤而掉血
    for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["人物编号"]
        if WAR.Person[i]["死亡"]==false then
            if JY.Person[pid]["受伤程度"]>0 then
                local dec=math.modf(JY.Person[pid]["受伤程度"]/20);
                AddPersonAttrib(pid,"生命",-dec);
            end
            if JY.Person[pid]["中毒程度"]>0 then
                local dec=math.modf(JY.Person[pid]["中毒程度"]/10);
                AddPersonAttrib(pid,"生命",-dec);
            end
            if JY.Person[pid]["生命"]<=0 then
                JY.Person[pid]["生命"]=1;
            end
        end
    end
end


function War_EndPersonData(isexp,warStatus)            --战斗以后设置人物参数
--敌方人员参数恢复
    for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["人物编号"]
        if WAR.Person[i]["我方"]==false then
            JY.Person[pid]["生命"]=JY.Person[pid]["生命最大值"];
            JY.Person[pid]["内力"]=JY.Person[pid]["内力最大值"];
            JY.Person[pid]["体力"]=CC.PersonAttribMax["体力"];
            JY.Person[pid]["受伤程度"]=0;
            JY.Person[pid]["中毒程度"]=0;
        end
    end

    --我方人员参数恢复，输赢都有
    for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["人物编号"]
        if WAR.Person[i]["我方"]==true then
            if JY.Person[pid]["生命"]<JY.Person[pid]["生命最大值"]/5 then
                JY.Person[pid]["生命"]=math.modf(JY.Person[pid]["生命最大值"]/5);
            end
            if JY.Person[pid]["体力"]<10 then
                JY.Person[pid]["体力"]=10 ;
            end
        end
    end

    if warStatus==2 and isexp==0 then  --输，没有经验，退出
        return ;
    end

    local liveNum=0;          --计算我方活着的人数
    for i=0,WAR.PersonNum-1 do
        if WAR.Person[i]["我方"]==true and JY.Person[WAR.Person[i]["人物编号"]]["生命"]>0  then
            liveNum=liveNum+1;
        end
    end

    --分配战斗经验---基本经验，战斗数据中的
    if warStatus==1 then     --赢了才有
        for i=0,WAR.PersonNum-1 do
            local pid=WAR.Person[i]["人物编号"]
            if WAR.Person[i]["我方"]==true then
                if JY.Person[pid]["生命"]>0 then
                    WAR.Person[i]["经验"]=WAR.Person[i]["经验"] + math.modf(WAR.Data["经验"]/liveNum);
                end
            end
        end
    end


    --每个人经验增加，以及升级
    for i=0,WAR.PersonNum-1 do
        local pid=WAR.Person[i]["人物编号"];
        AddPersonAttrib(pid,"物品修炼点数",math.modf(WAR.Person[i]["经验"]*8/10));
        AddPersonAttrib(pid,"修炼点数",math.modf(WAR.Person[i]["经验"]*8/10));
        AddPersonAttrib(pid,"经验",WAR.Person[i]["经验"]);

        if WAR.Person[i]["我方"]==true then

            DrawStrBoxWaitKey( string.format("%s 获得经验点数 %d",JY.Person[pid]["姓名"],WAR.Person[i]["经验"]),C_WHITE,CC.DefaultFont);

            local r=War_AddPersonLevel(pid);     --人物升级

            if r==true then
                DrawStrBoxWaitKey( string.format("%s 升级了",JY.Person[pid]["姓名"]),C_WHITE,CC.DefaultFont);
            end
        end

        War_PersonTrainBook(pid);            --修炼秘籍
        War_PersonTrainDrug(pid);            --修炼药品
    end
end

--人物是否升级
--pid 人id
--返回 true 升级，false不升级
function War_AddPersonLevel(pid)      --人物是否升级

    local tmplevel=JY.Person[pid]["等级"];
    if tmplevel>=CC.Level then     --级别到顶
        return false;
    end

    if JY.Person[pid]["经验"]<CC.Exp[tmplevel] then     --经验不够升级
        return false
    end

    while true do          --判断可以升几级
        if tmplevel >= CC.Level then
            break;
        end
        if JY.Person[pid]["经验"]>=CC.Exp[tmplevel] then
            tmplevel=tmplevel+1;
        else
            break;
        end
    end
    local leveladd=tmplevel-JY.Person[pid]["等级"];   --升级次数
    JY.Person[pid]["等级"]=JY.Person[pid]["等级"]+leveladd;
    AddPersonAttrib(pid,"生命最大值", (JY.Person[pid]["生命增长"]+Rnd(3))*leveladd*3);
    JY.Person[pid]["生命"]=JY.Person[pid]["生命最大值"];
    JY.Person[pid]["体力"]=CC.PersonAttribMax["体力"];
    JY.Person[pid]["受伤程度"]=0;
    JY.Person[pid]["中毒程度"]=0;

    local cleveradd;
    if JY.Person[pid]["资质"]<30 then
        cleveradd=2;
    elseif JY.Person[pid]["资质"]<50 then
        cleveradd=3;
    elseif JY.Person[pid]["资质"]<70 then
        cleveradd=4;
    elseif JY.Person[pid]["资质"]<90 then
        cleveradd=5;
    else
        cleveradd=6;
    end
    cleveradd=Rnd(cleveradd)+1;        --按照资质计算的增长点，越高则技能增加越多，而内力增加越少。
    AddPersonAttrib(pid,"内力最大值",  (9-cleveradd)*leveladd*4);   --聪明人不练内力
    JY.Person[pid]["内力"]=JY.Person[pid]["内力最大值"];

    AddPersonAttrib(pid,"攻击力",  cleveradd*leveladd);
    AddPersonAttrib(pid,"防御力",  cleveradd*leveladd);
    AddPersonAttrib(pid,"轻功",  cleveradd*leveladd);

    if JY.Person[pid]["医疗能力"]>=20 then
        AddPersonAttrib(pid,"医疗能力",  Rnd(3));
    end
    if JY.Person[pid]["用毒能力"]>=20 then
        AddPersonAttrib(pid,"用毒能力",  Rnd(3));
    end
    if JY.Person[pid]["解毒能力"]>=20 then
        AddPersonAttrib(pid,"解毒能力",  Rnd(3));
    end
    if JY.Person[pid]["拳掌功夫"]>=20 then
        AddPersonAttrib(pid,"拳掌功夫",  Rnd(3));
    end
    if JY.Person[pid]["御剑能力"]>=20 then
        AddPersonAttrib(pid,"御剑能力",  Rnd(3));
    end
    if JY.Person[pid]["耍刀技巧"]>=20 then
        AddPersonAttrib(pid,"耍刀技巧",  Rnd(3));
    end
    if JY.Person[pid]["暗器技巧"]>=20 then
        AddPersonAttrib(pid,"暗器技巧",  Rnd(3));
    end

    return true;

end

--修炼秘籍
function War_PersonTrainBook(pid)           --战斗后修炼秘籍是否成功
    local p=JY.Person[pid];

    local thingid=p["修炼物品"];
    if thingid<0 then
        return ;
    end

    local wugongid=JY.Thing[thingid]["练出武功"];

    local needpoint=TrainNeedExp(pid);      --计算修炼成功需要点数

    if p["修炼点数"]>=needpoint then   --修炼成功

        DrawStrBoxWaitKey( string.format("%s 修炼 %s 成功",p["姓名"],JY.Thing[thingid]["名称"]),C_WHITE,CC.DefaultFont);

        AddPersonAttrib(pid,"生命最大值",JY.Thing[thingid]["加生命最大值"]);
        if JY.Thing[thingid]["改变内力性质"]==2 then
            p["内力性质"]=2;
        end
        AddPersonAttrib(pid,"内力最大值",JY.Thing[thingid]["加内力最大值"]);
        AddPersonAttrib(pid,"攻击力",JY.Thing[thingid]["加攻击力"]);
        AddPersonAttrib(pid,"轻功",JY.Thing[thingid]["加轻功"]);
        AddPersonAttrib(pid,"防御力",JY.Thing[thingid]["加防御力"]);
        AddPersonAttrib(pid,"医疗能力",JY.Thing[thingid]["加医疗能力"]);
        AddPersonAttrib(pid,"用毒能力",JY.Thing[thingid]["加用毒能力"]);
        AddPersonAttrib(pid,"解毒能力",JY.Thing[thingid]["加解毒能力"]);
        AddPersonAttrib(pid,"抗毒能力",JY.Thing[thingid]["加抗毒能力"]);
        AddPersonAttrib(pid,"拳掌功夫",JY.Thing[thingid]["加拳掌功夫"]);
        AddPersonAttrib(pid,"御剑能力",JY.Thing[thingid]["加御剑能力"]);
        AddPersonAttrib(pid,"耍刀技巧",JY.Thing[thingid]["加耍刀技巧"]);
        AddPersonAttrib(pid,"特殊兵器",JY.Thing[thingid]["加特殊兵器"]);
        AddPersonAttrib(pid,"暗器技巧",JY.Thing[thingid]["加暗器技巧"]);
        AddPersonAttrib(pid,"武学常识",JY.Thing[thingid]["加武学常识"]);
        AddPersonAttrib(pid,"品德",JY.Thing[thingid]["加品德"]);
        AddPersonAttrib(pid,"攻击带毒",JY.Thing[thingid]["加攻击带毒"]);
        if JY.Thing[thingid]["加攻击次数"]==1 then
            p["左右互搏"]=1;
        end

        p["修炼点数"]=0;

        if wugongid>=0 then
            local oldwugong=0;
            for i =1,10 do
                if p["武功" .. i]==wugongid then
                    oldwugong=1;
                    p["武功等级" .. i]=p["武功等级" .. i]+100;

                    DrawStrBoxWaitKey(string.format("%s 升为第%s级",JY.Wugong[wugongid]["名称"],math.modf(p["武功等级" ..i]/100)+1),C_WHITE,CC.DefaultFont);

                    break;
                end
            end
            if oldwugong==0 then  --新的武功
                for i=1,10 do
                    if p["武功" .. i]==0 then
                        p["武功" .. i]=wugongid;
                        break;
                    end
                end
                ---这里不考虑10个武功已满的时候如何增加新的武功
            end
        end
    end
end

--练出药品
function War_PersonTrainDrug(pid)         --战斗后是否修炼出物品
    local p=JY.Person[pid];

    local thingid=p["修炼物品"];
    if thingid<0 then
        return ;
    end

    if JY.Thing[thingid]["练出物品需经验"] <=0 then          --不可以修炼出物品
        return ;
    end

    local needpoint=(7-math.modf(p["资质"]/15))*JY.Thing[thingid]["练出物品需经验"];
    if p["物品修炼点数"]< needpoint then
        return ;
    end

    local haveMaterial=0;       --是否有需要的材料
    local MaterialNum=-1;
    for i=1,CC.MyThingNum do
        if JY.Base["物品" .. i]==JY.Thing[thingid]["需材料"] then
            haveMaterial=1;
            MaterialNum=JY.Base["物品数量" .. i]
            break;
        end
    end

    if haveMaterial==1 then   --有材料
        local enough={};
        local canMake=0;
        for i=1,5 do       --根据需要材料的数量，标记可以练出哪些物品
            if JY.Thing[thingid]["练出物品" .. i] >=0 and MaterialNum >= JY.Thing[thingid]["需要物品数量" .. i] then
                canMake=1;
                enough[i]=1;
            else
                enough[i]=0;
            end
        end

        if canMake ==1 then    --可练出物品
            local makeID;
            while true do      --随机选择练出的物品，必须是前面enough数组中标记可以练出的
                makeID=Rnd(5)+1;
                if enough[makeID]==1 then
                    break;
                end
            end
            local newThingID=JY.Thing[thingid]["练出物品" .. makeID];

            DrawStrBoxWaitKey(string.format("%s 制造出 %s",p["姓名"],JY.Thing[newThingID]["名称"]),C_WHITE,CC.DefaultFont);

            if instruct_18(newThingID)==true then       --已经有物品
                instruct_32(newThingID,1);
            else
                instruct_32(newThingID,1+Rnd(3));
            end

            instruct_32(JY.Thing[thingid]["需材料"],-JY.Thing[thingid]["需要物品数量" .. makeID]);
            p["物品修炼点数"]=0;
        end
    end
end

--战斗是否结束
--返回：0 继续   1 赢    2 输
function War_isEnd()           --战斗是否结束

    for i=0,WAR.PersonNum-1 do
        if JY.Person[WAR.Person[i]["人物编号"]]["生命"]<=0 then
            WAR.Person[i]["死亡"]=true;
        end
    end
    WarSetPerson();     --设置战斗人物位置

    Cls();
    ShowScreen();

    local myNum=0;
    local EmenyNum=0;
    for i=0,WAR.PersonNum-1 do
        if WAR.Person[i]["死亡"]==false then
            if WAR.Person[i]["我方"]==true then
                myNum=1;
            else
                EmenyNum=1;
            end
        end
    end

    if EmenyNum==0 then
        return 1;
    end
    if myNum==0 then
        return 2;
    end
    return 0;
end

--选择我方参战人
function WarSelectTeam()            --选择我方参战人
    WAR.PersonNum=0;

    for i=1,6 do
        local id=WAR.Data["自动选择参战人" .. i];
        if id>=0 then
            WAR.Person[WAR.PersonNum]["人物编号"]=id;
            WAR.Person[WAR.PersonNum]["我方"]=true;
            WAR.Person[WAR.PersonNum]["坐标X"]=WAR.Data["我方X"  .. i];
            WAR.Person[WAR.PersonNum]["坐标Y"]=WAR.Data["我方Y"  .. i];
            WAR.Person[WAR.PersonNum]["死亡"]=false;
            WAR.Person[WAR.PersonNum]["人方向"]=2;
            WAR.PersonNum=WAR.PersonNum+1;
        end
    end
    if WAR.PersonNum>0 then
        return ;
    end

    for i=1,CC.TeamNum do                 --设置事先确定的参战人
        WAR.SelectPerson[i]=0;
        local id=JY.Base["队伍" .. i];
        if id>=0 then
            for j=1,6 do
                if WAR.Data["手动选择参战人" .. j]==id then
                    WAR.SelectPerson[i]=1;
                end
            end
        end
    end

    local menu={};
    for i=1, CC.TeamNum do
        menu[i]={"",WarSelectMenu,0};
        local id=JY.Base["队伍" .. i];
        if id>=0 then
            menu[i][3]=1;
            local s=JY.Person[id]["姓名"];
            if WAR.SelectPerson[i]==1 then
                menu[i][1]="*" .. s;
            else
                menu[i][1]=" " .. s;
            end
        end
    end

    menu[CC.TeamNum+1]={" 结束",nil,1}

    while true do
        Cls();
        local x=(CC.ScreenW-7*CC.DefaultFont-2*CC.MenuBorderPixel)/2;
        DrawStrBox(x,10,"请选择参战人物",C_WHITE,CC.DefaultFont);
        local r=ShowMenu(menu,CC.TeamNum+1,0,x,10+CC.SingleLineHeight,0,0,1,0,CC.DefaultFont,C_ORANGE,C_WHITE);
        Cls();

        for i=1,6 do
            if WAR.SelectPerson[i]>0 then
                WAR.Person[WAR.PersonNum]["人物编号"]=JY.Base["队伍" ..i];
                WAR.Person[WAR.PersonNum]["我方"]=true;
                WAR.Person[WAR.PersonNum]["坐标X"]=WAR.Data["我方X"  .. i];
                WAR.Person[WAR.PersonNum]["坐标Y"]=WAR.Data["我方Y"  .. i];
                WAR.Person[WAR.PersonNum]["死亡"]=false;
                WAR.Person[WAR.PersonNum]["人方向"]=2;
                WAR.PersonNum=WAR.PersonNum+1;
            end
        end
        if WAR.PersonNum>0 then   --选择了我方参战人
           break;
        end
    end
end


--选中战斗人菜单调用函数
function WarSelectMenu(newmenu,newid)            --选择战斗人菜单调用函数
    local id=newmenu[newid][4];

    if WAR.SelectPerson[id]==0 then
        WAR.SelectPerson[id]=2;
    elseif WAR.SelectPerson[id]==2 then
        WAR.SelectPerson[id]=0;
    end

    if WAR.SelectPerson[id]>0 then
        newmenu[newid][1]="*" .. string.sub(newmenu[newid][1],2);
    else
        newmenu[newid][1]=" " .. string.sub(newmenu[newid][1],2);
    end
    return 0;
end

--选择敌方参战人
function WarSelectEnemy()            --选择敌方参战人
    for i=1,20 do
        if WAR.Data["敌人"  .. i]>0 then
            WAR.Person[WAR.PersonNum]["人物编号"]=WAR.Data["敌人"  .. i];
            WAR.Person[WAR.PersonNum]["我方"]=false;
            WAR.Person[WAR.PersonNum]["坐标X"]=WAR.Data["敌方X"  .. i];
            WAR.Person[WAR.PersonNum]["坐标Y"]=WAR.Data["敌方Y"  .. i];
            WAR.Person[WAR.PersonNum]["死亡"]=false;
            WAR.Person[WAR.PersonNum]["人方向"]=1;
            WAR.PersonNum=WAR.PersonNum+1;
        end
    end
end

--加载战斗地图
--共6层，包括了工作用地图
--        0层 地面数据
--        1层 建筑
--以上为战斗地图数据，从战斗文件中载入。下面为工作用的地图结构
--        2层 战斗人战斗编号，即WAR.Person的编号
--        3层 移动时显示可移动的位置
--        4层 命中效果
--        5层 战斗人对应的贴图

function WarLoadMap(mapid)      --加载战斗地图
   lib.Debug(string.format("load war map %d",mapid));
   lib.LoadWarMap(CC.WarMapFile[1],CC.WarMapFile[2],mapid,6,CC.WarWidth,CC.WarHeight);
end

function GetWarMap(x,y,level)   --取战斗地图数据
     return lib.GetWarMap(x,y,level);
end

function SetWarMap(x,y,level,v)  --存战斗地图数据
    lib.SetWarMap(x,y,level,v);
end

--设置某层为给定值
function CleanWarMap(level,v)
    lib.CleanWarMap(level,v);
end


--绘战斗地图
--flag==0 基本
--      1 显示移动路径 (v1,v2) 当前移动位置
--      2 命中人物（武功，医疗等）另一个颜色显示
--      4 战斗动画, v1 战斗人物pic, v2战斗人物贴图类型(0 使用战斗场景贴图，4，fight***贴图编号 v3 武功效果贴图 -1没有效果

function WarDrawMap(flag,v1,v2,v3)
    local x=WAR.Person[WAR.CurID]["坐标X"];
    local y=WAR.Person[WAR.CurID]["坐标Y"];

    if flag==0 then
        lib.DrawWarMap(0,x,y,0,0,-1);
    elseif flag==1 then
        if WAR.Data["地图"]==0 then     --雪地地图用黑色菱形
            lib.DrawWarMap(1,x,y,v1,v2,-1);
        else
            lib.DrawWarMap(2,x,y,v1,v2,-1);
        end
    elseif flag==2 then
        lib.DrawWarMap(3,x,y,0,0,-1);
    elseif flag==4 then
        lib.DrawWarMap(4,x,y,v1,v2,v3);
    end
    if WAR.ShowHead==1 then
        WarShowHead();
    end
end


function WarPersonSort()               --战斗人物按轻功排序
    for i=0,WAR.PersonNum-1 do                ---计算各人的轻功，包括装备加成
        local id=WAR.Person[i]["人物编号"];
        local add=0;
        if JY.Person[id]["武器"]>-1 then
            add=add+JY.Thing[JY.Person[id]["武器"]]["加轻功"];
        end
        if JY.Person[id]["防具"]>-1 then
            add=add+JY.Thing[JY.Person[id]["防具"]]["加轻功"];
        end
        WAR.Person[i]["轻功"]=JY.Person[id]["轻功"]+add;
        local move=math.modf(WAR.Person[i]["轻功"]/15)-math.modf(JY.Person[id]["受伤程度"]/40);
        if move<0 then
            move=0;
        end
        WAR.Person[i]["移动步数"]=move;
    end

    --按轻功排序，用比较笨的方法
    for i=0,WAR.PersonNum-2 do
        local maxid=i;
        for j=i,WAR.PersonNum-1 do
            if WAR.Person[j]["轻功"]>WAR.Person[maxid]["轻功"] then
                maxid=j;
            end
        end
        WAR.Person[maxid],WAR.Person[i]=WAR.Person[i],WAR.Person[maxid];
    end
end

--设置战斗人物位置和贴图
function WarSetPerson()            --设置战斗人物位置
    CleanWarMap(2,-1);
    CleanWarMap(5,-1);

    for i=0,WAR.PersonNum-1 do
        if WAR.Person[i]["死亡"]==false then
            SetWarMap(WAR.Person[i]["坐标X"],WAR.Person[i]["坐标Y"],2,i);
            SetWarMap(WAR.Person[i]["坐标X"],WAR.Person[i]["坐标Y"],5,WAR.Person[i]["贴图"]);
        end
    end
end


function WarCalPersonPic(id)       --计算战斗人物贴图
    local n=5106;            --战斗人物贴图起始位置
    n=n+JY.Person[WAR.Person[id]["人物编号"]]["头像代号"]*8+WAR.Person[id]["人方向"]*2;
    return n;
end