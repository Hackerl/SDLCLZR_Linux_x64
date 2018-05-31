--测试指令，占位置用
function instruct_test(s)
    DrawStrBoxWaitKey(s,C_ORANGE,24);
end

--清屏
function instruct_0()         --清屏
    Cls();
end

--对话
--talkid: 为数字，则为对话编号；为字符串，则为对话本身。
--headid: 头像id
--flag :对话框位置：0 屏幕上方显示, 左边头像，右边对话
--            1 屏幕下方显示, 左边对话，右边头像
--            2 屏幕上方显示, 左边空，右边对话
--            3 屏幕下方显示, 左边对话，右边空
--            4 屏幕上方显示, 左边对话，右边头像
--            5 屏幕下方显示, 左边头像，右边对话

function instruct_1(talkid,headid,flag)        --对话
    local s=ReadTalk(talkid);
    if s==nil then        --对话id不存在
        return ;
    end
    TalkEx(s,headid,flag);
end

--根据oldtalk.grp文件来idx索引文件。供后面读对话使用
function GenTalkIdx()         --生成对话索引文件
    os.remove(CC.TalkIdxFile);
    local p=io.open(CC.TalkIdxFile,"w");
    p:close();

    p=io.open(CC.TalkGrpFile,"r");
    local num=0
    for line in p:lines() do
        num=num+1;
    end
    p:seek("set",0);
    local data=Byte.create(num*4);

    for i=0,num-1 do
        local talk=p:read("*line");
        local offset=p:seek();
        Byte.set32(data,i*4,offset);
    end
    p:close();

    Byte.savefile(data,CC.TalkIdxFile,0,num*4);
end

--从old_talk.lua中读取编号为talkid的字符串。
--需要的时候读取，可以节约内存占用，不用再把整个文件读入内存数据了。
function ReadTalk(talkid)            --从文件读取一条对话
    local idxfile=CC.TalkIdxFile
    local grpfile=CC.TalkGrpFile

    local length=filelength(idxfile);

    if talkid<0 and talkid>=length/4 then
        return
    end

    local data=Byte.create(2*4);
    local id1,id2;
    if talkid==0 then
        Byte.loadfile(data,idxfile,0,4);
        id1=0;
        id2=Byte.get32(data,0);
    else
        Byte.loadfile(data,idxfile,(talkid-1)*4,4*2);
        id1=Byte.get32(data,0);
        id2=Byte.get32(data,4);
    end

    local p=io.open(grpfile,"r");
    p:seek("set",id1);
    local talk=p:read("*line");
    p:close();

    return talk;

end

--得到物品
function instruct_2(thingid,num)            --得到物品
    if JY.Thing[thingid]==nil then   --无此物品id
        return ;
    end

    instruct_32(thingid,num);    --增加物品
    DrawStrBoxWaitKey(string.format("得到物品:%s %d",JY.Thing[thingid]["名称"],num),C_ORANGE,CC.DefaultFont);
    instruct_2_sub();         --是否可得武林帖
end

--声望>200以及14天书后得到武林帖
function instruct_2_sub()               --声望>200以及14天书后得到武林帖

    if JY.Person[0]["声望"] < 200 then
        return ;
    end

    if instruct_18(189) ==true then            --有武林帖， 189 武林帖id
        return;
    end

    local booknum=0;
    for i=1,CC.BookNum do
        if instruct_18(CC.BookStart+i-1)==true then
            booknum=booknum+1;
        end
    end

    if booknum==CC.BookNum then        --设置主角居桌子上的武林帖事件
        instruct_3(70,11,-1,1,932,-1,-1,7968,7968,7968,-2,-2,-2);
    end
end

--修改D*
-- sceneid 场景id, -2表示当前场景
-- id  D*的id， -2表示当前id
-- v0 - v10 D*参数， -2表示此参数不变
function instruct_3(sceneid,id,v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10)     --修改D*
    if sceneid==-2 then
        sceneid=JY.SubScene;
    end
    if id==-2 then
        id=JY.CurrentD;
    end

    if v0~=-2 then
        SetD(sceneid,id,0,v0)
    end
    if v1~=-2 then
        SetD(sceneid,id,1,v1)
    end
    if v2~=-2 then
        SetD(sceneid,id,2,v2)
    end
    if v3~=-2 then
        SetD(sceneid,id,3,v3)
    end
    if v4~=-2 then
        SetD(sceneid,id,4,v4)
    end
    if v5~=-2 then
        SetD(sceneid,id,5,v5)
    end
    if v6~=-2 then
        SetD(sceneid,id,6,v6)
    end
    if v7~=-2 then
        SetD(sceneid,id,7,v7)
    end
    if v8~=-2 then
        SetD(sceneid,id,8,v8)
    end

    if v9~=-2 and v10 ~=-2 then
        if v9>0 and v10 >0 then   --为了和苍龙兼容，修改的坐标不能为0
            SetS(sceneid,GetD(sceneid,id,9),GetD(sceneid,id,10),3,-1);   --如果xy坐标移动了，那么S中相应数据要修改。
            SetD(sceneid,id,9,v9)
            SetD(sceneid,id,10,v10)
            SetS(sceneid,GetD(sceneid,id,9),GetD(sceneid,id,10),3,id);
        end
    end
end

--是否使用物品触发
function instruct_4(thingid)         --是否使用物品触发
    if JY.CurrentThing==thingid then
        return true;
    else
        return false;
    end
end


function instruct_5()         --选择战斗
    return DrawStrBoxYesNo(-1,-1,"是否与之过招(Y/N)?",C_ORANGE,CC.DefaultFont);
end


function instruct_6(warid,tmp,tmp,flag)      --战斗
    return WarMain(warid,flag);
end


function instruct_7()                 --已经翻译为return了
    instruct_test("指令7测试")
end


function instruct_8(musicid)            --改变主地图音乐
    JY.MmapMusic=musicid;
end


function instruct_9()                --是否要求加入队伍
    Cls();
    return DrawStrBoxYesNo(-1,-1,"是否要求加入(Y/N)?",C_ORANGE,CC.DefaultFont);
end


function instruct_10(personid)            --加入队员
    if JY.Person[personid]==nil then
        lib.Debug("instruct_10 error: person id not exist");
        return ;
    end
    local add=0;
    for i =2, CC.TeamNum do             --第一个位置是主角，从第二个开始
        if JY.Base["队伍"..i]<0 then
            JY.Base["队伍"..i]=personid;
            add=1;
            break;
        end
    end
    if add==0 then
        lib.Debug("instruct_10 error: 加入队伍已满");
        return ;
    end

    for i =1,4 do                --个人物品归公
        local id =JY.Person[personid]["携带物品" .. i];
        local n=JY.Person[personid]["携带物品数量" .. i];
        if id>=0 and n>0 then
            instruct_2(id,n);
            JY.Person[personid]["携带物品" .. i]=-1;
            JY.Person[personid]["携带物品数量" .. i]=0;
        end
    end
end


function instruct_11()              --是否住宿
    Cls();
    return DrawStrBoxYesNo(-1,-1,"是否住宿(Y/N)?",C_ORANGE,CC.DefaultFont);
end


function instruct_12()             --住宿，回复体力
    for i=1,CC.TeamNum do
        local id=JY.Base["队伍" .. i];
        if id>=0 then
            if JY.Person[id]["受伤程度"]<33 and JY.Person[id]["中毒程度"]<=0 then
                JY.Person[id]["受伤程度"]=0;
                AddPersonAttrib(id,"体力",math.huge);     --给一个很大的值，自动限制为最大值
                AddPersonAttrib(id,"生命",math.huge);
                AddPersonAttrib(id,"内力",math.huge);
            end
        end
    end
end


function instruct_13()            --场景变亮
    Cls();
    JY.Darkness=0;
    lib.ShowSlow(50,0)
    lib.GetKey();
end


function instruct_14()             --场景变黑
    lib.ShowSlow(50,1);
    JY.Darkness=1;
end

function instruct_15()          --game over
    JY.Status=GAME_DEAD;
    Cls();
    DrawString(CC.GameOverX,CC.GameOverY,JY.Person[0]["姓名"],RGB(0,0,0),CC.DefaultFont);

    local x=CC.ScreenW-9*CC.DefaultFont;
    DrawString(x,10,os.date("%Y-%m-%d %H:%M"),RGB(216, 20, 24) ,CC.DefaultFont);
    DrawString(x,10+CC.DefaultFont+CC.RowPixel,"在地球的某处",RGB(216, 20, 24) ,CC.DefaultFont);
    DrawString(x,10+(CC.DefaultFont+CC.RowPixel)*2,"当地人口的失踪数",RGB(216, 20, 24) ,CC.DefaultFont);
    DrawString(x,10+(CC.DefaultFont+CC.RowPixel)*3,"又多了一笔。。。",RGB(216, 20, 24) ,CC.DefaultFont);

    local loadMenu={ {"载入进度一",nil,1},
                     {"载入进度二",nil,1},
                     {"载入进度三",nil,1},
                     {"回家睡觉去",nil,1} };
    local y=CC.ScreenH-4*(CC.DefaultFont+CC.RowPixel)-10;
    local r=ShowMenu(loadMenu,4,0,x,y,0,0,0,0,CC.DefaultFont,C_ORANGE, C_WHITE)

    if r<4 then
        LoadRecord(r);
        JY.Status=GAME_FIRSTMMAP;
    else
        JY.Status=GAME_END;
    end

end


function instruct_16(personid)      --队伍中是否有某人
    local r=false;
    for i = 1, CC.TeamNum do
        if personid==JY.Base["队伍" .. i] then
            r=true;
            break;
        end
    end;
    return r;
end


function instruct_17(sceneid,level,x,y,v)     --修改场景图形
    if sceneid==-2 then
        sceneid=JY.SubScene;
    end
    SetS(sceneid,x,y,level,v);
end


function instruct_18(thingid)           --是否有某种物品
    for i = 1,CC.MyThingNum do
        if JY.Base["物品" .. i]==thingid then
            return true;
        end
    end
    return false;
end


function instruct_19(x,y)             --改变主角位置
    JY.Base["人X1"]=x;
    JY.Base["人Y1"]=y;
    JY.SubSceneX=0;
    JY.SubSceneY=0;
end


function instruct_20()                 --判断队伍是否满
    if JY.Base["队伍" .. CC.TeamNum ] >=0 then
        return true;
    end
    return false;
end


function instruct_21(personid)               --离队
    if JY.Person[personid]==nil then
        lib.Debug("instruct_21 error: personid not exist");
        return ;
    end
    local j=0;
    for i = 1, CC.TeamNum do
        if personid==JY.Base["队伍" .. i] then
            j=i;
            break;
        end
    end;
    if j==0 then
       return;
    end

    for  i=j+1,CC.TeamNum do
        JY.Base["队伍" .. i-1]=JY.Base["队伍" .. i];
    end
    JY.Base["队伍" .. CC.TeamNum]=-1;

    if JY.Person[personid]["武器"]>=0 then
        JY.Thing[JY.Person[personid]["武器"]]["使用人"]=-1;
        JY.Person[personid]["武器"]=-1
    end
    if JY.Person[personid]["防具"]>=0 then
        JY.Thing[JY.Person[personid]["防具"]]["使用人"]=-1;
        JY.Person[personid]["防具"]=-1;
    end

    if JY.Person[personid]["修炼物品"]>=0 then
        JY.Thing[JY.Person[personid]["修炼物品"]]["使用人"]=-1;
        JY.Person[personid]["修炼物品"]=-1;
    end

    JY.Person[personid]["修炼点数"]=0;
    JY.Person[personid]["物品修炼点数"]=0;
end


function instruct_22()            --内力降为0
    for i = 1, CC.TeamNum do
        if JY.Base["队伍" .. i] >=0 then
            JY.Person[JY.Base["队伍" .. i]]["内力"]=0;
        end
    end
end


function instruct_23(personid,value)           --设置用毒
    JY.Person[personid]["用毒能力"]=value;
    AddPersonAttrib(personid,"用毒能力",0)
end

--空指令
function instruct_24()
    instruct_test("指令24测试")
end

--场景移动
--为简化，实际上是场景移动(x2-x1)，(y2-y1)。先y后x。因此，x1,y1可设为0
function instruct_25(x1,y1,x2,y2)             --场景移动
    local sign;
    if y1 ~= y2 then
        if y2<y1 then
            sign=-1;
        else
            sign=1;
        end
        for i=y1+sign,y2,sign do
            local t1=lib.GetTime();
            JY.SubSceneY=JY.SubSceneY+sign;
            --JY.oldSMapX=-1;
            --JY.oldSMapY=-1;
            DrawSMap();
            ShowScreen();
            local t2=lib.GetTime();
            if (t2-t1)<CC.SceneMoveFrame then
                lib.Delay(CC.SceneMoveFrame-(t2-t1));
            end
        end
    end

    if x1 ~= x2 then
        if x2<x1 then
            sign=-1;
        else
            sign=1;
        end
        for i=x1+sign,x2,sign do
            local t1=lib.GetTime();
            JY.SubSceneX=JY.SubSceneX+sign;
            --JY.oldSMapX=-1;
            --JY.oldSMapY=-1;

            DrawSMap();
            ShowScreen();
            local t2=lib.GetTime();
            if (t2-t1)<CC.SceneMoveFrame then
                lib.Delay(CC.SceneMoveFrame-(t2-t1));
            end
        end
    end
end


function instruct_26(sceneid,id,v1,v2,v3)           --增加D*编号
    if sceneid==-2 then
        sceneid=JY.SubScene;
    end

    local v=GetD(sceneid,id,2);
    SetD(sceneid,id,2,v+v1);
    v=GetD(sceneid,id,3);
    SetD(sceneid,id,3,v+v2);
    v=GetD(sceneid,id,4);
    SetD(sceneid,id,4,v+v3);
end

--显示动画 id=-1 主角位置动画
function instruct_27(id,startpic,endpic)           --显示动画
    local old1,old2,old3;
    if id ~=-1 then
        old1=GetD(JY.SubScene,id,5);
        old2=GetD(JY.SubScene,id,6);
        old3=GetD(JY.SubScene,id,7);
    end

    --Cls();
    --ShowScreen();
    for i =startpic,endpic,2 do
        local t1=lib.GetTime();
        if id==-1 then
            JY.MyPic=i/2;
        else
            SetD(JY.SubScene,id,5,i);
            SetD(JY.SubScene,id,6,i);
            SetD(JY.SubScene,id,7,i);
        end
        DtoSMap();
        DrawSMap();
        ShowScreen();
        local t2=lib.GetTime();
        if t2-t1<CC.AnimationFrame then
            lib.Delay(CC.AnimationFrame-(t2-t1));
        end
    end
    if id ~=-1 then
        SetD(JY.SubScene,id,5,old1);
        SetD(JY.SubScene,id,6,old2);
        SetD(JY.SubScene,id,7,old3);
    end
end

--判断品德
function instruct_28(personid,vmin,vmax)          --判断品德
    local v=JY.Person[personid]["品德"];
    if v >=vmin and v<=vmax then
        return true;
    else
        return false;
    end
end

--判断攻击力
function instruct_29(personid,vmin,vmax)           --判断攻击力
    local v=JY.Person[personid]["攻击力"];
    if v >=vmin and v<=vmax then
        return true;
    else
        return false
    end
end

--主角走动
--为简化，走动使用相对值(x2-x1)(y2-y1),因此x1,y1可以为0，不必一定要为当前坐标。
function instruct_30(x1,y1,x2,y2)                --主角走动
    --Cls();
    --ShowScreen();

    if x1<x2 then
        for i=x1+1,x2 do
            local t1=lib.GetTime();
            instruct_30_sub(1);
            local t2=lib.GetTime();
            if (t2-t1)<CC.PersonMoveFrame then
                lib.Delay(CC.PersonMoveFrame-(t2-t1));
            end
        end
    elseif x1>x2 then
        for i=x2+1,x1 do
            local t1=lib.GetTime();
            instruct_30_sub(2);
            local t2=lib.GetTime();
            if (t2-t1)<CC.PersonMoveFrame then
                lib.Delay(CC.PersonMoveFrame-(t2-t1));
            end
        end
    end

    if y1<y2 then
        for i=y1+1,y2 do
            local t1=lib.GetTime();
            instruct_30_sub(3);
            local t2=lib.GetTime();
            if (t2-t1)<CC.PersonMoveFrame then
                lib.Delay(CC.PersonMoveFrame-(t2-t1));
            end
        end
    elseif y1>y2 then
        for i=y2+1,y1 do
            local t1=lib.GetTime();
            instruct_30_sub(0);
            local t2=lib.GetTime();
            if (t2-t1)<CC.PersonMoveFrame then
                lib.Delay(CC.PersonMoveFrame-(t2-t1));
            end
        end
    end
end

--主角走动sub
function instruct_30_sub(direct)            --主角走动sub
    local x,y;
    AddMyCurrentPic();
    x=JY.Base["人X1"]+CC.DirectX[direct+1];
    y=JY.Base["人Y1"]+CC.DirectY[direct+1];
    JY.Base["人方向"]=direct;
    JY.MyPic=GetMyPic();
    DtoSMap();

    if  SceneCanPass(x,y)==true then
        JY.Base["人X1"]=x;
        JY.Base["人Y1"]=y;
    end
    JY.Base["人X1"]=limitX(JY.Base["人X1"],1,CC.SWidth-2);
    JY.Base["人Y1"]=limitX(JY.Base["人Y1"],1,CC.SHeight-2);

    DrawSMap();
--    Cls();
    ShowScreen();
end

--判断是否够钱
function instruct_31(num)             --判断是否够钱
    local r=false;
    for i =1,CC.MyThingNum do
        if JY.Base["物品" .. i]==CC.MoneyID then
            if JY.Base["物品数量" .. i]>=num then
                r=true;
            end
            break;
        end
    end
    return r;
end

--增加物品
--num 物品数量，负数则为减少物品
function instruct_32(thingid,num)           --增加物品
    local p=1;
    for i=1,CC.MyThingNum do
        if JY.Base["物品" .. i]==thingid then
            JY.Base["物品数量" .. i]=JY.Base["物品数量" .. i]+num
            p=i;
            break;
        elseif JY.Base["物品" .. i]==-1 then
            JY.Base["物品" .. i]=thingid;
            JY.Base["物品数量" .. i]=num;
            p=1;
            break;
        end
    end

    if JY.Base["物品数量" .. p] <=0 then
        for i=p+1,CC.MyThingNum do
            JY.Base["物品" .. i-1]=JY.Base["物品" .. i];
            JY.Base["物品数量" .. i-1]=JY.Base["物品数量" .. i];
        end
        JY.Base["物品" .. CC.MyThingNum]=-1;
        JY.Base["物品数量" .. CC.MyThingNum]=0;
    end
end

--学会武功
function instruct_33(personid,wugongid,flag)           --学会武功
    local add=0;
    for i=1,10 do
        if JY.Person[personid]["武功" .. i]==0 then
            JY.Person[personid]["武功" .. i]=wugongid;
            JY.Person[personid]["武功等级" .. i]=0;
            add=1
            break;
        end
    end

    if add==0 then      --，武功已满，覆盖最后一个武功
        JY.Person[personid]["武功10" ]=wugongid;
        JY.Person[personid]["武功等级10"]=0;
    end

    if flag==0 then
        DrawStrBoxWaitKey(string.format("%s 学会武功 %s",JY.Person[personid]["姓名"],JY.Wugong[wugongid]["名称"]),C_ORANGE,CC.DefaultFont);
    end
end

--资质增加
function instruct_34(id,value)              --资质增加
    local add,str=AddPersonAttrib(id,"资质",value);
    DrawStrBoxWaitKey(JY.Person[id]["姓名"] .. str,C_ORANGE,CC.DefaultFont);
end

--设置武功
function instruct_35(personid,id,wugongid,wugonglevel)         --设置武功
    if id>=0 then
        JY.Person[personid]["武功" .. id+1]=wugongid;
        JY.Person[personid]["武功等级" .. id+1]=wugonglevel;
    else
        local flag=0;
        for i =1,10 do
            if JY.Person[personid]["武功" .. i]==0 then
                flag=1;
                JY.Person[personid]["武功" .. i]=wugongid;
                JY.Person[personid]["武功等级" .. i]=wugonglevel;
                return;
            end
        end
        if flag==0 then
            JY.Person[personid]["武功" .. 1]=wugongid;
            JY.Person[personid]["武功等级" .. 1]=wugonglevel;
        end
    end
end

--判断主角性别
function instruct_36(sex)               --判断主角性别
    if JY.Person[0]["性别"]==sex then
        return true;
    else
        return false;
    end
end


function instruct_37(v)              --增加品德
    AddPersonAttrib(0,"品德",v);
end

--修改场景某层贴图
function instruct_38(sceneid,level,oldpic,newpic)         --修改场景某层贴图
    if sceneid==-2 then
        sceneid=JY.SubScene;
    end

    for i=0,CC.SWidth-1 do
        for j=1, CC.SHeight-1 do
            if GetS(sceneid,i,j,level)==oldpic then
                SetS(sceneid,i,j,level,newpic)
            end
        end
    end
end


function instruct_39(sceneid)             --打开场景
    JY.Scene[sceneid]["进入条件"]=0;
end


function instruct_40(v)                --改变主角方向
    JY.Base["人方向"]=v;
    JY.MyPic=GetMyPic();
end


function instruct_41(personid,thingid,num)        --其他人员增加物品
    local k=0;
    for i =1, 4 do        --已有物品
        if JY.Person[personid]["携带物品" .. i]==thingid then
            JY.Person[personid]["携带物品数量" .. i]=JY.Person[personid]["携带物品数量" .. i]+num;
            k=i;
            break
        end
    end

    --物品减少到0，则后面物品往前移动
    if k>0 and JY.Person[personid]["携带物品数量" .. k] <=0 then
        for i=k+1,4 do
            JY.Person[personid]["携带物品" .. i-1]=JY.Person[personid]["携带物品" .. i];
            JY.Person[personid]["携带物品数量" .. i-1]=JY.Person[personid]["携带物品数量" .. i];
        end
        JY.Person[personid]["携带物品" .. 4]=-1;
        JY.Person[personid]["携带物品数量" .. 4]=0;
    end


    if k==0 then    --没有物品，注意此处不考虑超过4个物品的情况，如果超过，则无法加入。
        for i =1, 4 do        --已有物品
            if JY.Person[personid]["携带物品" .. i]==-1 then
                JY.Person[personid]["携带物品" .. i]=thingid;
                JY.Person[personid]["携带物品数量" .. i]=num;
                break
            end
        end
    end
end


function instruct_42()          --队伍中是否有女性
    local r=false;
    for i =1,CC.TeamNum do
        if JY.Base["队伍" .. i] >=0 then
            if JY.Person[JY.Base["队伍" .. i]]["性别"]==1 then
                r=true;
            end
        end
    end
    return r;
end


function instruct_43(thingid)        --是否有某种物品
    return instruct_18(thingid);
end


function instruct_44(id1,startpic1,endpic1,id2,startpic2,endpic2)     --同时显示两个动画
    local old1=GetD(JY.SubScene,id1,5);
    local old2=GetD(JY.SubScene,id1,6);
    local old3=GetD(JY.SubScene,id1,7);
    local old4=GetD(JY.SubScene,id2,5);
    local old5=GetD(JY.SubScene,id2,6);
    local old6=GetD(JY.SubScene,id2,7);

    --Cls();
    --ShowScreen();
    for i =startpic1,endpic1,2 do
        local t1=lib.GetTime();
        if id1==-1 then
            JY.MyPic=i/2;
        else
            SetD(JY.SubScene,id1,5,i);
            SetD(JY.SubScene,id1,6,i);
            SetD(JY.SubScene,id1,7,i);
        end
        if id2==-1 then
            JY.MyPic=i/2;
        else
            SetD(JY.SubScene,id2,5,i-startpic1+startpic2);
            SetD(JY.SubScene,id2,6,i-startpic1+startpic2);
            SetD(JY.SubScene,id2,7,i-startpic1+startpic2);
        end
        DtoSMap();
        DrawSMap();
        ShowScreen();
        local t2=lib.GetTime();
        if t2-t1<CC.AnimationFrame then
            lib.Delay(CC.AnimationFrame-(t2-t1));
        end
    end
    SetD(JY.SubScene,id1,5,old1);
    SetD(JY.SubScene,id1,6,old2);
    SetD(JY.SubScene,id1,7,old3);
    SetD(JY.SubScene,id2,5,old4);
    SetD(JY.SubScene,id2,6,old5);
    SetD(JY.SubScene,id2,7,old6);

end


function instruct_45(id,value)        --增加轻功
    local add,str=AddPersonAttrib(id,"轻功",value);
    DrawStrBoxWaitKey(JY.Person[id]["姓名"] .. str,C_ORANGE,CC.DefaultFont);
end


function instruct_46(id,value)            --增加内力
    local add,str=AddPersonAttrib(id,"内力最大值",value);
    AddPersonAttrib(id,"内力",0);
    DrawStrBoxWaitKey(JY.Person[id]["姓名"] .. str,C_ORANGE,CC.DefaultFont);
end


function instruct_47(id,value)
    local add,str=AddPersonAttrib(id,"攻击力",value);           --增加攻击力
    DrawStrBoxWaitKey(JY.Person[id]["姓名"] .. str,C_ORANGE,CC.DefaultFont);
end


function instruct_48(id,value)         --增加生命
    local add,str=AddPersonAttrib(id,"生命最大值",value);
    AddPersonAttrib(id,"生命",0);
    if instruct_16(id)==true then             --我方队员，显示增加
        DrawStrBoxWaitKey(JY.Person[id]["姓名"] .. str,C_ORANGE,CC.DefaultFont);
    end
end


function instruct_49(personid,value)       --设置内力属性
    JY.Person[personid]["内力性质"]=value;
end

--判断是否有5种物品
function instruct_50(id1,id2,id3,id4,id5)       --判断是否有5种物品
    local num=0;
    if instruct_18(id1)==true then
        num=num+1;
    end
    if instruct_18(id2)==true then
        num=num+1;
    end
    if instruct_18(id3)==true then
        num=num+1;
    end
    if instruct_18(id4)==true then
        num=num+1;
    end
    if instruct_18(id5)==true then
        num=num+1;
    end
    if num==5 then
        return true;
    else
        return false;
    end
end


function instruct_51()     --问软体娃娃
    instruct_1(2547+Rnd(18),114,0);
end


function instruct_52()       --看品德
    DrawStrBoxWaitKey(string.format("你现在的品德指数为: %d",JY.Person[0]["品德"]),C_ORANGE,CC.DefaultFont);
end


function instruct_53()        --看声望
    DrawStrBoxWaitKey(string.format("你现在的声望指数为: %d",JY.Person[0]["声望"]),C_ORANGE,CC.DefaultFont);
end


function instruct_54()        --开放其他场景
    for i = 0, JY.SceneNum-1 do
        JY.Scene[i]["进入条件"]=0;
    end
    JY.Scene[2]["进入条件"]=2;    --云鹤崖
    JY.Scene[38]["进入条件"]=2;   --摩天崖
    JY.Scene[75]["进入条件"]=1;   --桃花岛
    JY.Scene[80]["进入条件"]=1;   --绝情谷底
end


function instruct_55(id,num)      --判断D*编号的触发事件
    if GetD(JY.SubScene,id,2)==num then
        return true;
    else
        return false;
    end
end


function instruct_56(v)             --增加声望
    JY.Person[0]["声望"]=JY.Person[0]["声望"]+v;
    instruct_2_sub();     --是否可以增加武林帖
end

--高昌迷宫劈门
function instruct_57()       --高昌迷宫劈门
    instruct_27(-1,7664,7674);
    --Cls();
    --ShowScreen();
    for i=0,56,2 do
        local t1=lib.GetTime();
        if JY.MyPic< 7688/2 then
            JY.MyPic=(7676+i)/2;
        end
        SetD(JY.SubScene,2,5,i+7690);
        SetD(JY.SubScene,2,6,i+7690);
        SetD(JY.SubScene,2,7,i+7690);
        SetD(JY.SubScene,3,5,i+7748);
        SetD(JY.SubScene,3,6,i+7748);
        SetD(JY.SubScene,3,7,i+7748);
        SetD(JY.SubScene,4,5,i+7806);
        SetD(JY.SubScene,4,6,i+7806);
        SetD(JY.SubScene,4,7,i+7806);

        DtoSMap();
        DrawSMap();
        ShowScreen();
        local t2=lib.GetTime();
        if t2-t1<CC.AnimationFrame then
            lib.Delay(CC.AnimationFrame-(t2-t1));
        end
    end
end

--武道大会比武
function instruct_58()           --武道大会比武
    local group=5           --比武的组数
    local num1 = 6          --每组有几个战斗
    local num2 = 3          --选择的战斗数
    local startwar=102      --起始战斗编号
    local flag={};

    for i = 0,group-1 do
        for j=0,num1-1 do
            flag[j]=0;
        end

        for j = 1,num2 do
            local r;
            while true do          --选择一场战斗
                r=Rnd(num1);
                if flag[r]==0 then
                    flag[r]=1;
                    break;
                end
            end
            local warnum =r+i*num1;      --武道大会战斗编号
            WarLoad(warnum + startwar);
            instruct_1(2854+warnum, JY.Person[WAR.Data["敌人1"]]["头像代号"], 0);
            instruct_0();
            if WarMain(warnum + startwar, 0) ==true  then     --赢
                instruct_0();
                instruct_13();
                TalkEx("还有那位前辈肯赐教？", 0, 1)
                instruct_0();
            else
                instruct_15();
                return;
            end
        end

        if i < group - 1 then
            TalkEx("少侠已连战三场，*可先休息再战．", 70, 0);
            instruct_0();
            instruct_14();
            lib.Delay(300);
            if JY.Person[0]["受伤程度"] < 50 and JY.Person[0]["中毒程度"] <= 0 then
               JY.Person[0]["受伤程度"] = 0
               AddPersonAttrib(0,"体力",math.huge);
               AddPersonAttrib(0,"内力",math.huge);
               AddPersonAttrib(0,"生命",math.huge);
            end
            instruct_13();
            TalkEx("我已经休息够了，*有谁要再上？",0,1);
            instruct_0();
        end
    end

    TalkEx("接下来换谁？**．．．．*．．．．***没有人了吗？",0,1);
    instruct_0();
    TalkEx("如果还没有人要出来向这位*少侠挑战，那麽这武功天下*第一之名，武林盟主之位，*就由这位少侠夺得．***．．．．．．*．．．．．．*．．．．．．*好，恭喜少侠，这武林盟主*之位就由少侠获得，而这把*”武林神杖”也由你保管．",70,0);
    instruct_0();
    TalkEx("恭喜少侠！",12,0);
    instruct_0();
    TalkEx("小兄弟，恭喜你！",64,4);
    instruct_0();
    TalkEx("好，今年的武林大会到此已*圆满结束，希望明年各位武*林同道能再到我华山一游．",19,0);
    instruct_0();
    instruct_14();
    for i = 24,72 do
        instruct_3(-2, i, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2)
    end
    instruct_0();
    instruct_13();
    TalkEx("历经千辛万苦，我终於打败*群雄，得到这武林盟主之位*及神杖．*但是”圣堂”在那呢？*为什麽没人告诉我，难道大*家都不知道．*这会儿又有的找了．", 0, 1)
    instruct_0();
    instruct_2(143, 1)           --得到神杖

end

--全体队员离队
function instruct_59()           --全体队员离队
    for i=CC.TeamNum,2,-1 do
        if JY.Base["队伍" .. i]>=0 then
            instruct_21(JY.Base["队伍" .. i]);
        end
    end

    for i,v in ipairs(CC.AllPersonExit) do
        instruct_3(v[1],v[2],0,0,-1,-1,-1,-1,-1,-1,0,-2,-2);
    end
end

--判断D*图片
function instruct_60(sceneid,id,num)          --判断D*图片
    if sceneid==-2 then
         sceneid=JY.SubScene;
    end

    if id==-2 then
         id=JY.CurrentD;
    end

    if GetD(sceneid,id,5)==num then
        return true;
    else
        return false;
    end
end

--判断是否放完14天书
function instruct_61()               --判断是否放完14天书
    for i=11,24 do
        if GetD(JY.SubScene,i,5) ~= 4664 then
            return false;
        end
    end
    return true;
end

--播放时空机动画，结束
function instruct_62(id1,startnum1,endnum1,id2,startnum2,endnum2)      --播放时空机动画，结束
      JY.MyPic=-1;
      instruct_44(id1,startnum1,endnum1,id2,startnum2,endnum2);

      --此处应该插入正规的片尾动画。这里暂时用图片代替

      lib.LoadPicture(CONFIG.PicturePath .."end.png",-1,-1);
      ShowScreen();
      PlayMIDI(24);
      lib.Delay(5000);
      lib.GetKey();
      WaitKey();
      JY.Status=GAME_END;
end

--设置性别
function instruct_63(personid,sex)          --设置性别
    JY.Person[personid]["性别"]=sex
end

--小宝卖东西
function instruct_64()                 --小宝卖东西
    local headid=111;           --小宝头像

    local id=-1;
    for i=0,JY.ShopNum-1 do                --找到当前商店id
        if CC.ShopScene[i].sceneid==JY.SubScene then
            id=i;
            break;
        end
    end
    if id<0 then
        return ;
    end

    TalkEx("这位小哥，看看有什麽需要*的，小宝我卖的东西价钱绝*对公道．",headid,0);

    local menu={};
    for i=1,5 do
        menu[i]={};
        local thingid=JY.Shop[id]["物品" ..i];
        menu[i][1]=string.format("%-12s %5d",JY.Thing[thingid]["名称"],JY.Shop[id]["物品价格" ..i]);
        menu[i][2]=nil;
        if JY.Shop[id]["物品数量" ..i] >0 then
            menu[i][3]=1;
        else
            menu[i][3]=0;
        end
    end

    local x1=(CC.ScreenW-9*CC.DefaultFont-2*CC.MenuBorderPixel)/2;
    local y1=(CC.ScreenH-5*CC.DefaultFont-4*CC.RowPixel-2*CC.MenuBorderPixel)/2;



    local r=ShowMenu(menu,5,0,x1,y1,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r>0 then
        if instruct_31(JY.Shop[id]["物品价格" ..r])==false then
            TalkEx("非常抱歉，*你身上的钱似乎不够．",headid,0);
        else
            JY.Shop[id]["物品数量" ..r]=JY.Shop[id]["物品数量" ..r]-1;
            instruct_32(CC.MoneyID,-JY.Shop[id]["物品价格" ..r]);
            instruct_32(JY.Shop[id]["物品" ..r],1);
            TalkEx("大爷买了我小宝的东西，*保证绝不後悔．",headid,0);
        end
    end

    for i,v in ipairs(CC.ShopScene[id].d_leave) do
        instruct_3(-2,v,0,-2,-1,-1,939,-1,-1,-1,-2,-2,-2);      --设置离开场景时触发小宝离开事件，
    end
end

--小宝去其他客栈
function instruct_65()           --小宝去其他客栈
    local id=-1;
    for i=0,JY.ShopNum-1 do                --找到当前商店id
        if CC.ShopScene[i].sceneid==JY.SubScene then
            id=i;
            break;
        end
    end
    if id<0 then
        return ;
    end

    ---清除当前商店所有小宝D×
    instruct_3(-2,CC.ShopScene[id].d_shop,0,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
    for i,v in ipairs(CC.ShopScene[id].d_leave) do
        instruct_3(-2,v,0,-2,-1,-1,-1,-1,-1,-1,-2,-2,-2);
    end

    local newid=id+1;              --暂时用顺序取代随机，
    if newid>=5 then
        newid=0;
    end

    --设置新的小宝商店位置
    instruct_3(CC.ShopScene[newid].sceneid,CC.ShopScene[newid].d_shop,1,-2,938,-1,-1,8256,8256,8256,-2,-2,-2);
end

--播放音乐
function instruct_66(id)       --播放音乐
    PlayMIDI(id);
end

--播放音效
function instruct_67(id)      --播放音效
     PlayWavAtk(id);
end
