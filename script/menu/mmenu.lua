--主菜单
function MMenu()      --主菜单
    local menu={      {"医疗",Menu_Doctor,1},
                      {"解毒",Menu_DecPoison,1},
                      {"物品",Menu_Thing,1},
                      {"状态",Menu_Status,1},
                      {"离队",Menu_PersonExit,1},
                      {"系统",Menu_System,1},      };
    if JY.Status==GAME_SMAP then  --子场景，后两个菜单不可见
        menu[5][3]=0;
        menu[6][3]=0;
    end

    ShowMenu(menu,6,0,CC.MainMenuX,CC.MainMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE)
end

--系统子菜单
function Menu_System()         --系统子菜单
    local menu={ {"读取进度",Menu_ReadRecord,1},
                 {"保存进度",Menu_SaveRecord,1},
                 {"离开游戏",Menu_Exit,1},   };

    local r=ShowMenu(menu,3,0,CC.MainSubMenuX,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
    if r == 0 then
        return 0;
    elseif r<0 then   --要退出全部菜单，
        return 1;
    end
end

--离开菜单
function Menu_Exit()      --离开菜单
    Cls();
    if DrawStrBoxYesNo(-1,-1,"是否真的要离开游戏？",C_WHITE,CC.DefaultFont) == true then
        JY.Status =GAME_END;
    end
    return 1;
end

--保存进度
function Menu_SaveRecord()         --保存进度菜单
    local menu={ {"进度一",nil,1},
                 {"进度二",nil,1},
                 {"进度三",nil,1},  };
    local r=ShowMenu(menu,3,0,CC.MainSubMenuX2,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
    if r>0 then
        DrawStrBox(CC.MainSubMenuX2,CC.MainSubMenuY,"请稍候......",C_WHITE,CC.DefaultFont);
        ShowScreen();
        SaveRecord(r);
        Cls(CC.MainSubMenuX2,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
    end
    return 0;
end

--读取进度
function Menu_ReadRecord()        --读取进度菜单
    local menu={ {"进度一",nil,1},
                 {"进度二",nil,1},
                 {"进度三",nil,1},  };
    local r=ShowMenu(menu,3,0,CC.MainSubMenuX2,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r == 0 then
        return 0;
    elseif r>0 then
        DrawStrBox(CC.MainSubMenuX2,CC.MainSubMenuY,"请稍候......",C_WHITE,CC.DefaultFont);
        ShowScreen();
        LoadRecord(r);
        JY.Status=GAME_FIRSTMMAP;
        return 1;
    end
end

--状态子菜单
function Menu_Status()           --状态子菜单
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"要查阅谁的状态",C_WHITE,CC.DefaultFont);
    local nexty=CC.MainSubMenuY+CC.SingleLineHeight;

    local r=SelectTeamMenu(CC.MainSubMenuX,nexty);
    if r >0 then
        ShowPersonStatus(r)
        return 1;
    else
        Cls();
        return 0;
    end
end

--离队Exit
function Menu_PersonExit()        --离队Exit
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"要求谁离队",C_WHITE,CC.DefaultFont);
    local nexty=CC.MainSubMenuY+CC.SingleLineHeight;

    local r=SelectTeamMenu(CC.MainSubMenuX,nexty);
    if r==1 then
        DrawStrBoxWaitKey("抱歉！没有你游戏进行不下去",C_WHITE,CC.DefaultFont,1);
    elseif r>1 then
        local personid=JY.Base["队伍" .. r];
        for i,v in ipairs(CC.PersonExit) do         --在离队列表中调用离队函数
             if personid==v[1] then
                 oldCallEvent(v[2]);
             end
        end
    end
    Cls();
    return 0;
end

--队伍选择人物菜单
function SelectTeamMenu(x,y)          --队伍选择人物菜单
    local menu={};
    for i=1,CC.TeamNum do
        menu[i]={"",nil,0};
        local id=JY.Base["队伍" .. i]
        if id>=0 then
            if JY.Person[id]["生命"]>0 then
                menu[i][1]=JY.Person[id]["姓名"];
                menu[i][3]=1;
            end
        end
    end
    return ShowMenu(menu,CC.TeamNum,0,x,y,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
end

function GetTeamNum()            --得到队友个数
    local r=CC.TeamNum;
    for i=1,CC.TeamNum do
        if JY.Base["队伍" .. i]<0 then
            r=i-1;
            break;
        end
    end
    return r;
end

---显示队友状态
-- 左右键翻页，上下键换队友
function ShowPersonStatus(teamid)---显示队友状态
    local page=1;
    local pagenum=2;
    local teamnum=GetTeamNum();

    while true do
        Cls();
        local id=JY.Base["队伍" .. teamid];
        ShowPersonStatus_sub(id,page);

        ShowScreen();
        local keypress=WaitKey();
        lib.Delay(100);
        if keypress==VK_ESCAPE then
            break;
        elseif keypress==VK_UP then
            teamid=teamid-1;
        elseif keypress==VK_DOWN then
            teamid=teamid+1;
        elseif keypress==VK_LEFT then
            page=page-1;
        elseif keypress==VK_RIGHT then
            page=page+1;
        end
        teamid=limitX(teamid,1,teamnum);
        page=limitX(page,1,pagenum);
    end
end

--id 人物编号
--page 显示页数，目前共两页
function ShowPersonStatus_sub(id,page)    --显示人物状态页面
    local size=CC.DefaultFont;    --字体大小
    local p=JY.Person[id];
    local width=18*size+15;             --18个汉字字符宽
    local h=size+CC.PersonStateRowPixel;
    local height=13*h+10;                --12个汉字字符高
    local dx=(CC.ScreenW-width)/2;
    local dy=(CC.ScreenH-height)/2;

    local i=1;
    local x1,y1,x2;

    DrawBox(dx,dy,dx+width,dy+height,C_WHITE);

    x1=dx+5;
    y1=dy+5;
    x2=4*size;
    local headw,headh=lib.PicGetXY(1,p["头像代号"]*2);
    local headx=(width/2-headw)/2;
    local heady=(h*6-headh)/2;


    lib.PicLoadCache(1,p["头像代号"]*2,x1+headx,y1+heady,1);
    i=6;
    DrawString(x1,y1+h*i,p["姓名"],C_WHITE,size);
    DrawString(x1+10*size/2,y1+h*i,string.format("%3d",p["等级"]),C_GOLD,size);
    DrawString(x1+13*size/2,y1+h*i,"级",C_ORANGE,size);

    local function DrawAttrib(str,color1,color2,v)    --定义内部函数
        v=v or 0;
        DrawString(x1,y1+h*i,str,color1,size);
        DrawString(x1+x2,y1+h*i,string.format("%5d",p[str]+v),color2,size);
        i=i+1;
    end

if page==1 then
    local color;              --显示生命和最大值，根据受伤和中毒显示不同颜色
    if p["受伤程度"]<33 then
        color =RGB(236,200,40);
    elseif p["受伤程度"]<66 then
        color=RGB(244,128,32);
    else
        color=RGB(232,32,44);
    end
    i=i+1;
    DrawString(x1,y1+h*i,"生命",C_ORANGE,size);
    DrawString(x1+2*size,y1+h*i,string.format("%5d",p["生命"]),color,size);
    DrawString(x1+9*size/2,y1+h*i,"/",C_GOLD,size);

    if p["中毒程度"]==0 then
        color =RGB(252,148,16);
    elseif p["中毒程度"]<50 then
        color=RGB(120,208,88);
    else
        color=RGB(56,136,36);
    end
    DrawString(x1+5*size,y1+h*i,string.format("%5s",p["生命最大值"]),color,size);

    i=i+1;              --显示内力和最大值，根据内力性质显示不同颜色
    if p["内力性质"]==0 then
        color=RGB(208,152,208);
    elseif p["内力性质"]==1 then
        color=RGB(236,200,40);
    else
        color=RGB(236,236,236);
    end
    DrawString(x1,y1+h*i,"内力",C_ORANGE,size);
    DrawString(x1+2*size,y1+h*i,string.format("%5d/%5d",p["内力"],p["内力最大值"]),color,size);

    i=i+1;
    DrawAttrib("体力",C_ORANGE,C_GOLD)
    DrawAttrib("经验",C_ORANGE,C_GOLD)
    local tmp;
    if p["等级"] >=CC.Level then
        tmp="=";
    else
        tmp=string.format("%5d",CC.Exp[p["等级"]]);
    end

    DrawString(x1,y1+h*i,"升级",C_ORANGE,size);
    DrawString(x1+x2,y1+h*i,tmp,C_GOLD,size);

    local tmp1,tmp2,tmp3=0,0,0;
    if p["武器"]>-1 then
        tmp1=tmp1+JY.Thing[p["武器"]]["加攻击力"];
        tmp2=tmp2+JY.Thing[p["武器"]]["加防御力"];
        tmp3=tmp3+JY.Thing[p["武器"]]["加轻功"];
    end
    if p["防具"]>-1 then
        tmp1=tmp1+JY.Thing[p["防具"]]["加攻击力"];
        tmp2=tmp2+JY.Thing[p["防具"]]["加防御力"];
        tmp3=tmp3+JY.Thing[p["防具"]]["加轻功"];
    end

    i=i+1;
    DrawString(x1,y1+h*i,"左右键翻页，上下键查看其它队友",C_RED,size);


    i=0;
    x1=dx+width/2;
    DrawAttrib("攻击力",C_WHITE,C_GOLD,tmp1);
    DrawAttrib("防御力",C_WHITE,C_GOLD,tmp2);
    DrawAttrib("轻功",C_WHITE,C_GOLD,tmp3);

    DrawAttrib("医疗能力",C_WHITE,C_GOLD);
    DrawAttrib("用毒能力",C_WHITE,C_GOLD);
    DrawAttrib("解毒能力",C_WHITE,C_GOLD);


    DrawAttrib("拳掌功夫",C_WHITE,C_GOLD);
    DrawAttrib("御剑能力",C_WHITE,C_GOLD);
    DrawAttrib("耍刀技巧",C_WHITE,C_GOLD);
    DrawAttrib("特殊兵器",C_WHITE,C_GOLD);
    DrawAttrib("暗器技巧",C_WHITE,C_GOLD);
    DrawAttrib("资质",C_WHITE,C_GOLD);

elseif page==2 then
    i=i+1;
    DrawString(x1,y1+h*i,"武器:",C_ORANGE,size);
    if p["武器"]>-1 then
        DrawString(x1+size*3,y1+h*i,JY.Thing[p["武器"]]["名称"],C_GOLD,size);
    end
    i=i+1;
    DrawString(x1,y1+h*i,"防具:",C_ORANGE,size);
    if p["防具"]>-1 then
        DrawString(x1+size*3,y1+h*i,JY.Thing[p["防具"]]["名称"],C_GOLD,size);
    end
    i=i+1;
    DrawString(x1,y1+h*i,"修炼物品",C_ORANGE,size);
    local thingid=p["修炼物品"];
    if thingid>0 then
        i=i+1;
        DrawString(x1+size,y1+h*i,JY.Thing[thingid]["名称"],C_GOLD,size);
        i=i+1;
        local n=TrainNeedExp(id);
        if n <math.huge then
            DrawString(x1+size,y1+h*i,string.format("%5d/%5d",p["修炼点数"],n),C_GOLD,size);
        else
            DrawString(x1+size,y1+h*i,string.format("%5d/===",p["修炼点数"]),C_GOLD,size);
        end
    else
        i=i+2;
    end

    i=i+1;
    DrawString(x1,y1+h*i,"左右键翻页，上下键查看其它队友",C_RED,size);

    i=0;
    x1=dx+width/2;
    DrawString(x1,y1+h*i,"所会功夫",C_ORANGE,size);
    for j=1,10 do
        i=i+1
        local wugong=p["武功" .. j];
        if wugong > 0 then
            local level=math.modf(p["武功等级" .. j] / 100)+1;
            DrawString(x1+size,y1+h*i,string.format("%s",JY.Wugong[wugong]["名称"]),C_GOLD,size);
            DrawString(x1+size*7,y1+h*i,string.format("%2d",level),C_WHITE,size);
        end
    end

end

end


--计算人物修炼成功需要的点数
--id 人物id
function TrainNeedExp(id)         --计算人物修炼物品成功需要的点数
    local thingid=JY.Person[id]["修炼物品"];
    local r =0;
    if thingid >= 0 then
        if JY.Thing[thingid]["练出武功"] >=0 then
            local level=0;          --此处的level是实际level-1。这样没有武功時和炼成一级是一样的。
            for i =1,10 do               -- 查找当前已经炼成武功等级
                if JY.Person[id]["武功" .. i]==JY.Thing[thingid]["练出武功"] then
                    level=math.modf(JY.Person[id]["武功等级" .. i] /100);
                    break;
                end
            end
            if level <9 then
                r=(7-math.modf(JY.Person[id]["资质"]/15))*JY.Thing[thingid]["需经验"]*(level+1);
            else
                r=math.huge;
            end
        else
            r=(7-math.modf(JY.Person[id]["资质"]/15))*JY.Thing[thingid]["需经验"]*2;
        end
    end
    return r;
end

--医疗菜单
function Menu_Doctor()       --医疗菜单
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"谁要使用医术",C_WHITE,CC.DefaultFont);
    local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    DrawStrBox(CC.MainSubMenuX,nexty,"医疗能力",C_ORANGE,CC.DefaultFont);

    local menu1={};
    for i=1,CC.TeamNum do
        menu1[i]={"",nil,0};
        local id=JY.Base["队伍" .. i]
        if id >=0 then
            if JY.Person[id]["医疗能力"]>=20 then
                 menu1[i][1]=string.format("%-10s%4d",JY.Person[id]["姓名"],JY.Person[id]["医疗能力"]);
                 menu1[i][3]=1;
            end
        end
    end

    local id1,id2;
    nexty=nexty+CC.SingleLineHeight;
    local r=ShowMenu(menu1,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r >0 then
        id1=JY.Base["队伍" .. r];
        Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"要医治谁",C_WHITE,CC.DefaultFont);
        nexty=CC.MainSubMenuY+CC.SingleLineHeight;

        local menu2={};
        for i=1,CC.TeamNum do
            menu2[i]={"",nil,0};
            local id=JY.Base["队伍" .. i]
            if id>=0 then
                 menu2[i][1]=string.format("%-10s%4d/%4d",JY.Person[id]["姓名"],JY.Person[id]["生命"],JY.Person[id]["生命最大值"]);
                 menu2[i][3]=1;
            end
        end

        local r2=ShowMenu(menu2,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);

        if r2 >0 then
            id2=JY.Base["队伍" .. r2];
            local num=ExecDoctor(id1,id2);
            if num>0 then
                AddPersonAttrib(id1,"体力",-2);
            end
            DrawStrBoxWaitKey(string.format("%s 生命增加 %d",JY.Person[id2]["姓名"],num),C_ORANGE,CC.DefaultFont);
        end
    end

    Cls();

    return 0;
end

--执行医疗
--id1 医疗id2, 返回id2生命增加点数
function ExecDoctor(id1,id2)      --执行医疗
    if JY.Person[id1]["体力"]<50 then
        return 0;
    end

    local add=JY.Person[id1]["医疗能力"];
    local value=JY.Person[id2]["受伤程度"];
    if value > add+20 then
        return 0;
    end

    if value <25 then    --根据受伤程度计算实际医疗能力
        add=add*4/5;
    elseif value <50 then
        add=add*3/4;
    elseif value <75 then
        add=add*2/3;
    else
        add=add/2;
    end
    add=math.modf(add)+Rnd(5);

    AddPersonAttrib(id2,"受伤程度",-add);
    return AddPersonAttrib(id2,"生命",add)
end

--解毒
function Menu_DecPoison()         --解毒
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"谁要帮人解毒",C_WHITE,CC.DefaultFont);
    local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    DrawStrBox(CC.MainSubMenuX,nexty,"解毒能力",C_ORANGE,CC.DefaultFont);

    local menu1={};
    for i=1,CC.TeamNum do
        menu1[i]={"",nil,0};
        local id=JY.Base["队伍" .. i]
        if id>=0 then
            if JY.Person[id]["解毒能力"]>=20 then
                 menu1[i][1]=string.format("%-10s%4d",JY.Person[id]["姓名"],JY.Person[id]["解毒能力"]);
                 menu1[i][3]=1;
            end
        end
    end

    local id1,id2;
    nexty=nexty+CC.SingleLineHeight;
    local r=ShowMenu(menu1,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r >0 then
        id1=JY.Base["队伍" .. r];
         Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"替谁解毒",C_WHITE,CC.DefaultFont);
        nexty=CC.MainSubMenuY+CC.SingleLineHeight;

        DrawStrBox(CC.MainSubMenuX,nexty,"中毒程度",C_WHITE,CC.DefaultFont);
        nexty=nexty+CC.SingleLineHeight;

        local menu2={};
        for i=1,CC.TeamNum do
            menu2[i]={"",nil,0};
            local id=JY.Base["队伍" .. i]
            if id>=0 then
                 menu2[i][1]=string.format("%-10s%5d",JY.Person[id]["姓名"],JY.Person[id]["中毒程度"]);
                 menu2[i][3]=1;
            end
        end

        local r2=ShowMenu(menu2,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
        if r2 >0 then
            id2=JY.Base["队伍" .. r2];
            local num=ExecDecPoison(id1,id2);
            DrawStrBoxWaitKey(string.format("%s 中毒程度减少 %d",JY.Person[id2]["姓名"],num),C_ORANGE,CC.DefaultFont);
        end
    end
    Cls();
    return 0;
end

--解毒
--id1 解毒id2, 返回id2中毒减少点数
function ExecDecPoison(id1,id2)     --执行解毒
    local add=JY.Person[id1]["解毒能力"];
    local value=JY.Person[id2]["中毒程度"];

    if value > add+20 then
        return 0;
    end

    add=limitX(math.modf(add/3)+Rnd(10)-Rnd(10),0,value);
    return -AddPersonAttrib(id2,"中毒程度",-add);
end

--物品菜单
function Menu_Thing()       --物品菜单

    local menu={ {"全部物品",nil,1},
                 {"剧情物品",nil,1},
                 {"神兵宝甲",nil,1},
                 {"武功秘笈",nil,1},
                 {"灵丹妙药",nil,1},
                 {"伤人暗器",nil,1}, };

    local r=ShowMenu(menu,CC.TeamNum,0,CC.MainSubMenuX,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r>0 then
        local thing={};
        local thingnum={};

        for i = 0,CC.MyThingNum-1 do
            thing[i]=-1;
            thingnum[i]=0;
        end

        local num=0
        for i = 0,CC.MyThingNum-1 do
            local id=JY.Base["物品" .. i+1];
            if id>=0 then
                if r==1 then
                    thing[i]=id
                    thingnum[i]=JY.Base["物品数量" ..i+1];
                else
                    if JY.Thing[id]["类型"]==r-2 then             --对应于类型0-4
                        thing[num]=id;
                        thingnum[num]=JY.Base["物品数量" ..i+1];
                        num=num+1;
                    end
                end
            end
        end

        local r=SelectThing(thing,thingnum);
        if r>=0 then
            UseThing(r);           --使用物品
            return 1;             --退出主菜单
        end
    end
    return 0;
end

--新的显示物品菜单，模仿原游戏
--显示物品菜单
--返回选择的物品编号, -1表示没有选择
function SelectThing(thing,thingnum)    --显示物品菜单

    local xnum=CC.MenuThingXnum;
    local ynum=CC.MenuThingYnum;

    local w=CC.ThingPicWidth*xnum+(xnum-1)*CC.ThingGapIn+2*CC.ThingGapOut;  --总体宽度
    local h=CC.ThingPicHeight*ynum+(ynum-1)*CC.ThingGapIn+2*CC.ThingGapOut; --物品栏高度

    local dx=(CC.ScreenW-w)/2;
    local dy=(CC.ScreenH-h-2*(CC.ThingFontSize+2*CC.MenuBorderPixel+5))/2;


    local y1_1,y1_2,y2_1,y2_2,y3_1,y3_2;                  --名称，说明和图片的Y坐标

    local cur_line=0;
    local cur_x=0;
    local cur_y=0;
    local cur_thing=-1;

    while true do
        Cls();
        y1_1=dy;
        y1_2=y1_1+CC.ThingFontSize+2*CC.MenuBorderPixel;
        DrawBox(dx,y1_1,dx+w,y1_2,C_WHITE);
        y2_1=y1_2+5
        y2_2=y2_1+CC.ThingFontSize+2*CC.MenuBorderPixel
        DrawBox(dx,y2_1,dx+w,y2_2,C_WHITE);
        y3_1=y2_2+5;
        y3_2=y3_1+h;
        DrawBox(dx,y3_1,dx+w,y3_2,C_WHITE);

        for y=0,ynum-1 do
            for x=0,xnum-1 do
                local id=y*xnum+x+xnum*cur_line         --当前待选择物品
                local boxcolor;
                if x==cur_x and y==cur_y then
                    boxcolor=C_WHITE;
                    if thing[id]>=0 then
                        cur_thing=thing[id];
                        local str=JY.Thing[thing[id]]["名称"];
                        if JY.Thing[thing[id]]["类型"]==1 or JY.Thing[thing[id]]["类型"]==2 then
                            if JY.Thing[thing[id]]["使用人"] >=0 then
                                str=str .. "(" .. JY.Person[JY.Thing[thing[id]]["使用人"]]["姓名"] .. ")";
                            end
                        end
                        str=string.format("%s X %d",str,thingnum[id]);
                        local str2=JY.Thing[thing[id]]["物品说明"];

                        DrawString(dx+CC.ThingGapOut,y1_1+CC.MenuBorderPixel,str,C_GOLD,CC.ThingFontSize);
                        DrawString(dx+CC.ThingGapOut,y2_1+CC.MenuBorderPixel,str2,C_ORANGE,CC.ThingFontSize);

                    else
                        cur_thing=-1;
                    end
                else
                    boxcolor=C_BLACK;
                end
                local boxx=dx+CC.ThingGapOut+x*(CC.ThingPicWidth+CC.ThingGapIn);
                local boxy=y3_1+CC.ThingGapOut+y*(CC.ThingPicHeight+CC.ThingGapIn);
                lib.DrawRect(boxx,boxy,boxx+CC.ThingPicWidth+1,boxy+CC.ThingPicHeight+1,boxcolor);
                if thing[id]>=0 then
                    if CC.LoadThingPic==1 then
                        lib.PicLoadCache(2,thing[id]*2,boxx+1,boxy+1,1);
                    else
                        lib.PicLoadCache(0,(thing[id]+CC.StartThingPic)*2,boxx+1,boxy+1,1);
                    end
                end
            end
        end

        ShowScreen();
        local keypress=WaitKey();
        lib.Delay(100);
        if keypress==VK_ESCAPE then
            cur_thing=-1;
            break;
        elseif keypress==VK_RETURN or keypress==VK_SPACE then
            break;
        elseif keypress==VK_UP then
            if  cur_y == 0 then
                if  cur_line > 0 then
                    cur_line = cur_line - 1;
                end
            else
                cur_y = cur_y - 1;
            end
        elseif keypress==VK_DOWN then
            if  cur_y ==ynum-1 then
                if  cur_line < (math.modf(200/xnum)-ynum) then
                    cur_line = cur_line + 1;
                end
            else
                cur_y = cur_y + 1;
            end
        elseif keypress==VK_LEFT then
            if  cur_x > 0 then
                cur_x=cur_x-1;
            else
                cur_x=xnum-1;
            end
        elseif keypress==VK_RIGHT then
            if  cur_x ==xnum-1 then
                cur_x=0;
            else
                cur_x=cur_x+1;
            end
        end

    end

    Cls();
    return cur_thing;
end