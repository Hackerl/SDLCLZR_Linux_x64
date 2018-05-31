-------------------------------------------------------------------------------------------
---------------------------------以下为手动战斗函数-------------------------------------------
-------------------------------------------------------------------------------------------

--手动战斗
--id 战斗人物编号
--返回，选中菜单编号，选中"等待"时有效，
function War_Manual()        --手动战斗
    local r;
    while true do
        WAR.ShowHead=1;          --显示头像
        r=War_Manual_Sub();  --手动战斗菜单
        if math.abs(r)~=1 then        --移动完毕后，重新生成菜单
            break;
        end
    end
    WAR.ShowHead=0;
    return r;
end


function War_Manual_Sub()                --手动战斗菜单
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local menu={ {"移动",War_MoveMenu,1},
                 {"攻击",War_FightMenu,1},
                 {"用毒",War_PoisonMenu,1},
                 {"解毒",War_DecPoisonMenu,1},
                 {"医疗",War_DoctorMenu,1},
                 {"物品",War_ThingMenu,1},
                 {"等待",War_WaitMenu,1},
                 {"状态",War_StatusMenu,1},
                 {"休息",War_RestMenu,1},
                 {"自动",War_AutoMenu,1},   };

    if JY.Person[pid]["体力"]<=5 or WAR.Person[WAR.CurID]["移动步数"]<=0 then  --不能移动
        menu[1][3]=0;
    end

    local minv=War_GetMinNeiLi(pid);

    if JY.Person[pid]["内力"] < minv or JY.Person[pid]["体力"] <10 then  --不能战斗
        menu[2][3]=0;
    end

    if JY.Person[pid]["体力"]<10 or JY.Person[pid]["用毒能力"]<20 then  --不能用毒
        menu[3][3]=0;
    end

    if JY.Person[pid]["体力"]<10 or JY.Person[pid]["解毒能力"]<20 then  --不能解毒
        menu[4][3]=0;
    end

    if JY.Person[pid]["体力"]<50 or JY.Person[pid]["医疗能力"]<20 then  --不能医疗
        menu[5][3]=0;
    end

    lib.GetKey();
    Cls();
    return ShowMenu(menu,10,0,CC.MainMenuX,CC.MainMenuY,0,0,1,0,CC.DefaultFont,C_ORANGE,C_WHITE);

end


function War_GetMinNeiLi(pid)       --计算所有武功中需要内力最少的
    local minv=math.huge;
    for i=1,10 do
        local tmpid=JY.Person[pid]["武功" .. i];
        if tmpid >0 then
            if JY.Wugong[tmpid]["消耗内力点数"]< minv then
                minv=JY.Wugong[tmpid]["消耗内力点数"];
            end
        end
    end
    return minv;
end

function WarShowHead()               --显示战斗人头像
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local p=JY.Person[pid];

    local h=16+2;
    local width=112+2*CC.MenuBorderPixel;
    local height=100+2*CC.MenuBorderPixel+4*h;
    local x1,y1;
    local i=1;
    if WAR.Person[WAR.CurID]["我方"]==true then
        x1=CC.ScreenW-width-10;
        y1=CC.ScreenH-height-10;
    else
        x1=10;
        y1=10;
    end

    DrawBox(x1,y1,x1+width,y1+height,C_WHITE);
    local headw,headh=lib.PicGetXY(1,p["头像代号"]*2);
    local headx=(100-headw)/2;
    local heady=(100-headh)/2;

    lib.PicLoadCache(1,p["头像代号"]*2,x1+5+headx,y1+5+heady,1);
    x1=x1+5
    y1=y1+5+100;

    DrawString(x1,y1,p["姓名"],C_WHITE,16);

    local color;              --显示生命和最大值，根据受伤和中毒显示不同颜色
    if p["受伤程度"]<33 then
        color =RGB(236,200,40);
    elseif p["受伤程度"]<66 then
        color=RGB(244,128,32);
    else
        color=RGB(232,32,44);
    end
    DrawString(x1,y1+h,"生命",C_ORANGE,16);
    DrawString(x1+40,y1+h,string.format("%4d",p["生命"]),color,16);
    DrawString(x1+40+32,y1+h,"/",C_GOLD,16);
    if p["中毒程度"]==0 then
        color =RGB(252,148,16);
    elseif p["中毒程度"]<50 then
        color=RGB(120,208,88);
    else
        color=RGB(56,136,36);
    end
    DrawString(x1+40+40,y1+h,string.format("%4d",p["生命最大值"]),color,16);

                  --显示内力和最大值，根据内力性质显示不同颜色
    if p["内力性质"]==0 then
        color=RGB(208,152,208);
    elseif p["内力性质"]==1 then
        color=RGB(236,200,40);
    else
        color=RGB(236,236,236);
    end
    DrawString(x1,y1+h*2,"内力",C_ORANGE,16);
    DrawString(x1+40,y1+h*2,string.format("%4d/%4d",p["内力"],p["内力最大值"]),color,16);

    DrawString(x1,y1+h*3,"体力",C_ORANGE,16);
    DrawString(x1+40,y1+h*3,string.format("%4d",p["体力"]),C_GOLD,16);
end


--返回1：已经移动    0 没有移动
function War_MoveMenu()           --执行移动菜单
    WAR.ShowHead=0;   --不显示头像
    if WAR.Person[WAR.CurID]["移动步数"]<=0 then
        return 0;
    end

    War_CalMoveStep(WAR.CurID,WAR.Person[WAR.CurID]["移动步数"],0);   --计算移动步数

    local r;
    local x,y=War_SelectMove()             --选择移动位置
    if x ~=nil then            --空值表示没有选择，esc返回了，非空则表示选择了位置
        War_MovePerson(x,y);    --移动到相应的位置
        r=1;
    else
        r=0
        WAR.ShowHead=1;
        Cls();
    end
    lib.GetKey();
    return r;
end

--计算可移动步数
--id 战斗人id，
--stepmax 最大步数，
--flag=0  移动，物品不能绕过，1 武功，用毒医疗等，不考虑挡路。
function War_CalMoveStep(id,stepmax,flag)                   --计算可移动步数

    CleanWarMap(3,255);           --第三层坐标用来设置移动，先都设为255，

    local x=WAR.Person[id]["坐标X"];
    local y=WAR.Person[id]["坐标Y"];

    local steparray={};     --用数组保存第n步的坐标。
    for i=0,stepmax do
        steparray[i]={};
        steparray[i].x={};
        steparray[i].y={};
    end

    SetWarMap(x,y,3,0);
    steparray[0].num=1;
    steparray[0].x[1]=x;
    steparray[0].y[1]=y;
    for i=0,stepmax-1 do       --根据第0步的坐标找出第1步，然后继续找
        War_FindNextStep(steparray,i,flag);
        if steparray[i+1].num==0 then
            break;
        end
    end

    return steparray;

end


function War_FindNextStep(steparray,step,flag)      --设置下一步可移动的坐标
    local num=0;
    local step1=step+1;
    for i=1,steparray[step].num do
        local x=steparray[step].x[i];
        local y=steparray[step].y[i];
        if x+1<CC.WarWidth-1 then                        --当前步数的相邻格
            local v=GetWarMap(x+1,y,3);
            if v ==255 and War_CanMoveXY(x+1,y,flag)==true then
                num= num+1;
                steparray[step1].x[num]=x+1;
                steparray[step1].y[num]=y;
                SetWarMap(x+1,y,3,step1);
            end
        end

        if x-1>0 then                        --当前步数的相邻格
            local v=GetWarMap(x-1,y,3);
            if v ==255 and War_CanMoveXY(x-1,y,flag)==true then
                 num=num+1;
                steparray[step1].x[num]=x-1;
                steparray[step1].y[num]=y;
                SetWarMap(x-1,y,3,step1);
            end
        end

        if y+1<CC.WarHeight-1 then                        --当前步数的相邻格
            local v=GetWarMap(x,y+1,3);
            if v ==255 and War_CanMoveXY(x,y+1,flag)==true then
                 num= num+1;
                steparray[step1].x[num]=x;
                steparray[step1].y[num]=y+1;
                SetWarMap(x,y+1,3,step1);
            end
        end

        if y-1>0 then                        --当前步数的相邻格
            local v=GetWarMap(x ,y-1,3);
            if v ==255 and War_CanMoveXY(x,y-1,flag)==true then
                num= num+1;
                steparray[step1].x[num]=x ;
                steparray[step1].y[num]=y-1;
                SetWarMap(x ,y-1,3,step1);
            end
        end
    end
    steparray[step1].num=num;

end

function War_CanMoveXY(x,y,flag)  --坐标是否可以通过，判断移动时使用
    if GetWarMap(x,y,1)>0 then    --第1层有物体
        return false
    end
    if flag==0 then
        if CC.WarWater[GetWarMap(x,y,0)]~=nil then          --水面，不可走
            return false
        end
        if GetWarMap(x,y,2)>=0 then    --有人
            return false
        end
    end
    return true;
end

function War_SelectMove()              ---选择移动位置
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];
    local x=x0;
    local y=y0;

    while true do
        local x2=x;
        local y2=y;

        WarDrawMap(1,x,y);

        ShowScreen();
        local key=WaitKey();
        if key==VK_UP then
            y2=y-1;
        elseif key==VK_DOWN then
            y2=y+1;
        elseif key==VK_LEFT then
            x2=x-1;
        elseif key==VK_RIGHT then
            x2=x+1;
        elseif key==VK_SPACE or key==VK_RETURN then
            return x,y;
        elseif key==VK_ESCAPE then
            return nil;
        end

        if GetWarMap(x2,y2,3)<128 then
            x=x2;
            y=y2;
        end
    end

end


function War_MovePerson(x,y)            --移动人物到位置x,y

    local movenum=GetWarMap(x,y,3);
    WAR.Person[WAR.CurID]["移动步数"]=WAR.Person[WAR.CurID]["移动步数"]-movenum;    --可移动步数减小

    local movetable={};  --   记录每步移动
    for i=movenum,1,-1 do    --从目的位置反着找到初始位置，作为移动的次序
        movetable[i]={};
        movetable[i].x=x;
        movetable[i].y=y;
        if GetWarMap(x-1,y,3)==i-1 then
            x=x-1;
            movetable[i].direct=1;
        elseif GetWarMap(x+1,y,3)==i-1 then
            x=x+1;
            movetable[i].direct=2;
        elseif GetWarMap(x,y-1,3)==i-1 then
            y=y-1;
            movetable[i].direct=3;
        elseif GetWarMap(x,y+1,3)==i-1 then
            y=y+1;
            movetable[i].direct=0;
        end
    end

    for i=1,movenum do
        local t1=lib.GetTime();

        SetWarMap(WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],2,-1);
        SetWarMap(WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],5,-1);

        WAR.Person[WAR.CurID]["坐标X"]=movetable[i].x;
        WAR.Person[WAR.CurID]["坐标Y"]=movetable[i].y;
        WAR.Person[WAR.CurID]["人方向"]=movetable[i].direct;
        WAR.Person[WAR.CurID]["贴图"]=WarCalPersonPic(WAR.CurID);

        SetWarMap(WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],2,WAR.CurID);
        SetWarMap(WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],5,WAR.Person[WAR.CurID]["贴图"]);

        WarDrawMap(0);
        ShowScreen();
        local t2=lib.GetTime();
        if i<movenum then
            if (t2-t1)< 2*CC.Frame then
                lib.Delay(2*CC.Frame-(t2-t1));
            end
        end
    end

end


function War_FightMenu()              --执行攻击菜单
    local pid=WAR.Person[WAR.CurID]["人物编号"];

    local numwugong=0;
    local menu={};
    for i=1,10 do
        local tmp=JY.Person[pid]["武功" .. i];
        if tmp>0 then
            menu[i]={JY.Wugong[tmp]["名称"],nil,1};
            if JY.Wugong[tmp]["消耗内力点数"] > JY.Person[pid]["内力"] then
                menu[i][3]=0;
            end
            numwugong=numwugong+1;
        end
    end

    if numwugong==0 then
        return 0;
    end
    local r;
    if numwugong==1 then
        r=1;
    else
        r=ShowMenu(menu,numwugong,0,CC.MainSubMenuX,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);
    end
    if r==0 then
        return 0;
    end

    WAR.ShowHead=0;
    local r2=War_Fight_Sub(WAR.CurID,r);
    WAR.ShowHead=1;
    Cls();
    return r2;
end

--执行战斗，自动和手动战斗都调用
function War_Fight_Sub(id,wugongnum,x,y)          --执行战斗
    local pid=WAR.Person[id]["人物编号"];
    local wugong=JY.Person[pid]["武功" .. wugongnum];
    local level=math.modf(JY.Person[pid]["武功等级" .. wugongnum]/100)+1;

    CleanWarMap(4,0);

    local fightscope=JY.Wugong[wugong]["攻击范围"];
    --在map4标注武功攻击效果
    if fightscope==0 then
        if War_FightSelectType0(wugong,level,x,y)==false then
            return 0;
        end
    elseif fightscope==1 then
        War_FightSelectType1(wugong,level,x,y)

    elseif fightscope==2 then
        War_FightSelectType2(wugong,level,x,y)

    elseif fightscope==3 then
        if War_FightSelectType3(wugong,level,x,y)==false then
            return 0;
        end
    end

    local fightnum=1;
    if JY.Person[pid]["左右互搏"]==1 then
        fightnum=2;
    end

for k=1,fightnum  do         --如果左右互搏，则攻击两次
    for i=0,CC.WarWidth-1 do
        for j=0,CC.WarHeight-1 do
            local effect=GetWarMap(i,j,4);
            if effect>0 then              --攻击效果地方
                local emeny=GetWarMap(i,j,2);
                 if emeny>=0 then          --有人
                     if WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[emeny]["我方"] then       --是敌人
                         --只有点和面攻击可以杀内力。此时伤害类型有效
                         if JY.Wugong[wugong]["伤害类型"]==1 and (fightscope==0 or fightscope==3) then
                             WAR.Person[emeny]["点数"]=-War_WugongHurtNeili(emeny,wugong,level)
                             SetWarMap(i,j,4,3);
                             WAR.Effect=3;
                         else
                             WAR.Person[emeny]["点数"]=-War_WugongHurtLife(emeny,wugong,level)
                             WAR.Effect=2;
                             SetWarMap(i,j,4,2);
                         end
                     end
                 end
             end
         end
    end

    War_ShowFight(pid,wugong,JY.Wugong[wugong]["武功类型"],level,x,y,JY.Wugong[wugong]["武功动画&音效"]);

    for i=0,WAR.PersonNum-1 do
        WAR.Person[i]["点数"]=0;
    end

    WAR.Person[WAR.CurID]["经验"]=WAR.Person[WAR.CurID]["经验"]+2;

    if JY.Person[pid]["武功等级" .. wugongnum]<900 then
        JY.Person[pid]["武功等级" .. wugongnum]=JY.Person[pid]["武功等级" .. wugongnum]+Rnd(2)+1;
    end

    if math.modf(JY.Person[pid]["武功等级" .. wugongnum]/100)+1 ~= level then    --武功升级了
        level=math.modf(JY.Person[pid]["武功等级" .. wugongnum]/100)+1;
        DrawStrBox(-1,-1,string.format("%s 升为 %d 级",JY.Wugong[wugong]["名称"],level),C_ORANGE,CC.DefaultFont)
        ShowScreen();
        lib.Delay(500);
        Cls();
        ShowScreen();
    end

    AddPersonAttrib(pid,"内力",-math.modf((level+1)/2)*JY.Wugong[wugong]["消耗内力点数"])

end

    AddPersonAttrib(pid,"体力",-3);

    return 1;
end

--选择点攻击
--x1,y1 攻击点，如果为空则手工选择
function War_FightSelectType0(wugong,level,x1,y1)          --选择点攻击
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];
    War_CalMoveStep(WAR.CurID,JY.Wugong[wugong]["移动范围" .. level],1);

    if x1==nil and y1==nil then
        x1,y1=War_SelectMove();              --选择攻击对象
    end
    if x1 ==nil then
        lib.GetKey();
        Cls();
        return false;
    end

    WAR.Person[WAR.CurID]["人方向"]=War_Direct(x0,y0,x1,y1);

    SetWarMap(x1,y1,4,1);

    WAR.EffectXY={};
    WAR.EffectXY[1]={x1,y1};
    WAR.EffectXY[2]={x1,y1};

end

--选择线攻击
--direct 攻击方向，为空则手工设置
function War_FightSelectType1(wugong,level,x,y)            --选择线攻击
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];
    local direct;

    if x==nil and y==nil  then
        direct =-1;
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"请选择攻击方向",C_ORANGE,CC.DefaultFont)
        ShowScreen();

        while true do           --选择方向
            local key=WaitKey();
            if key==VK_UP then
                direct=0;
            elseif key==VK_DOWN then
                direct=3;
            elseif key==VK_LEFT then
                direct=2;
            elseif key==VK_RIGHT then
                direct=1;
            end
            if direct>=0 then
                break;
            end
        end

        Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        ShowScreen();
    else
        direct=War_Direct(x0,y0,x,y);
    end

    WAR.Person[WAR.CurID]["人方向"]=direct;
    local move=JY.Wugong[wugong]["移动范围" .. level]

    WAR.EffectXY={};

    for i=1,move do
        if direct==0 then
            SetWarMap(x0,y0-i,4,1);
        elseif direct==3 then
            SetWarMap(x0,y0+i,4,1);
        elseif direct==2 then
            SetWarMap(x0-i,y0,4,1);
        elseif direct==1 then
            SetWarMap(x0+i,y0,4,1);
        end
    end

    if direct==0 then
        WAR.EffectXY[1]={x0,y0-1};
        WAR.EffectXY[2]={x0,y0-move};
    elseif direct==3 then
        WAR.EffectXY[1]={x0,y0+1};
        WAR.EffectXY[2]={x0,y0+move};
    elseif direct==2 then
        WAR.EffectXY[1]={x0-1,y0};
        WAR.EffectXY[2]={x0-move,y0};
    elseif direct==1 then
        WAR.EffectXY[1]={x0+1,y0};
        WAR.EffectXY[2]={x0+move,y0};
    end

end

--选择十字攻击
function War_FightSelectType2(wugong,level)                 --选择十字攻击
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];

    local move=JY.Wugong[wugong]["移动范围" .. level]

    WAR.EffectXY={};

    for i=1,move do
        SetWarMap(x0,y0-i,4,1);
        SetWarMap(x0,y0+i,4,1);
        SetWarMap(x0-i,y0,4,1);
        SetWarMap(x0+i,y0,4,1);
    end

    WAR.EffectXY[1]={x0-move,y0};
    WAR.EffectXY[2]={x0+move,y0};

end

--选择面攻击
--x1,y1 攻击点，如果为空则手工选择
function War_FightSelectType3(wugong,level,x1,y1)            --选择面攻击
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];
    War_CalMoveStep(WAR.CurID,JY.Wugong[wugong]["移动范围" .. level],1);

    if x1==nil and y1==nil then
        x1,y1=War_SelectMove();              --选择攻击对象
    end

    if x1 ==nil then
        lib.GetKey();
        Cls();
        return false;
    end

    WAR.Person[WAR.CurID]["人方向"]=War_Direct(x0,y0,x1,y1);

    local move=JY.Wugong[wugong]["杀伤范围" .. level]

    WAR.EffectXY={};

    for i=-move,move do
        for j=-move,move do
            SetWarMap(x1+i,y1+j,4,1);
         end
    end

    WAR.EffectXY[1]={x1-2*move,y1};
    WAR.EffectXY[2]={x1+2*move,y1};
end

--计算人方向
--(x1,y1) 人位置     -(x2,y2) 目标位置
--返回： 方向
function War_Direct(x1,y1,x2,y2)             --计算人方向
    local x=x2-x1;
    local y=y2-y1;

    if math.abs(y)>math.abs(x) then
        if y>0 then
            return 3;
        else
            return 0
        end
    else
        if x>0 then
            return 1;
        else
            return 2;
        end
    end
end


--显示战斗动画
--pid 人id
--wugong  武功编号， 0 表示用毒解毒等，使用普通攻击效果
--wogongtype =0 医疗用毒解毒，1,2,3,4 武功类型  -1 暗器
--level 武功等级
--x,y 攻击坐标
--eft  武功动画效果id  eft.idx/grp中的效果

function War_ShowFight(pid,wugong,wugongtype,level,x,y,eft)              --显示战斗动画

    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];

    local fightdelay,fightframe,sounddelay;
    if wugongtype>=0 then
        fightdelay=JY.Person[pid]["出招动画延迟" .. wugongtype+1];
        fightframe=JY.Person[pid]["出招动画帧数" .. wugongtype+1];
        sounddelay=JY.Person[pid]["武功音效延迟" .. wugongtype+1];
    else            ---暗器，这些数据什么意思？？
        fightdelay=0;
        fightframe=-1;
        sounddelay=-1;
    end

    local framenum=fightdelay+CC.Effect[eft];            --总帧数

    local startframe=0;               --计算fignt***中当前出招起始帧
    if wugongtype>=0 then
        for i=0,wugongtype-1 do
            startframe=startframe+4*JY.Person[pid]["出招动画帧数" .. i+1];
        end
    end

    local starteft=0;          --计算起始武功效果帧
    for i=0,eft-1 do
        starteft=starteft+CC.Effect[i];
    end

    WAR.Person[WAR.CurID]["贴图类型"]=0;
    WAR.Person[WAR.CurID]["贴图"]=WarCalPersonPic(WAR.CurID);

    WarSetPerson();

    WarDrawMap(0);
    ShowScreen();

    local fastdraw;
    if CONFIG.FastShowScreen==0 or CC.AutoWarShowHead==1 then    --显示头像则全部重绘
        fastdraw=0;
    else
        fastdraw=1;
    end

    --在显示动画前先加载贴图
    local oldpic=WAR.Person[WAR.CurID]["贴图"]/2;
    local oldpic_type=0;

    local oldeft=-1;

    for i=0,framenum-1 do
        local tstart=lib.GetTime();
        local mytype;
        if fightframe>0 then
            WAR.Person[WAR.CurID]["贴图类型"]=1;
            mytype=4+WAR.CurID;
            if i<fightframe then
                WAR.Person[WAR.CurID]["贴图"]=(startframe+WAR.Person[WAR.CurID]["人方向"]*fightframe+i)*2;
            end
        else       --暗器，不使用fight中图像
            WAR.Person[WAR.CurID]["贴图类型"]=0;
            WAR.Person[WAR.CurID]["贴图"]=WarCalPersonPic(WAR.CurID);
            mytype=0;
        end

        if i==sounddelay then
            PlayWavAtk(JY.Wugong[wugong]["出招音效"]);
        end
        if i==fightdelay then
            PlayWavE(eft);
        end
        local pic=WAR.Person[WAR.CurID]["贴图"]/2;
        if fastdraw==1 then
            local rr=ClipRect(Cal_PicClip(0,0,oldpic,oldpic_type,0,0,pic,mytype));
            if rr ~=nil then
                lib.SetClip(rr.x1,rr.y1,rr.x2,rr.y2);
            end
        else
            lib.SetClip(0,0,0,0);
        end
        oldpic=pic;
        oldpic_type=mytype;

        if i<fightdelay then   --只显示出招
            WarDrawMap(4,pic*2,mytype,-1);
        else        --同时显示武功效果
            starteft=starteft+1;            --此处似乎是eft第一个数据有问题，应该是10，现为9，因此加1

            if fastdraw==1 then
                local clip1={};
                clip1=Cal_PicClip(WAR.EffectXY[1][1]-x0,WAR.EffectXY[1][2]-y0,oldeft,3,
                                        WAR.EffectXY[1][1]-x0,WAR.EffectXY[1][2]-y0,starteft,3);
                local clip2={};
                clip2=Cal_PicClip(WAR.EffectXY[2][1]-x0,WAR.EffectXY[2][2]-y0,oldeft,3,
                                        WAR.EffectXY[2][1]-x0,WAR.EffectXY[2][2]-y0,starteft,3);
                local clip=ClipRect(MergeRect(clip1,clip2));

                if clip ~=nil then
                    local area=(clip.x2-clip.x1)*(clip.y2-clip.y1);          --计算脏矩形面积
                    if area <CC.ScreenW*CC.ScreenH/2 then        --面积足够小，则更新脏矩形。
                        WarDrawMap(4,pic*2,mytype,starteft*2);
                        lib.SetClip(clip.x1,clip.y1,clip.x2,clip.y2);
                        WarDrawMap(4,pic*2,mytype,starteft*2);
                    else    --面积太大，直接重绘
                        lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);
                        WarDrawMap(4,pic*2,mytype,starteft*2);
                    end
                else
                    WarDrawMap(4,pic*2,mytype,starteft*2);
                end
            else
                lib.SetClip(0,0,0,0);
                WarDrawMap(4,pic*2,mytype,starteft*2);
            end
            oldeft=starteft;
        end

        ShowScreen(fastdraw);
        lib.SetClip(0,0,0,0);

        local tend=lib.GetTime();
        if tend-tstart<1*CC.Frame then
            lib.Delay(1*CC.Frame-(tend-tstart));
        end

    end

    lib.SetClip(0,0,0,0);
    WAR.Person[WAR.CurID]["贴图类型"]=0;
    WAR.Person[WAR.CurID]["贴图"]=WarCalPersonPic(WAR.CurID);
    WarSetPerson();
    WarDrawMap(0);

    ShowScreen();
    lib.Delay(200);

    WarDrawMap(2);          --全黑显示命中人物
    ShowScreen();
    lib.Delay(200);

    WarDrawMap(0);
    ShowScreen();

    local HitXY={};               --记录命中点数的坐标
    local HitXYNum=0;
    for i = 0, WAR.PersonNum-1 do
        local x1=WAR.Person[i]["坐标X"];
        local y1=WAR.Person[i]["坐标Y"];
        if WAR.Person[i]["死亡"]==false then
            if GetWarMap(x1,y1,4)>1 then
                local n=WAR.Person[i]["点数"]
                HitXY[HitXYNum]={x1,y1,string.format("%+d",n)};
                HitXYNum=HitXYNum+1;
            end
        end
    end

if HitXYNum>0 then
    local clips={};                --计算命中点数clip
    for i=0,HitXYNum-1 do
        local dx=HitXY[i][1]-x0;
        local dy=HitXY[i][2]-y0;
        local ll=string.len(HitXY[i][3]);
        local w=ll*CC.DefaultFont/2+1;
        clips[i]={x1=CC.XScale*(dx-dy)+CC.ScreenW/2,
                 y1=CC.YScale*(dx+dy)+CC.ScreenH/2,
                 x2=CC.XScale*(dx-dy)+CC.ScreenW/2+w,
                 y2=CC.YScale*(dx+dy)+CC.ScreenH/2+CC.DefaultFont+1 };
    end

    local clip=clips[0];

    for i=1,HitXYNum-1 do
        clip=MergeRect(clip,clips[i]);
    end

    local area=(clip.x2-clip.x1)*(clip.y2-clip.y1)

    for i=1,15 do           --显示命中的点数
        local tstart=lib.GetTime();
        local y_off=i*2+65;
        if fastdraw==1 and area <CC.ScreenW*CC.ScreenH/2 then
            local tmpclip={x1=clip.x1, y1=clip.y1-y_off, x2=clip.x2, y2=clip.y2-y_off};
            tmpclip=ClipRect(tmpclip);
            if tmpclip~=nil then
                lib.SetClip(tmpclip.x1,tmpclip.y1,tmpclip.x2,tmpclip.y2);
                WarDrawMap(0)
                for j=0,HitXYNum-1 do
                    DrawString(clips[j].x1, clips[j].y1-y_off, HitXY[j][3],
                               WAR.EffectColor[WAR.Effect],CC.DefaultFont)
                end
            end
        else    --面积太大，直接重绘
            lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);
            WarDrawMap(0)
            for j=0,HitXYNum-1 do
                    DrawString(clips[j].x1, clips[j].y1-y_off, HitXY[j][3],
                               WAR.EffectColor[WAR.Effect],CC.DefaultFont)
            end
        end

        ShowScreen(1);
        lib.SetClip(0,0,0,0);

        local tend=lib.GetTime();
        if (tend-tstart)<CC.Frame then
            lib.Delay(CC.Frame-(tend-tstart));
        end
    end
end

    lib.SetClip(0,0,0,0);
    WarDrawMap(0);
    ShowScreen();
end

--武功伤害生命
--enemyid 敌人战斗id，
--wugong  我方使用武功
--返回：伤害点数
function War_WugongHurtLife(emenyid,wugong,level)             --计算武功伤害生命
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local eid=WAR.Person[emenyid]["人物编号"];

    --计算武学常识
    local mywuxue=0;
    local emenywuxue=0;
    for i=0,WAR.PersonNum-1 do
        local id =WAR.Person[i]["人物编号"]
        if WAR.Person[i]["死亡"]==false and JY.Person[id]["武学常识"]>80 then
            if WAR.Person[WAR.CurID]["我方"]==WAR.Person[i]["我方"] then
                mywuxue=mywuxue+JY.Person[id]["武学常识"];
            else
                emenywuxue=emenywuxue+JY.Person[id]["武学常识"];
            end
        end
    end

    --计算实际使用武功等级
    while true do
        if math.modf((level+1)/2)*JY.Wugong[wugong]["消耗内力点数"] > JY.Person[pid]["内力"] then
            level=level-1;
        else
            break;
        end
    end

    if level<=0 then     --防止出现左右互博时第一次攻击完毕，第二次攻击没有内力的情况。
        level=1;
    end

    --武功武器配合增加攻击力
    local fightnum=0;
    for i,v in ipairs(CC.ExtraOffense) do
        if v[1]==JY.Person[pid]["武器"] and v[2]==wugong then
            fightnum=v[3];
            break;
        end
    end

    --计算攻击力
    fightnum=fightnum+(JY.Person[pid]["攻击力"]*3+JY.Wugong[wugong]["攻击力" .. level ])/2;

    if JY.Person[pid]["武器"]>=0 then
        fightnum=fightnum+JY.Thing[JY.Person[pid]["武器"]]["加攻击力"];
    end
    if JY.Person[pid]["防具"]>=0 then
        fightnum=fightnum+JY.Thing[JY.Person[pid]["防具"]]["加攻击力"];
    end
    fightnum=fightnum+mywuxue;

    --计算防御力
    local defencenum=JY.Person[eid]["防御力"];
    if JY.Person[eid]["武器"]>=0 then
        defencenum=defencenum+JY.Thing[JY.Person[eid]["武器"]]["加防御力"];
    end
    if JY.Person[eid]["防具"]>=0 then
        defencenum=defencenum+JY.Thing[JY.Person[eid]["防具"]]["加防御力"];
    end
    defencenum= defencenum+ emenywuxue;

    --计算实际伤害
    local hurt=(fightnum-3*defencenum)*2/3+Rnd(20)-Rnd(20);
    if hurt <0 then
        hurt=Rnd(10)+1;
    end
    hurt=hurt+JY.Person[pid]["体力"]/15+JY.Person[eid]["受伤程度"]/20;

    --考虑距离因素
    local offset=math.abs(WAR.Person[WAR.CurID]["坐标X"]-WAR.Person[emenyid]["坐标X"])+
                 math.abs(WAR.Person[WAR.CurID]["坐标Y"]-WAR.Person[emenyid]["坐标Y"]);

    if offset <10 then
        hurt=hurt*(100-(offset-1)*3)/100;
    else
        hurt=hurt*2/3;
    end

    hurt=math.modf(hurt);
    if hurt<=0 then
        hurt=Rnd(8)+1;
    end

    JY.Person[eid]["生命"]=JY.Person[eid]["生命"]-hurt;
    WAR.Person[WAR.CurID]["经验"]=WAR.Person[WAR.CurID]["经验"]+math.modf(hurt/5);

    if JY.Person[eid]["生命"]<0 then                 --打死敌人获得额外经验
        JY.Person[eid]["生命"]=0;
        WAR.Person[WAR.CurID]["经验"]=WAR.Person[WAR.CurID]["经验"]+JY.Person[eid]["等级"]*10;
    end

    AddPersonAttrib(eid,"受伤程度",math.modf(hurt/10));

    --敌人中毒点数
    local poisonnum=level*JY.Wugong[wugong]["敌人中毒点数"]+JY.Person[pid]["攻击带毒"];

    if JY.Person[eid]["抗毒能力"]< poisonnum and JY.Person[eid]["抗毒能力"]<90 then
         AddPersonAttrib(eid,"中毒程度",math.modf(poisonnum/15));
    end

    return hurt;
end

--武功伤害内力
--enemyid 敌人战斗id，
--wugong  我方使用武功
--返回：伤害点数
function War_WugongHurtNeili(enemyid,wugong,level)           --计算武功伤害内力
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local eid=WAR.Person[enemyid]["人物编号"];

    local addvalue=JY.Wugong[wugong]["加内力" .. level];
    local decvalue=JY.Wugong[wugong]["杀内力" .. level];

    if addvalue>0 then
        if math.modf(addvalue/2)>0 then
            AddPersonAttrib(pid,"内力最大值",Rnd(math.modf(addvalue/2)));
        end
        AddPersonAttrib(pid,"内力",math.abs(addvalue+Rnd(3)-Rnd(3)));
    end
    return -AddPersonAttrib(eid,"内力",-math.abs(decvalue+Rnd(3)-Rnd(3)));
end

---用毒菜单
function War_PoisonMenu()              ---用毒菜单
    WAR.ShowHead=0;
    local r=War_ExecuteMenu(1);
    WAR.ShowHead=1;
    Cls();
    return r;
end

--计算敌人中毒点数
--pid 使毒人，
--emenyid  中毒人
function War_PoisonHurt(pid,emenyid)     --计算敌人中毒点数
    local v=math.modf((JY.Person[pid]["用毒能力"]-JY.Person[emenyid]["抗毒能力"])/4);
    if v<0 then
        v=0;
    end
    return AddPersonAttrib(emenyid,"中毒程度",v);
end

---解毒菜单
function War_DecPoisonMenu()          ---解毒菜单
    WAR.ShowHead=0;
    local r=War_ExecuteMenu(2);
    WAR.ShowHead=1;
    Cls();
    return r;
end

---医疗菜单
function War_DoctorMenu()            ---医疗菜单
    WAR.ShowHead=0;
    local r=War_ExecuteMenu(3);
    WAR.ShowHead=1;
    Cls();
    return r;
end

---执行医疗，解毒用毒
---flag=1 用毒， 2 解毒，3 医疗 4 暗器
---thingid 暗器物品id
function War_ExecuteMenu(flag,thingid)            ---执行医疗，解毒用毒暗器
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local step;

    if flag==1 then
        step=math.modf(JY.Person[pid]["用毒能力"]/15)+1;         --用毒步数
    elseif flag==2 then
        step=math.modf(JY.Person[pid]["解毒能力"]/15)+1;         --解毒步数
    elseif flag==3 then
        step=math.modf(JY.Person[pid]["医疗能力"]/15)+1;         --医疗步数
    elseif flag==4 then
        step=math.modf(JY.Person[pid]["暗器技巧"]/15)+1;         --暗器步数
    end

    War_CalMoveStep(WAR.CurID,step,1);

    local x1,y1=War_SelectMove();              --选择攻击对象

    if x1 ==nil then
        lib.GetKey();
        Cls();
        return 0;
    else
        return War_ExecuteMenu_Sub(x1,y1,flag,thingid);
    end
end


function War_ExecuteMenu_Sub(x1,y1,flag,thingid)     ---执行医疗，解毒用毒暗器的子函数，自动医疗也可调用
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local x0=WAR.Person[WAR.CurID]["坐标X"];
    local y0=WAR.Person[WAR.CurID]["坐标Y"];

    CleanWarMap(4,0);

    WAR.Person[WAR.CurID]["人方向"]=War_Direct(x0,y0,x1,y1);

    SetWarMap(x1,y1,4,1);

    local emeny=GetWarMap(x1,y1,2);
    if emeny>=0 then          --有人
         if flag==1 then
             if WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[emeny]["我方"] then       --是敌人
                 WAR.Person[emeny]["点数"]=War_PoisonHurt(pid,WAR.Person[emeny]["人物编号"])
                 SetWarMap(x1,y1,4,5);
                 WAR.Effect=5;
             end
         elseif flag==2 then
             if WAR.Person[WAR.CurID]["我方"] == WAR.Person[emeny]["我方"] then       --不是敌人
                 WAR.Person[emeny]["点数"]=ExecDecPoison(pid,WAR.Person[emeny]["人物编号"])
                 SetWarMap(x1,y1,4,6);
                 WAR.Effect=6;
             end
         elseif flag==3 then
             if WAR.Person[WAR.CurID]["我方"] == WAR.Person[emeny]["我方"] then       --不是敌人
                 WAR.Person[emeny]["点数"]=ExecDoctor(pid,WAR.Person[emeny]["人物编号"])
                 SetWarMap(x1,y1,4,4);
                 WAR.Effect=4;
             end
         elseif flag==4 then
             if WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[emeny]["我方"] then       --是敌人
                 WAR.Person[emeny]["点数"]=War_AnqiHurt(pid,WAR.Person[emeny]["人物编号"],thingid)
                 SetWarMap(x1,y1,4,2);
                 WAR.Effect=2;
             end
         end

    end

    WAR.EffectXY={};
    WAR.EffectXY[1]={x1,y1};
    WAR.EffectXY[2]={x1,y1};

    if flag==1 then
        War_ShowFight(pid,0,0,0,x1,y1,30);
    elseif flag==2 then
        War_ShowFight(pid,0,0,0,x1,y1,36);
    elseif flag==3 then
        War_ShowFight(pid,0,0,0,x1,y1,0);
    elseif flag==4 then
        if emeny>=0 then
            War_ShowFight(pid,0,-1,0,x1,y1,JY.Thing[thingid]["暗器动画编号"]);
        end
    end

    for i=0,WAR.PersonNum-1 do
        WAR.Person[i]["点数"]=0;
    end
    if flag==4 then
        if emeny>=0 then
            instruct_32(thingid,-1);            --物品数量减少
            return 1;
        else
            return 0;                   --暗器打空，则等于没有打
        end
    else
        WAR.Person[WAR.CurID]["经验"]=WAR.Person[WAR.CurID]["经验"]+1;
        AddPersonAttrib(pid,"体力",-2);
    end

    return 1;

end


--物品菜单
function War_ThingMenu()            --战斗物品菜单
    WAR.ShowHead=0;
    local thing={};
    local thingnum={};

    for i = 0,CC.MyThingNum-1 do
        thing[i]=-1;
        thingnum[i]=0;
    end

    local num=0;
    for i = 0,CC.MyThingNum-1 do
        local id = JY.Base["物品" .. i+1];
        if id>=0 then
            if JY.Thing[id]["类型"]==3 or JY.Thing[id]["类型"]==4 then
                thing[num]=id;
                thingnum[num]=JY.Base["物品数量" ..i+1];
                num=num+1;
            end
        end
    end

    local r=SelectThing(thing,thingnum);
    Cls();
    local rr=0;
    if r>=0 then
        if UseThing(r)==1 then
            rr=1;
        end
    end
    WAR.ShowHead=1;
    Cls();
    return rr;
end


---使用暗器
function War_UseAnqi(id)          ---战斗使用暗器
    return War_ExecuteMenu(4,id);
end


function War_AnqiHurt(pid,emenyid,thingid)         --计算暗器伤害
    local num;
    if JY.Person[emenyid]["受伤程度"]==0 then
        num=JY.Thing[thingid]["加生命"]/4-Rnd(5);
    elseif JY.Person[emenyid]["受伤程度"]<=33 then
        num=JY.Thing[thingid]["加生命"]/3-Rnd(5);
    elseif JY.Person[emenyid]["受伤程度"]<=66 then
        num=JY.Thing[thingid]["加生命"]/2-Rnd(5);
    else
        num=JY.Thing[thingid]["加生命"]/2-Rnd(5);
    end

    num=math.modf((num-JY.Person[pid]["暗器技巧"]*2)/3);
    AddPersonAttrib(emenyid,"受伤程度",math.modf(-num/4));      --此处的num为负值

    local r=AddPersonAttrib(emenyid,"生命",math.modf(num));

    if JY.Thing[thingid]["加中毒解毒"]>0 then
        num=math.modf((JY.Thing[thingid]["加中毒解毒"]+JY.Person[pid]["暗器技巧"])/2);
        num=num-JY.Person[emenyid]["抗毒能力"];
        num=limitX(num,0,CC.PersonAttribMax["用毒能力"]);
        AddPersonAttrib(emenyid,"中毒程度",num);
    end
    return r;
end

--休息
function War_RestMenu()           --休息
    local pid=WAR.Person[WAR.CurID]["人物编号"];
    local v=3+Rnd(3);
    AddPersonAttrib(pid,"体力",v);
    if JY.Person[pid]["体力"]>30 then
        v=3+Rnd(math.modf(JY.Person[pid]["体力"]/10)-2);
        AddPersonAttrib(pid,"生命",v);
        v=3+Rnd(math.modf(JY.Person[pid]["体力"]/10)-2);
        AddPersonAttrib(pid,"内力",v);
    end
    return 1;
end


--等待，把当前战斗人调到队尾
function War_WaitMenu()            --等待，把当前战斗人调到队尾

    for i =WAR.CurID, WAR.PersonNum-2 do
        local tmp=WAR.Person[i+1];
        WAR.Person[i+1]=WAR.Person[i];
        WAR.Person[i]=tmp;
        --调换人物
    end

    WarSetPerson();     --设置战斗人物位置

    for i=0,WAR.PersonNum-1 do
        WAR.Person[i]["贴图"]=WarCalPersonPic(i);
    end

    return 1;

end



function War_StatusMenu()          --战斗中显示状态
    WAR.ShowHead=0;
    Menu_Status();
    WAR.ShowHead=1;
    Cls();
end

function War_AutoMenu()           --设置自动战斗
    WAR.AutoFight=1;
    WAR.ShowHead=0;
    Cls();
    War_Auto();
    return 1;
end
