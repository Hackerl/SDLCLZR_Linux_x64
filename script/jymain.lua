
----------------------------------------------------------
-----------金庸群侠传复刻之Lua版----------------------------

--版权所无，敬请复制
--您可以随意使用代码

---本代码由游泳的鱼编写

--本模块是lua主模块，由C主程序JYLua.exe调用。C程序主要提供游戏需要的视频、音乐、键盘等API函数，供lua调用。
--游戏的所有逻辑都在lua代码中，以方便大家对代码的修改。
--为加快速度，显示主地图/场景地图/战斗地图部Base分用C API实现。

--导入其他模块。之所以做成函数是为了避免编译查错时编译器会寻找这些模块。
function IncludeFile()              --导入其他模块
    --dofile("config.lua");       --此文件在C函数中预先加载。这里就不加载了
    require(CONFIG.ScriptPath .. "global/jyconst");
    require(CONFIG.ScriptPath .. "global/jymodify");
    require(CONFIG.ScriptPath .. "tool/jycharset"); -- 编码转换相关
end

function RequireFile()
    require(CONFIG.ScriptPath .. "record")
    require(CONFIG.ScriptPath .. "map/mmap")
    require(CONFIG.ScriptPath .. "map/smap")
    require(CONFIG.ScriptPath .. "menu/mmenu")
    require(CONFIG.ScriptPath .. "view/view")
    require(CONFIG.ScriptPath .. "instruct/instruct")
    require(CONFIG.ScriptPath .. "war/war")
end

function SetGlobal()   --设置游戏内部使用的全程变量
   JY={};

   JY.Status=GAME_INIT;  --游戏当前状态

   --保存R×数据
   JY.Base={};           --基本数据
   JY.PersonNum=0;      --人物个数
   JY.Person={};        --人物数据
   JY.ThingNum=0        --物品数量
   JY.Thing={};         --物品数据
   JY.SceneNum=0        --物品数量
   JY.Scene={};         --物品数据
   JY.WugongNum=0        --物品数量
   JY.Wugong={};         --物品数据
   JY.ShopNum=0        --商店数量
   JY.Shop={};         --商店数据

   JY.Data_Base=nil;     --实际保存R*数据
   JY.Data_Person=nil;
   JY.Data_Thing=nil;
   JY.Data_Scene=nil;
   JY.Data_Wugong=nil;
   JY.Data_Shop=nil;

   JY.MyCurrentPic=0;       --主角当前走路贴图在贴图文件中偏移
   JY.MyPic=0;              --主角当前贴图
   JY.MyTick=0;             --主角没有走路的持续帧数
   JY.MyTick2=0;            --显示事件动画的节拍

   JY.EnterSceneXY=nil;     --保存进入场景的坐标，有值可以进入，为nil则重新计算。

   JY.oldMMapX=-1;          --上次显示主地图的坐标。用来判断是否需要全部重绘屏幕
   JY.oldMMapY=-1;
   JY.oldMMapPic=-1;        --上次显示主地图主角贴图

   JY.SubScene=-1;          --当前子场景编号
   JY.SubSceneX=0;          --子场景显示位置偏移，场景移动指令使用
   JY.SubSceneY=0;

   JY.Darkness=0;             --=0 屏幕正常显示，=1 不显示，屏幕全黑

   JY.CurrentD=-1;          --当前调用D*的编号
   JY.OldDPass=-1;          --上次触发路过事件的D*编号, 避免多次触发
   JY.CurrentEventType=-1   --当前触发事件的方式 1 空格 2 物品 3 路过

   JY.oldSMapX=-1;          --上次显示场景地图的坐标。用来判断是否需要全部重绘屏幕
   JY.oldSMapY=-1;
   JY.oldSMapXoff=-1;       --上次场景偏移
   JY.oldSMapYoff=-1;
   JY.oldSMapPic=-1;        --上次显示场景地图主角贴图

   JY.D_Valid=nil           --记录当前场景有效的D的编号，提高速度，不用每次显示都计算了。若为nil则重新计算
   JY_D_Valld_Num=0;        --当前场景有效的D个数

   JY.D_PicChange={}        --记录事件动画改变，以计算Clip
   JY.NumD_PicChange=0;     --事件动画改变的个数

   JY.CurrentThing=-1;      --当前选择物品，触发事件使用

   JY.MmapMusic=-1;         --切换大地图音乐，返回主地图时，如果设置，则播放此音乐

   JY.CurrentMIDI=-1;       --当前播放的音乐id，用来在关闭音乐时保存音乐id。
   JY.EnableMusic=1;        --是否播放音乐 1 播放，0 不播放
   JY.EnableSound=1;        --是否播放音效 1 播放，0 不播放

   JY.ThingUseFunction={};          --物品使用时调用函数，SetModify函数使用，增加新类型的物品
   JY.SceneNewEventFunction={};     --调用场景事件函数，SetModify函数使用，定义使用新场景事件触发的函数

   WAR={};     --战斗使用的全程变量。。这里占个位置，因为程序后面不允许定义全局变量了。具体内容在WarSetGlobal函数中
end

function JY_Main()        --主程序入口
	os.remove("debug.txt");        --清除以前的debug输出
    xpcall(JY_Main_sub,myErrFun);     --捕获调用错误
end

function myErrFun(err)      --错误处理，打印错误信息
    lib.Debug(err);                 --输出错误信息
    lib.Debug(debug.traceback());   --输出调用堆栈信息
end

function JY_Main_sub()        --真正的游戏主程序入口
    IncludeFile();         --导入其他模块
    SetGlobalConst();    --设置全程变量CC, 程序使用的常量
    SetGlobal();         --设置全程变量JY

    RequireFile()
    GenTalkIdx();        --生成对话idx

    SetModify();         --设置对函数的修改，定义新的物品，事件等等

    --禁止访问全程变量
    setmetatable(_G,{ __newindex =function (_,n)
                       error("attempt read write to undeclared variable " .. n,2);
                       end,
                       __index =function (_,n)
                       error("attempt read read to undeclared variable " .. n,2);
                       end,
                     }  );
    lib.Debug("JY_Main start.");

	math.randomseed(os.time());          --初始化随机数发生器

	lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRePeatInterval);   --设置键盘重复率

    JY.Status=GAME_START;

    lib.PicInit(CC.PaletteFile);       --加载原来的256色调色板

    -- 开始动画
    -- lib.PlayMPEG(CONFIG.DataPath .. "start.mpg",VK_ESCAPE);

	Cls();

    PlayMIDI(16);
	lib.ShowSlow(50,0);

	local menu={  {"重新开始",nil,1},
	              {"载入进度",nil,1},
	              {"离开游戏",nil,1}  };
	local menux=(CC.ScreenW-4*CC.StartMenuFontSize-2*CC.MenuBorderPixel)/2

	local menuReturn=ShowMenu(menu,3,0,menux,CC.StartMenuY,0,0,0,0,CC.StartMenuFontSize,C_STARTMENU, C_RED)

    if menuReturn == 1 then        --重新开始游戏
		Cls();
		DrawString(menux,CC.StartMenuY,"请稍候...",C_RED,CC.StartMenuFontSize);
		ShowScreen();

		NewGame();          --设置新游戏数据

        JY.SubScene=CC.NewGameSceneID;         --新游戏直接进入场景
        JY.Scene[JY.SubScene]["名称"]=JY.Person[0]["姓名"] .. "居";
        JY.Base["人X1"]=CC.NewGameSceneX;
        JY.Base["人Y1"]=CC.NewGameSceneY;
        JY.MyPic=CC.NewPersonPic;

        lib.ShowSlow(50,1)
		JY.Status=GAME_SMAP;
        JY.MMAPMusic=-1;

 	    CleanMemory();

		Init_SMap(0);

        if CC.NewGameEvent>0 then
		   oldCallEvent(CC.NewGameEvent);
	    end

	elseif menuReturn == 2 then         --载入旧的进度
		Cls();
    	local loadMenu={ {"进度一",nil,1},
	                     {"进度二",nil,1},
	                     {"进度三",nil,1} };

	    local menux=(CC.ScreenW-3*CC.StartMenuFontSize-2*CC.MenuBorderPixel)/2

    	local r=ShowMenu(loadMenu,3,0,menux,CC.StartMenuY,0,0,0,0,CC.StartMenuFontSize,C_STARTMENU, C_RED)
		Cls();
		DrawString(menux,CC.StartMenuY,"请稍候...",C_RED,CC.StartMenuFontSize);
		ShowScreen();
        LoadRecord(r);

-- 修改数据
    JY.Person[0]["内力最大值"] = 9999;
    JY.Person[0]["生命最大值"]= 999;
    JY.Person[0]["资质"] = 100;
    JY.Person[0]["左右互搏"] = 1;
    JY.Person[0]["内力性质"] = 0;
    JY.Person[0]["生命"]=JY.Person[0]["生命最大值"];
    JY.Person[0]["内力"]=JY.Person[0]["内力最大值"];

    JY.Person[0]["武功1"] = 0x6D
    JY.Person[0]["武功等级1"] = 900
    JY.Person[0]["武功2"] = 0x6A
    JY.Person[0]["武功等级2"] = 900
    JY.Person[0]["武功3"] = 0x1A
    JY.Person[0]["武功等级3"] = 900
    JY.Person[0]["武功4"] = 0x2F
    JY.Person[0]["武功等级4"] = 900
    JY.Person[0]["武功5"] = 0x6b
    JY.Person[0]["武功等级5"] = 900
    JY.Person[0]["武功6"] = 0x6c
    JY.Person[0]["武功等级6"] = 900

    Cls();
    ShowScreen();
    JY.Status=GAME_FIRSTMMAP;

	elseif menuReturn == 3 then
        return ;
	end
	lib.LoadPicture("",0,0);
    lib.GetKey();
    Game_Cycle();
end

function CleanMemory()            --清理lua内存
    if CONFIG.CleanMemory==1 then
		 collectgarbage("collect");
		 --lib.Debug(string.format("Lua memory=%d",collectgarbage("count")));
    end
end

function NewGame()     --选择新游戏，设置主角初始属性
    LoadRecord(0); --  载入新游戏数据
    JY.Person[0]["姓名"]=CC.NewPersonName;

    while true do
        JY.Person[0]["内力性质"]=Rnd(2);
        JY.Person[0]["内力最大值"]=Rnd(20)+21;
        JY.Person[0]["攻击力"]=Rnd(10)+21;
        JY.Person[0]["防御力"]=Rnd(10)+21;
        JY.Person[0]["轻功"]=Rnd(10)+21;
        JY.Person[0]["医疗能力"]=Rnd(10)+21;
        JY.Person[0]["用毒能力"]=Rnd(10)+21;
        JY.Person[0]["解毒能力"]=Rnd(10)+21;
        JY.Person[0]["抗毒能力"]=Rnd(10)+21;
        JY.Person[0]["拳掌功夫"]=Rnd(10)+21;
        JY.Person[0]["御剑能力"]=Rnd(10)+21;
        JY.Person[0]["耍刀技巧"]=Rnd(10)+21;
        JY.Person[0]["特殊兵器"]=Rnd(10)+21;
        JY.Person[0]["暗器技巧"]=Rnd(10)+21;
        JY.Person[0]["生命增长"]=Rnd(5)+3;
        JY.Person[0]["生命最大值"]= JY.Person[0]["生命增长"]*3+29;

        local rate=Rnd(10);
        if rate<2 then
            JY.Person[0]["资质"]=Rnd(35)+30;
        elseif rate<=7 then
            JY.Person[0]["资质"]=Rnd(20)+60;
        else
            JY.Person[0]["资质"]=Rnd(20)+75;
        end

        JY.Person[0]["生命"]=JY.Person[0]["生命最大值"];
        JY.Person[0]["内力"]=JY.Person[0]["内力最大值"];

        Cls();

        local fontsize=CC.NewGameFontSize;

        local h=fontsize+CC.RowPixel;
        local w=fontsize*4;
		local x1=(CC.ScreenW-w*4)/2;
        local y1=CC.NewGameY;
        local i=0;

        local function DrawAttrib(str1,str2)    --定义内部函数
            DrawString(x1+i*w,y1,str1,C_RED,fontsize);
            DrawString(x1+i*w+fontsize*2,y1,string.format("%3d ",JY.Person[0][str2]),C_WHITE,fontsize);
            i=i+1;
        end

        DrawString(x1,y1,"这样的属性满意吗(Y/N)?",C_GOLD,fontsize);
        i=0; y1=y1+h;
		DrawAttrib("内力","内力"); DrawAttrib("攻击","攻击力"); DrawAttrib("轻功","轻功");  DrawAttrib("防御","防御力");
        i=0; y1=y1+h;
		DrawAttrib("生命","生命"); DrawAttrib("医疗","医疗能力");DrawAttrib("用毒","用毒能力"); DrawAttrib("解毒","解毒能力");
        i=0; y1=y1+h;
        DrawAttrib("拳掌","拳掌功夫"); DrawAttrib("御剑","御剑能力");  DrawAttrib("耍刀","耍刀技巧"); DrawAttrib("暗器","暗器技巧");

        ShowScreen();

		local menu={{"是 ",nil,1},
		            {"否 ",nil,2},
			       };
        local ok=ShowMenu2(menu,2,0,x1+11*fontsize,CC.NewGameY-CC.MenuBorderPixel,0,0,0,0,fontsize,C_RED, C_WHITE)
        if ok==1 then
            break;
        end
    end
end

function Game_Cycle()       --游戏主循环
    lib.Debug("Start game cycle");

    while JY.Status ~=GAME_END do
        local tstart=lib.GetTime();

	    JY.MyTick=JY.MyTick+1;    --20个节拍无击键，则主角变为站立状态
	    JY.MyTick2=JY.MyTick2+1;    --20个节拍无击键，则主角变为站立状态

		if JY.MyTick==20 then
            JY.MyCurrentPic=0;
			JY.MyTick=0;
		end

        if JY.MyTick2==1000 then
            JY.MYtick2=0;
        end

        if JY.Status==GAME_FIRSTMMAP then  --首次显示主场景，重新调用主场景贴图，渐变显示。然后转到正常显示
			CleanMemory();
            lib.ShowSlow(50,1)
            JY.MmapMusic=16;
            JY.Status=GAME_MMAP;

            Init_MMap();

            lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],GetMyPic());
			lib.ShowSlow(50,0);
        elseif JY.Status==GAME_MMAP then
            Game_MMap();
 		elseif JY.Status==GAME_SMAP then
            Game_SMap()
		end

		collectgarbage("step",0);

		local tend=lib.GetTime();

		if tend-tstart<CC.Frame then
            lib.Delay(CC.Frame-(tend-tstart));
	    end
	end
end

function Cal_D_Valid()     --计算200个D中有效的D
    if JY.D_Valid~=nil then
	    return ;
	end

    local sceneid=JY.SubScene;
	JY.D_Valid={};
	JY.D_Valid_Num=0;
    for i=0,CC.DNum-1 do
        local x=GetD(sceneid,i,9);
        local y=GetD(sceneid,i,10);
        local v=GetS(sceneid,x,y,3);
		if v>=0 then
            JY.D_Valid[JY.D_Valid_Num]=i;
			JY.D_Valid_Num=JY.D_Valid_Num+1;
		end
	end
end

function DtoSMap()          ---D*中的事件处理动画效果。
    local sceneid=JY.SubScene;
    JY.NumD_PicChange=0;
    JY.D_PicChange={};

	if JY.D_Valid==nil then
	    Cal_D_Valid();
	end

	for k=0,JY.D_Valid_Num-1 do
	    local i=JY.D_Valid[k];

		local p1=GetD(sceneid,i,5);
		if p1>0 then
			local p2=GetD(sceneid,i,6);
			local p3=GetD(sceneid,i,7);
			if p1 ~= p2 then
				local old_p3=p3;
				local delay=GetD(sceneid,i,8);
				if not (p3>=CC.SceneFlagPic[1]*2 and p3<=CC.SceneFlagPic[2]*2 and CC.ShowFlag==0) then --是否显示旗帜
					if p3<=p1 then     --动画已停止
						if JY.MyTick2 %100 > delay then
							p3=p3+2;
						end
					else
						if JY.MyTick2 % 4 ==0 then      --4个节拍动画增加一次
							p3=p3+2;
						end
					end
					if p3>p2 then
						 p3=p1;
					end
				end
				if old_p3 ~=p3 then    --动画改变了，增加一个
                    local x=GetD(sceneid,i,9);
                    local y=GetD(sceneid,i,10);
					local dy=GetS(sceneid,x,y,4);       --海拔
					JY.D_PicChange[JY.NumD_PicChange]={x=x, y=y, dy=dy, p1=old_p3/2, p2=p3/2}
					JY.NumD_PicChange=JY.NumD_PicChange+1;
					SetD(sceneid,i,7,p3);
				end
			end
		end
    end
end

--fastdraw = 0 or nil 全部重绘。用于事件中
--           1 考虑脏矩形 用于显示场景循环
function DrawSMap(fastdraw)         --绘场景地图
    if fastdraw==nil then
	    fastdraw=0;
	end
	local x0=JY.SubSceneX+JY.Base["人X1"]-1;    --绘图中心点
	local y0=JY.SubSceneY+JY.Base["人Y1"]-1;

	local x=limitX(x0,CC.SceneXMin,CC.SceneXMax)-JY.Base["人X1"];
	local y=limitX(y0,CC.SceneYMin,CC.SceneYMax)-JY.Base["人Y1"];

    if fastdraw==0 then
		lib.DrawSMap(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],x,y,JY.MyPic);
    else
		if JY.oldSMapX>=0 and JY.oldSMapY>=0 and
		   JY.oldSMapX+JY.oldSMapXoff==JY.Base["人X1"]+x and         --绘图中心点不变，人走路也可以用裁剪方式绘图
		   JY.oldSMapY+JY.oldSMapYoff==JY.Base["人Y1"]+y then

			local num_clip=0;
			local clip={};

			for i=0,JY.NumD_PicChange-1 do   --计算D*中贴图改变的矩形
			    local dx=JY.D_PicChange[i].x-JY.Base["人X1"]-x;
				local dy=JY.D_PicChange[i].y-JY.Base["人Y1"]-y;
				clip[num_clip]=Cal_PicClip(dx,dy,JY.D_PicChange[i].p1,0,
										   dx,dy,JY.D_PicChange[i].p2,0 );
				clip[num_clip].y1=clip[num_clip].y1-JY.D_PicChange[i].dy
				clip[num_clip].y2=clip[num_clip].y2-JY.D_PicChange[i].dy
				num_clip=num_clip+1;
			end

			if JY.oldSMapPic>=0 then  --计算主角矩形
			    if not ( JY.oldSMapX==JY.Base["人X1"] and    --主角有变化
				         JY.oldSMapY==JY.Base["人Y1"] and
						 JY.oldSMapPic==JY.MyPic ) then
					local dy1=GetS(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],4);   --海拔
					local dy2=GetS(JY.SubScene,JY.oldSMapX,JY.oldSMapY,4);
					local dy=math.max(dy1,dy2);
					clip[num_clip]=Cal_PicClip(-JY.oldSMapXoff,-JY.oldSMapYoff,JY.oldSMapPic,0,
												-x,-y,JY.MyPic,0)
					clip[num_clip].y1=clip[num_clip].y1- dy;
					clip[num_clip].y2=clip[num_clip].y2- dy;
					num_clip=num_clip+1;
				end
			end

			local area=0;          --计算所有脏矩形面积
			for i=0,num_clip-1 do
				clip[i]=ClipRect(clip[i]);    --矩形屏幕剪裁
				if clip[i]~=nil then
					area=area+(clip[i].x2-clip[i].x1)*(clip[i].y2-clip[i].y1)
				end
			end

			if area <CC.ScreenW*CC.ScreenH/2 and num_clip<15 then        --面积足够小，矩形数目少，则更新脏矩形。
				for i=0,num_clip-1 do
					if clip[i]~=nil then
						lib.SetClip(clip[i].x1,clip[i].y1,clip[i].x2,clip[i].y2);
						lib.DrawSMap(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],x,y,JY.MyPic);
					end
				end
			else    --面积太大，直接重绘
				lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);   --由于redraw=0，必须给出裁剪矩形以后才能ShowSurface
				lib.DrawSMap(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],x,y,JY.MyPic);
			end
		else
			lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);
			lib.DrawSMap(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],x,y,JY.MyPic);
		end
    end

	JY.oldSMapX=JY.Base["人X1"];
	JY.oldSMapY=JY.Base["人Y1"];
	JY.oldSMapPic=JY.MyPic;
    JY.oldSMapXoff=x;
    JY.oldSMapYoff=y;
end



-------------------------------------------------------------------------------------
-----------------------------------通用函数-------------------------------------------

function filelength(filename)         --得到文件长度
    local inp=io.open(filename,"rb");
    local l= inp:seek("end");
	inp:close();
    return l;
end

--读S×数据, (x,y) 坐标，level 层 0-5
function GetS(id,x,y,level)       --读S×数据
    return lib.GetS(id,x,y,level);
end

--写S×
function SetS(id,x,y,level,v)       --写S×
    lib.SetS(id,x,y,level,v);
end

--读D*
--sceneid 场景编号，
--id D*编号
--要读第几个数据, 0-10
function GetD(Sceneid,id,i)          --读D*
    return lib.GetD(Sceneid,id,i);
end

--写D×
function SetD(Sceneid,id,i,v)         --写D×
    lib.SetD(Sceneid,id,i,v);
end



--按照t_struct 定义的结构把数据从data二进制串中读到表t中
function LoadData(t,t_struct,data)        --data二进制串中读到表t中
    for k,v in pairs(t_struct) do
        if v[2]==0 then
            t[k]=Byte.get16(data,v[1]);
        elseif v[2]==1 then
            t[k]=Byte.getu16(data,v[1]);
		elseif v[2]==2 then
            if CC.SrcCharSet==0 then
                t[k]=change_charsert(Byte.getstr(data,v[1],v[3]),0);
		    else
		        t[k]=Byte.getstr(data,v[1],v[3]);
		    end
		end
	end
end

--按照t_struct 定义的结构把数据写入data Byte数组中。
function SaveData(t,t_struct,data)      --数据写入data Byte数组中。
    for k,v in pairs(t_struct) do
        if v[2]==0 then
            Byte.set16(data,v[1],t[k]);
		elseif v[2]==1 then
            Byte.setu16(data,v[1],t[k]);
		elseif v[2]==2 then
		    local s;
			if CC.SrcCharSet==0 then
			    s=change_charsert(t[k],1);
            else
			    s=t[k];
		    end
            Byte.setstr(data,v[1],v[3],s);
		end
	end
end

function limitX(x,minv,maxv)       --限制x的范围
    if x<minv then
	    x=minv;
	elseif x>maxv then
	    x=maxv;
	end
	return x
end

function RGB(r,g,b)          --设置颜色RGB
   return r*65536+g*256+b;
end

function GetRGB(color)      --分离颜色的RGB分量
    color=color%(65536*256);
    local r=math.floor(color/65536);
    color=color%65536;
    local g=math.floor(color/256);
    local b=color%256;
    return r,g,b
end

--等待键盘输入
function WaitKey()       --等待键盘输入
    local keyPress=-1;
    while true do
		keyPress=lib.GetKey();
		if keyPress ~=-1 then
	         break;
	    end
        lib.Delay(20);
	end
	return keyPress;
end

--绘制一个带背景的白色方框，四角凹进
function DrawBox(x1,y1,x2,y2,color)         --绘制一个带背景的白色方框
    local s=4;
    lib.Background(x1,y1+s,x1+s,y2-s,128);    --阴影，四角空出
    lib.Background(x1+s,y1,x2-s,y2,128);
    lib.Background(x2-s,y1+s,x2,y2-s,128);
    local r,g,b=GetRGB(color);
    DrawBox_1(x1+1,y1+1,x2,y2,RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2)));
    DrawBox_1(x1,y1,x2-1,y2-1,color);
end

--绘制四角凹进的方框
function DrawBox_1(x1,y1,x2,y2,color)       --绘制四角凹进的方框
    local s=4;
    lib.DrawRect(x1+s,y1,x2-s,y1,color);
    lib.DrawRect(x2-s,y1,x2-s,y1+s,color);
    lib.DrawRect(x2-s,y1+s,x2,y1+s,color);
    lib.DrawRect(x2,y1+s,x2,y2-s,color);
    lib.DrawRect(x2,y2-s,x2-s,y2-s,color);
    lib.DrawRect(x2-s,y2-s,x2-s,y2,color);
    lib.DrawRect(x2-s,y2,x1+s,y2,color);
    lib.DrawRect(x1+s,y2,x1+s,y2-s,color);
    lib.DrawRect(x1+s,y2-s,x1,y2-s,color);
    lib.DrawRect(x1,y2-s,x1,y1+s,color);
    lib.DrawRect(x1,y1+s,x1+s,y1+s,color);
    lib.DrawRect(x1+s,y1+s,x1+s,y1,color);
end

--显示阴影字符串
function DrawString(x,y,str,color,size)         --显示阴影字符串
--    local r,g,b=GetRGB(color);
--    lib.DrawStr(x+1,y+1,str,RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2)),size,CC.FontName,CC.SrcCharSet,CC.OSCharSet);
    lib.DrawStr(x,y,str, color,size,CC.FontName);
end

--显示带框的字符串
--(x,y) 坐标，如果都为-1,则在屏幕中间显示
function DrawStrBox(x,y,str,color,size)         --显示带框的字符串
    local ll = get_show_width(str);
    local w=size*ll/2+2*CC.MenuBorderPixel;
	local h=size+2*CC.MenuBorderPixel;
	if x==-1 then
        x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
	end
	if y==-1 then
        y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2;
	end

    DrawBox(x,y,x+w-1,y+h-1,C_WHITE);
    DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel,str,color,size);
end

--显示并询问Y/N，如果点击Y，则返回true, N则返回false
--(x,y) 坐标，如果都为-1,则在屏幕中间显示
--改为用菜单询问是否
function DrawStrBoxYesNo(x,y,str,color,size)        --显示字符串并询问Y/N
    lib.GetKey();
    local ll = get_show_width(str);
    local w=size*ll/2+2*CC.MenuBorderPixel;
	local h=size+2*CC.MenuBorderPixel;
	if x==-1 then
        x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
	end
	if y==-1 then
        y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2;
	end

    DrawStrBox(x,y,str,color,size);
    local menu={{"确定/是",nil,1},
	            {"取消/否",nil,2}};

	local r=ShowMenu(menu,2,0,x+w-4*size-2*CC.MenuBorderPixel,y+h+CC.MenuBorderPixel,0,0,1,0,CC.DefaultFont,C_ORANGE, C_WHITE)

    if r==1 then
	    return true;
	else
	    return false;
	end

end


--显示字符串并等待击键，字符串带框，显示在屏幕中间
function DrawStrBoxWaitKey(s,color,size)          --显示字符串并等待击键
    lib.GetKey();
    Cls();
    DrawStrBox(-1,-1,s,color,size);
    ShowScreen();
    WaitKey();
end

--返回 [0 , i-1] 的整形随机数
function Rnd(i)           --随机数
    local r=math.random(i);
    return r-1;
end

--增加人物属性，如果有最大值限制，则应用最大值限制。最小值则限制为0
--id 人物id
--str属性字符串
--value 要增加的值，负数表示减少
--返回1,实际增加的值
--返回2，字符串：xxx 增加/减少 xxxx，用于显示药品效果
function AddPersonAttrib(id,str,value)            --增加人物属性
    local oldvalue=JY.Person[id][str];
    local attribmax=math.huge;
    if str=="生命" then
        attribmax=JY.Person[id]["生命最大值"] ;
    elseif str=="内力" then
        attribmax=JY.Person[id]["内力最大值"] ;
    else
        if CC.PersonAttribMax[str] ~= nil then
            attribmax=CC.PersonAttribMax[str];
        end
    end
    local newvalue=limitX(oldvalue+value,0,attribmax);
    JY.Person[id][str]=newvalue;
    local add=newvalue-oldvalue;

    local showstr="";
    if add>0 then
        showstr=string.format("%s 增加 %d",str,add);
    elseif add<0 then
        showstr=string.format("%s 减少 %d",str,-add);
    end
    return add,showstr;
end

--播放midi
function PlayMIDI(id)             --播放midi
    JY.CurrentMIDI=id;
    if JY.EnableMusic==0 then
        return ;
    end
    if id>=0 then
        lib.PlayMIDI(string.format(CC.MIDIFile,id));
    end
end

--播放音效atk***
function PlayWavAtk(id)             --播放音效atk***
    if JY.EnableSound==0 then
        return ;
    end
    if id>=0 then
        lib.PlayWAV(string.format(CC.ATKFile,id));
    end
end

--播放音效e**
function PlayWavE(id)              --播放音效e**
    if JY.EnableSound==0 then
        return ;
    end
    if id>=0 then
        lib.PlayWAV(string.format(CC.EFile,id));
    end
end

--flag =0 or nil 全部刷新屏幕
--      1 考虑脏矩形的快速刷新
function ShowScreen(flag)              --刷新屏幕显示
    if JY.Darkness==0 then
	    if flag==nil then
		    flag=0;
		end
	    lib.ShowSurface(flag);
    end
end

--通用菜单函数
-- menuItem 表，每项保存一个子表，内容为一个菜单项的定义
--          菜单项定义为  {   ItemName,     菜单项名称字符串
--                          ItemFunction, 菜单调用函数，如果没有则为nil
--                          Visible       是否可见  0 不可见 1 可见, 2 可见，作为当前选择项。只能有一个为2，
--                                        多了则只取第一个为2的，没有则第一个菜单项为当前选择项。
--                                        在只显示部分菜单的情况下此值无效。
--                                        此值目前只用于是否菜单缺省显示否的情况
--                       }
--          菜单调用函数说明：         itemfunction(newmenu,id)
--
--       返回值
--              0 正常返回，继续菜单循环 1 调用函数要求退出菜单，不进行菜单循环
--
-- numItem      总菜单项个数
-- numShow      显示菜单项目，如果总菜单项很多，一屏显示不下，则可以定义此值
--                =0表示显示全部菜单项

-- (x1,y1),(x2,y2)  菜单区域的左上角和右下角坐标，如果x2,y2=0,则根据字符串长度和显示菜单项自动计算x2,y2
-- isBox        是否绘制边框，0 不绘制，1 绘制。若绘制，则按照(x1,y1,x2,y2)的矩形绘制白色方框，并使方框内背景变暗
-- isEsc        Esc键是否起作用 0 不起作用，1起作用
-- Size         菜单项字体大小
-- color        正常菜单项颜色，均为RGB
-- selectColor  选中菜单项颜色,
--;
-- 返回值  0 Esc返回
--         >0 选中的菜单项(1表示第一项)
--         <0 选中的菜单项，调用函数要求退出父菜单，这个用于退出多层菜单

function ShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)     --通用菜单函数
    local w=0;
    local h=0;   --边框的宽高
    local i=0;
    local num=0;     --实际的显示菜单项
    local newNumItem=0;  --能够显示的总菜单项数

    lib.GetKey();

    local newMenu={};   -- 定义新的数组，以保存所有能显示的菜单项

    --计算能够显示的总菜单项数
    for i=1,numItem do
        if menuItem[i][3]>0 then
            newNumItem=newNumItem+1;
            newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i};   --新数组多了[4],保存和原数组的对应
        end
    end

    --计算实际显示的菜单项数
    if numShow==0 or numShow > newNumItem then
        num=newNumItem;
    else
        num=numShow;
    end

    --计算边框实际宽高
    local maxlength=0;
    if x2==0 and y2==0 then
        for i=1,newNumItem do
            if get_show_width(newMenu[i][1]) > maxlength then
                maxlength=get_show_width(newMenu[i][1]);
            end
        end
        w=size*maxlength/2+2*CC.MenuBorderPixel;        --按照半个汉字计算宽度，一边留4个象素
        h=(size+CC.RowPixel)*num+CC.MenuBorderPixel;            --字之间留4个象素，上面再留4个象素
    else
        w=x2-x1;
        h=y2-y1;
    end

    local start=1;             --显示的第一项

	local current =1;          --当前选择项
	for i=1,newNumItem do
	    if newMenu[i][3]==2 then
		    current=i;
			break;
		end
	end
	if numShow~=0 then
	    current=1;
	end

    local keyPress =-1;
    local returnValue =0;
	if isBox==1 then
		DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
	end

    while true do
	    if numShow ~=0 then
	        Cls(x1,y1,x1+w,y1+h);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		end

	    for i=start,start+num-1 do
  	        local drawColor=color;           --设置不同的绘制颜色
	        if i==current then
	            drawColor=selectColor;
	        end
			DrawString(x1+CC.MenuBorderPixel,y1+CC.MenuBorderPixel+(i-start)*(size+CC.RowPixel),
			           newMenu[i][1],drawColor,size);

	    end
	    ShowScreen();
		keyPress=WaitKey();
		lib.Delay(100);
		if keyPress==VK_ESCAPE then                  --Esc 退出
		    if isEsc==1 then
		        break;
		    end
		elseif keyPress==VK_DOWN then                --Down
		    current = current +1;
		    if current > (start + num-1) then
		        start=start+1;
		    end
		    if current > newNumItem then
		        start=1;
		        current =1;
		    end
		elseif keyPress==VK_UP then                  --Up
		    current = current -1;
		    if current < start then
		        start=start-1;
		    end
		    if current < 1 then
		        current = newNumItem;
		        start =current-num+1;
		    end
		elseif   (keyPress==VK_SPACE) or (keyPress==VK_RETURN)  then
		    if newMenu[current][2]==nil then
		        returnValue=newMenu[current][4];
		        break;
		    else
		        local r=newMenu[current][2](newMenu,current);               --调用菜单函数
		        if r==1 then
		            returnValue= -newMenu[current][4];
		            break;
				else
			        Cls(x1,y1,x1+w,y1+h);
					if isBox==1 then
						DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
					end
		        end
		    end
		end
    end

    Cls(x1,y1,x1+w+1,y1+h+1,0,1);

    return returnValue;
end

--横向显示菜单，参数和ShowMenu一样
function ShowMenu2(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)     --通用菜单函数
    local w=0;
    local h=0;   --边框的宽高
    local i=0;
    local num=0;     --实际的显示菜单项
    local newNumItem=0;  --能够显示的总菜单项数

    lib.GetKey();

    local newMenu={};   -- 定义新的数组，以保存所有能显示的菜单项

    --计算能够显示的总菜单项数
    for i=1,numItem do
        if menuItem[i][3]>0 then
            newNumItem=newNumItem+1;
            newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i};   --新数组多了[4],保存和原数组的对应
        end
    end

    --计算实际显示的菜单项数
    if numShow==0 or numShow > newNumItem then
        num=newNumItem;
    else
        num=numShow;
    end

    --计算边框实际宽高
    local maxlength=0;
    if x2==0 and y2==0 then
        for i=1,newNumItem do
            if get_show_width(newMenu[i][1])>maxlength then
                maxlength=get_show_width(newMenu[i][1]);
            end
        end
		w=(size*maxlength/2+CC.RowPixel)*num+CC.MenuBorderPixel;
		h=size+2*CC.MenuBorderPixel;
    else
        w=x2-x1;
        h=y2-y1;
    end

    local start=1;             --显示的第一项

    local current =1;          --当前选择项
	for i=1,newNumItem do
	    if newMenu[i][3]==2 then
		    current=i;
			break;
		end
	end
	if numShow~=0 then
	    current=1;
	end

    local keyPress =-1;
    local returnValue =0;
	if isBox==1 then
		DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
	end
    while true do
	    if numShow ~=0 then
	        Cls(x1,y1,x1+w,y1+h);
			if isBox==1 then
				DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
			end
		end

	    for i=start,start+num-1 do
  	        local drawColor=color;           --设置不同的绘制颜色
	        if i==current then
	            drawColor=selectColor;
	        end
			DrawString(x1+CC.MenuBorderPixel+(i-start)*(size*maxlength/2+CC.RowPixel),
			           y1+CC.MenuBorderPixel,newMenu[i][1],drawColor,size);
	    end
	    ShowScreen();
		keyPress=WaitKey();
		lib.Delay(100);

		if keyPress==VK_ESCAPE then                  --Esc 退出
		    if isEsc==1 then
		        break;
		    end
		elseif keyPress==VK_RIGHT then                --Down
		    current = current +1;
		    if current > (start + num-1) then
		        start=start+1;
		    end
		    if current > newNumItem then
		        start=1;
		        current =1;
		    end
		elseif keyPress==VK_LEFT then                  --Up
		    current = current -1;
		    if current < start then
		        start=start-1;
		    end
		    if current < 1 then
		        current = newNumItem;
		        start =current-num+1;
		    end
		elseif   (keyPress==VK_SPACE) or (keyPress==VK_RETURN)  then
		    if newMenu[current][2]==nil then
		        returnValue=newMenu[current][4];
		        break;
		    else
		        local r=newMenu[current][2](newMenu,current);               --调用菜单函数
		        if r==1 then
		            returnValue= -newMenu[current][4];
		            break;
				else
			        Cls(x1,y1,x1+w,y1+h);
					if isBox==1 then
						DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
					end
		        end
		    end
		end
    end

    Cls(x1,y1,x1+w+1,y1+h+1,0,1);
    return returnValue;
end

------------------------------------------------------------------------------------
--------------------------------------物品使用---------------------------------------
--物品使用模块
--当前物品id
--返回1 使用了物品， 0 没有使用物品。可能是某些原因不能使用
function UseThing(id)             --物品使用
    --调用函数
	if JY.ThingUseFunction[id]==nil then
	    return DefaultUseThing(id);
	else
        return JY.ThingUseFunction[id](id);
    end
end

--缺省物品使用函数，实现原始游戏效果
--id 物品id
function DefaultUseThing(id)                --缺省物品使用函数
    if JY.Thing[id]["类型"]==0 then
        return UseThing_Type0(id);
    elseif JY.Thing[id]["类型"]==1 then
        return UseThing_Type1(id);
    elseif JY.Thing[id]["类型"]==2 then
        return UseThing_Type2(id);
    elseif JY.Thing[id]["类型"]==3 then
        return UseThing_Type3(id);
    elseif JY.Thing[id]["类型"]==4 then
        return UseThing_Type4(id);
    end
end

--剧情物品，触发事件
function UseThing_Type0(id)              --剧情物品使用
    if JY.SubScene>=0 then
		local x=JY.Base["人X1"]+CC.DirectX[JY.Base["人方向"]+1];
		local y=JY.Base["人Y1"]+CC.DirectY[JY.Base["人方向"]+1];
        local d_num=GetS(JY.SubScene,x,y,3)
        if d_num>=0 then
            JY.CurrentThing=id;
            EventExecute(d_num,2);       --物品触发事件
            JY.CurrentThing=-1;
			return 1;
		else
		    return 0;
        end
    end
end

--装备物品
function UseThing_Type1(id)            --装备物品使用
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,string.format("谁要配备%s?",JY.Thing[id]["名称"]),C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    local r=SelectTeamMenu(CC.MainSubMenuX,nexty);

    if r>0 then
        local personid=JY.Base["队伍" ..r]
        if CanUseThing(id,personid) then
            if JY.Thing[id]["装备类型"]==0 then
                if JY.Thing[id]["使用人"]>=0 then
                    JY.Person[JY.Thing[id]["使用人"]]["武器"]=-1;
                end
                if JY.Person[personid]["武器"]>=0 then
                    JY.Thing[JY.Person[personid]["武器"]]["使用人"]=-1
                end
                JY.Person[personid]["武器"]=id;
            elseif JY.Thing[id]["装备类型"]==1 then
                if JY.Thing[id]["使用人"]>=0 then
                    JY.Person[JY.Thing[id]["使用人"]]["防具"]=-1;
                end
                if JY.Person[personid]["防具"]>=0 then
                    JY.Thing[JY.Person[personid]["防具"]]["使用人"]=-1
                end
                JY.Person[personid]["防具"]=id;
            end
            JY.Thing[id]["使用人"]=personid
        else
            DrawStrBoxWaitKey("此人不适合配备此物品",C_WHITE,CC.DefaultFont);
			return 0;
        end
    end
--    Cls();
--    ShowScreen();
	return 1;
end

--判断一个人是否可以装备或修炼一个物品
--返回 true可以修炼，false不可
function CanUseThing(id,personid)           --判断一个人是否可以装备或修炼一个物品
    local str="";
    if JY.Thing[id]["仅修炼人物"] >=0 then
        if JY.Thing[id]["仅修炼人物"] ~= personid then
            return false;
        end
    end

    if JY.Thing[id]["需内力性质"] ~=2 and JY.Person[personid]["内力性质"] ~=2 then
        if JY.Thing[id]["需内力性质"] ~= JY.Person[personid]["内力性质"] then
            return false;
        end
    end

    if JY.Thing[id]["需内力"] > JY.Person[personid]["内力最大值"] then
        return false;
    end
    if JY.Thing[id]["需攻击力"] > JY.Person[personid]["攻击力"] then
        return false;
    end
    if JY.Thing[id]["需轻功"] > JY.Person[personid]["轻功"] then
        return false;
    end
    if JY.Thing[id]["需用毒能力"] > JY.Person[personid]["用毒能力"] then
        return false;
    end
    if JY.Thing[id]["需医疗能力"] > JY.Person[personid]["医疗能力"] then
        return false;
    end
    if JY.Thing[id]["需解毒能力"] > JY.Person[personid]["解毒能力"] then
        return false;
    end
    if JY.Thing[id]["需拳掌功夫"] > JY.Person[personid]["拳掌功夫"] then
        return false;
    end
    if JY.Thing[id]["需御剑能力"] > JY.Person[personid]["御剑能力"] then
        return false;
    end
    if JY.Thing[id]["需耍刀技巧"] > JY.Person[personid]["耍刀技巧"] then
        return false;
    end
    if JY.Thing[id]["需特殊兵器"] > JY.Person[personid]["特殊兵器"] then
        return false;
    end
    if JY.Thing[id]["需暗器技巧"] > JY.Person[personid]["暗器技巧"] then
        return false;
    end
    if JY.Thing[id]["需资质"] >= 0 then
        if JY.Thing[id]["需资质"] > JY.Person[personid]["资质"] then
            return false;
        end
    else
        if -JY.Thing[id]["需资质"] < JY.Person[personid]["资质"] then
            return false;
        end
    end

    return true
end


--秘籍物品
function UseThing_Type2(id)               --秘籍物品使用
    if JY.Thing[id]["使用人"]>=0 then
        if DrawStrBoxYesNo(-1,-1,"此物品已经有人修炼，是否换人修炼?",C_WHITE,CC.DefaultFont)==false then
            Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
            ShowScreen();
            return 0;
        end
    end

    Cls();
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,string.format("谁要修炼%s?",JY.Thing[id]["名称"]),C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    local r=SelectTeamMenu(CC.MainSubMenuX,nexty);

    if r>0 then
        local personid=JY.Base["队伍" ..r]

        if JY.Thing[id]["练出武功"]>=0 then
            local yes=0;
            for i = 1,10 do
                if JY.Person[personid]["武功"..i]==JY.Thing[id]["练出武功"] then
                    yes=1;             --武功已经有了
                    break;
                end
            end
            if yes==0 and JY.Person[personid]["武功10"]>0 then
                DrawStrBoxWaitKey("一个人只能修炼10种武功",C_WHITE,CC.DefaultFont);
                return 0;
            end
        end

       if CC.Shemale[id]==1 then                --辟邪和葵花
		    if JY.Person[personid]["性别"]==0 then
				Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
				if DrawStrBoxYesNo(-1,-1,"修炼此书必须先挥刀自宫，是否仍要修炼?",C_WHITE,CC.DefaultFont)==false then
					return 0;
				else
					JY.Person[personid]["性别"]=2;
				end
			elseif JY.Person[personid]["性别"]==1 then
				DrawStrBoxWaitKey("此人不适合修炼此物品",C_WHITE,CC.DefaultFont);
				return 0;
			end
        end


        if CanUseThing(id,personid) then
            if JY.Thing[id]["使用人"]==personid then
                return 0;
            end

            if JY.Person[personid]["修炼物品"]>=0 then
                JY.Thing[JY.Person[personid]["修炼物品"]]["使用人"]=-1;
            end

            if JY.Thing[id]["使用人"]>=0 then
                JY.Person[JY.Thing[id]["使用人"]]["修炼物品"]=-1;
                JY.Person[JY.Thing[id]["使用人"]]["修炼点数"]=0;
                JY.Person[JY.Thing[id]["使用人"]]["物品修炼点数"]=0;
            end

            JY.Thing[id]["使用人"]=personid
            JY.Person[personid]["修炼物品"]=id;
            JY.Person[personid]["修炼点数"]=0;
            JY.Person[personid]["物品修炼点数"]=0;
        else
            DrawStrBoxWaitKey("此人不适合修炼此物品",C_WHITE,CC.DefaultFont);
			return 0;
        end
    end

	return 1;
end

--药品物品
function UseThing_Type3(id)        --药品物品使用
    local usepersonid=-1;
    if JY.Status==GAME_MMAP or JY.Status==GAME_SMAP then
        Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,string.format("谁要使用%s?",JY.Thing[id]["名称"]),C_WHITE,CC.DefaultFont);
	    local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
        local r=SelectTeamMenu(CC.MainSubMenuX,nexty);
        if r>0 then
            usepersonid=JY.Base["队伍" ..r]
        end
    elseif JY.Status==GAME_WMAP then           ---战斗场景使用药品
        usepersonid=WAR.Person[WAR.CurID]["人物编号"];
    end

    if usepersonid>=0 then
        if UseThingEffect(id,usepersonid)==1 then       --使用有效果
            instruct_32(id,-1);            --物品数量减少
            WaitKey();
        else
            return 0;
        end
    end

 --   Cls();
 --   ShowScreen();
	return 1;
end

--药品使用实际效果
--id 物品id，
--personid 使用人id
--返回值：0 使用没有效果，物品数量应该不变。1 使用有效果，则使用后物品数量应该-1
function UseThingEffect(id,personid)          --药品使用实际效果
    local str={};
    str[0]=string.format("使用 %s",JY.Thing[id]["名称"]);
    local strnum=1;
    local addvalue;

    if JY.Thing[id]["加生命"] >0 then
        local add=JY.Thing[id]["加生命"]-math.modf(JY.Person[personid]["受伤程度"]/2)+Rnd(10);
        if add <=0 then
            add=5+Rnd(5);
        end
        AddPersonAttrib(personid,"受伤程度",-JY.Thing[id]["加生命"]/4);
        addvalue,str[strnum]=AddPersonAttrib(personid,"生命",add);
        if addvalue ~=0 then
            strnum=strnum+1
        end
    end

    local function ThingAddAttrib(s)     ---定义局部函数，处理吃药后增加属性
        if JY.Thing[id]["加" .. s] ~=0 then
            addvalue,str[strnum]=AddPersonAttrib(personid,s,JY.Thing[id]["加" .. s]);
            if addvalue ~=0 then
                strnum=strnum+1
            end
        end
    end

    ThingAddAttrib("生命最大值");

    if JY.Thing[id]["加中毒解毒"] <0 then
        addvalue,str[strnum]=AddPersonAttrib(personid,"中毒程度",math.modf(JY.Thing[id]["加中毒解毒"]/2));
        if addvalue ~=0 then
            strnum=strnum+1
        end
    end

    ThingAddAttrib("体力");

    if JY.Thing[id]["改变内力性质"] ==2 then
        str[strnum]="内力门路改为阴阳合一"
        strnum=strnum+1
    end

    ThingAddAttrib("内力");
    ThingAddAttrib("内力最大值");
    ThingAddAttrib("攻击力");
    ThingAddAttrib("防御力");
    ThingAddAttrib("轻功");
    ThingAddAttrib("医疗能力");
    ThingAddAttrib("用毒能力");
    ThingAddAttrib("解毒能力");
    ThingAddAttrib("抗毒能力");
    ThingAddAttrib("拳掌功夫");
    ThingAddAttrib("御剑能力");
    ThingAddAttrib("耍刀技巧");
    ThingAddAttrib("特殊兵器");
    ThingAddAttrib("暗器技巧");
    ThingAddAttrib("武学常识");
    ThingAddAttrib("攻击带毒");

    if strnum>1 then
        local maxlength=0      --计算字符串最大长度
        for i = 0,strnum-1 do
            if get_show_width(str[i]) > maxlength then
                maxlength = get_show_width(str[i]);
            end
        end
        Cls();

		local ww=maxlength*CC.DefaultFont/2+CC.MenuBorderPixel*2;
		local hh=strnum*CC.DefaultFont+(strnum-1)*CC.RowPixel+2*CC.MenuBorderPixel;
        local x=(CC.ScreenW-ww)/2;
		local y=(CC.ScreenH-hh)/2;
		DrawBox(x,y,x+ww,y+hh,C_WHITE);
        DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel,str[0],C_WHITE,CC.DefaultFont);
        for i =1,strnum-1 do
            DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+(CC.DefaultFont+CC.RowPixel)*i,str[i],C_ORANGE,CC.DefaultFont);
        end
        ShowScreen();
        return 1;
    else
        return 0;
    end

end


--暗器物品
function UseThing_Type4(id)             --暗器物品使用
    if JY.Status==GAME_WMAP then
         return War_UseAnqi(id);
    end
	return 0;
end



--------------------------------------------------------------------------------
--------------------------------------事件调用-----------------------------------

--事件调用主入口
--id，d*中的编号
--flag 1 空格触发，2，物品触发，3，路过触发
function EventExecute(id,flag)               --事件调用主入口
    JY.CurrentD=id;
    if JY.SceneNewEventFunction[JY.SubScene]==nil then         --没有定义新的事件处理函数，调用旧的
        oldEventExecute(flag)
	else
        JY.SceneNewEventFunction[JY.SubScene](flag)         --调用新的事件处理函数
    end
    JY.CurrentD=-1;
	JY.Darkness=0;
end

--调用原有的指定位置的函数
--旧的函数名字格式为  oldevent_xxx();  xxx为事件编号
function oldEventExecute(flag)            --调用原有的指定位置的函数

	local eventnum;
	if flag==1 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,2);
	elseif flag==2 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,3);
	elseif flag==3 then
		eventnum=GetD(JY.SubScene,JY.CurrentD,4);
	end

	if eventnum>0 then
	    oldCallEvent(eventnum);
	end

end

function oldCallEvent(eventnum)     --执行旧的事件函数
	local eventfilename=string.format("oldevent_%d.lua",eventnum);
	lib.Debug(eventfilename);
	dofile(CONFIG.OldEventPath .. eventfilename);
end


--改变大地图坐标，从场景出去后移动到相应坐标
function ChangeMMap(x,y,direct)          --改变大地图坐标
	JY.Base["人X"]=x;
	JY.Base["人Y"]=y;
	JY.Base["人方向"]=direct;
end

--改变当前场景
function ChangeSMap(sceneid,x,y,direct)       --改变当前场景
    JY.SubScene=sceneid;
	JY.Base["人X1"]=x;
	JY.Base["人Y1"]=y;
	JY.Base["人方向"]=direct;
end


--清除(x1,y1)-(x2,y2)矩形内的文字等。
--如果没有参数，则清除整个屏幕表面
--注意该函数并不直接刷新显示屏幕
function Cls(x1,y1,x2,y2)                    --清除屏幕
    if x1==nil then        --第一个参数为nil,表示没有参数，用缺省
	    x1=0;
		y1=0;
		x2=0;
		y2=0;
	end

	lib.SetClip(x1,y1,x2,y2);

	if JY.Status==GAME_START then
	    lib.FillColor(0,0,0,0,0);
        lib.LoadPicture(CC.FirstFile,-1,-1);
	elseif JY.Status==GAME_MMAP then
        lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],GetMyPic());             --显示主地图
	elseif JY.Status==GAME_SMAP then
        DrawSMap();
	elseif JY.Status==GAME_WMAP then
        WarDrawMap(0);
	elseif JY.Status==GAME_DEAD then
	    lib.FillColor(0,0,0,0,0);
        lib.LoadPicture(CC.DeadFile,-1,-1);
	end
	lib.SetClip(0,0,0,0);
end


--产生对话显示需要的字符串，即每隔n个中文字符加一个星号
function GenTalkString(str,n)              --产生对话显示需要的字符串
    local tmpstr="";
    for s in string.gmatch(str .. "*","(.-)%*") do           --去掉对话中的所有*. 字符串尾部加一个星号，避免无法匹配
        tmpstr=tmpstr .. s;
    end

    local newstr="";
    while get_show_width(tmpstr) > 0 do
		local w=0;
		while w<get_show_width(tmpstr) do
		    local v=string.byte(tmpstr,w+1);          --当前字符的值
			if v>=128 then
			    w=w+2;
			else
			    w=w+1;
			end
			if w >= 2*n-1 then     --为了避免跨段中文字符
			    break;
			end
		end

        if w<get_show_width(tmpstr) then
		    if w==2*n-1 and string.byte(tmpstr,w+1)<128 then
				newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*";
				tmpstr=string.sub(tmpstr,w+2,-1);
			else
				newstr=newstr .. string.sub(tmpstr,1,w)  .. "*";
				tmpstr=string.sub(tmpstr,w+1,-1);
			end
		else
		    newstr=newstr .. tmpstr;
			break;
		end
	end
    return newstr;
end

--最简单版本对话
function Talk(s,personid)            --最简单版本对话
    local flag;
    if personid==0 then
        flag=1;
	else
	    flag=0;
	end
	TalkEx(s,JY.Person[personid]["头像代号"],flag);
end


--复杂版本对话
--s 字符串，必须加上*作为分行，如果里面没有*,则会自动加上
function TalkEx(s,headid,flag)          --复杂版本对话
    local picw=100;       --最大头像图片宽高
	local pich=100;
	local talkxnum=12;         --对话一行字数
	local talkynum=3;          --对话行数
	local dx=2;
	local dy=2;
    local boxpicw=picw+10;
	local boxpich=pich+10;
	local boxtalkw=12*CC.DefaultFont+10;
	local boxtalkh=boxpich;

    local talkBorder=(pich-talkynum*CC.DefaultFont)/(talkynum+1);

	--显示头像和对话的坐标
    local xy={ [0]={headx=dx,heady=dy,
	                talkx=dx+boxpicw+2,talky=dy,
					showhead=1},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich,
					showhead=1},
                   {headx=dx,heady=dy,
				   talkx=dx+boxpicw+2,talky=dy,
				   showhead=0},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				   talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich,
					showhead=1},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=dy,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky=dy,showhead=1},
                   {headx=dx,heady=CC.ScreenH-dy-boxpich,talkx=dx+boxpicw+2,talky=CC.ScreenH-dy-boxpich,showhead=1}, }

    if flag<0 or flag>5 then
        flag=0;
    end

    if xy[flag].showhead==0 then
        headid=-1;
    end

	if string.find(s,"*") ==nil then
	    s=GenTalkString(s,12);
	end

    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(0,CONFIG.KeyRepeatInterval);
	end
    lib.GetKey();

    local startp=1
    local endp;
    local dy=0;
    while true do
        if dy==0 then
		    Cls();
            if headid>=0 then
                DrawBox(xy[flag].headx, xy[flag].heady, xy[flag].headx + boxpicw, xy[flag].heady + boxpich,C_WHITE);
				local w,h=lib.PicGetXY(1,headid*2);
                local x=(picw-w)/2;
				local y=(pich-h)/2;
				lib.PicLoadCache(1,headid*2,xy[flag].headx+5+x,xy[flag].heady+5+y,1);
            end
            DrawBox(xy[flag].talkx, xy[flag].talky, xy[flag].talkx +boxtalkw, xy[flag].talky + boxtalkh,C_WHITE);
        end
        endp=string.find(s,"*",startp);
        if endp==nil then
            DrawString(xy[flag].talkx + 5, xy[flag].talky + 5+talkBorder + dy * (CC.DefaultFont+talkBorder),string.sub(s,startp),C_WHITE,CC.DefaultFont);
            ShowScreen();
            WaitKey();
            break;
        else
            DrawString(xy[flag].talkx + 5, xy[flag].talky + 5+talkBorder + dy * (CC.DefaultFont+talkBorder),string.sub(s,startp,endp-1),C_WHITE,CC.DefaultFont);
        end
        dy=dy+1;
        startp=endp+1;
        if dy>=talkynum then
            ShowScreen();
            WaitKey();
            dy=0;
        end
    end

    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRepeatInterval);
	end

	Cls();
end