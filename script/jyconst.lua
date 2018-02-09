
--设置全局变量CC，保存游戏中使用的常数
function SetGlobalConst()
    -- SDL 键码定义，这里名字仍然使用directx的名字
    VK_ESCAPE=27
    VK_Y=121
	VK_N=110
	VK_SPACE=32
	VK_RETURN=13

	SDLK_UP=273
	SDLK_DOWN=274
	SDLK_LEFT=276
	SDLK_RIGHT=275

	if CONFIG.Rotate==0 then
	    VK_UP=SDLK_UP;
	    VK_DOWN=SDLK_DOWN;
	    VK_LEFT=SDLK_LEFT;
	    VK_RIGHT=SDLK_RIGHT;
	else           --右转90度
	    VK_UP=SDLK_RIGHT;
	    VK_DOWN=SDLK_LEFT;
	    VK_LEFT=SDLK_UP;
	    VK_RIGHT=SDLK_DOWN;
	end


   -- 游戏中颜色定义
    C_STARTMENU=RGB(132, 0, 4)            -- 开始菜单颜色
    C_RED=RGB(216, 20, 24)                -- 开始菜单选中项颜色

    C_WHITE=RGB(236, 236, 236);           --游戏内常用的几个颜色值
    C_ORANGE=RGB(252, 148, 16);
    C_GOLD=RGB(236, 200, 40);
    C_BLACK=RGB(0,0,0);


   -- 游戏状态定义
    GAME_START =0       --开始画面
    GAME_FIRSTMMAP = 1  --第一次显示主地图
    GAME_MMAP =2;       --主地图
    GAME_FIRSTSMAP = 3  --第一次显示主地图
    GAME_SMAP =4;       --场景地图
    GAME_WMAP =5;       --战斗地图
	GAME_DEAD =6;       --死亡画面
    GAME_END  =7;       --结束

   --游戏数据全局变量
   CC={};      --定义游戏中使用的常量，这些可以在修改游戏时修改之

   CC.SrcCharSet=0;         --源代码的字符集 0 utf8  1 big5，用于转换R×。 如果源码被转换为big5，则应设为1
   CC.OSCharSet=CONFIG.OSCharSet;         --OS 字符集，0 GB, 1 Big5
   CC.FontName=CONFIG.FontName;    --显示字体

   CC.ScreenW=CONFIG.Width;          --显示窗口宽高
   CC.ScreenH=CONFIG.Height;

   --定义记录文件名。S和D由于是固定大小，因此不再定义idx了。
   local SavePath = CONFIG.DataPath .. "save/";

   CC.R_IDXFilename={[0] = SavePath .. "ranger.idx",
                     SavePath .. "r1.idx",
					 SavePath .. "r2.idx",
					 SavePath .. "r3.idx",};
   CC.R_GRPFilename={[0]=SavePath .. "ranger.grp",
                     SavePath  .. "r1.grp",
					 SavePath  .. "r2.grp",
					 SavePath .. "r3.grp",};
   CC.S_Filename={[0]=SavePath .. "allsin.grp",
                  SavePath .. "s1.grp",
				  SavePath  .. "s2.grp",
				  SavePath  .. "s3.grp",};

   CC.TempS_Filename=SavePath  .. "allsinbk.grp";
   CC.D_Filename={[0]=SavePath  .. "alldef.grp",
                   SavePath  .. "d1.grp",
				   SavePath  .. "d2.grp",
				   SavePath  .. "d3.grp",};

   CC.PaletteFile=CONFIG.DataPath .. "mmap.col";
   CC.FirstFile=CONFIG.PicturePath .. "title.png";
   CC.DeadFile=CONFIG.PicturePath .. "dead.png";

   CC.MMapFile={CONFIG.DataPath .. "earth.002",
                CONFIG.DataPath .. "surface.002",
				CONFIG.DataPath .. "building.002",
		        CONFIG.DataPath .. "buildx.002",
				CONFIG.DataPath .. "buildy.002"};

   --各种贴图文件名。
   CC.MMAPPicFile={CONFIG.DataPath .. "mmap.idx",CONFIG.DataPath .. "mmap.grp"};
   CC.SMAPPicFile={CONFIG.DataPath .. "sdx",CONFIG.DataPath .. "smp"};
   CC.WMAPPicFile={CONFIG.DataPath .. "wdx",CONFIG.DataPath .. "wmp"};
   CC.EffectFile={CONFIG.DataPath .. "eft.idx",CONFIG.DataPath .. "eft.grp"};
   CC.FightPicFile={CONFIG.DataPath .. "fight/fight%03d.idx",CONFIG.DataPath .. "fight/fight%03d.grp"};  --此处为字符串格式，类似于C中printf的格式。

   CC.HeadPicFile={CONFIG.DataPath .. "hdgrp.idx",CONFIG.DataPath .. "hdgrp.grp"};
   CC.ThingPicFile={CONFIG.DataPath .. "thing.idx",CONFIG.DataPath .. "thing.grp"};


   CC.MIDIFile=CONFIG.SoundPath .. "%02d.mid";
   CC.ATKFile=CONFIG.SoundPath .. "atk%02d.wav";
   CC.EFile=CONFIG.SoundPath .. "e%02d.wav";

   CC.WarFile=CONFIG.DataPath .. "war.sta";
   CC.WarMapFile={CONFIG.DataPath .. "warfld.idx",
                  CONFIG.DataPath .. "warfld.grp"};

   CC.TalkIdxFile=CONFIG.ScriptPath .. "oldtalk.idx";
   CC.TalkGrpFile=CONFIG.ScriptPath .. "oldtalk.grp";

   CC.TeamNum=6;          --队伍人数
   CC.MyThingNum=200      --主角物品数量

   CC.ShopScene={};       --小宝商店场景数据，sceneid 场景id，d_shop 小宝位置D*, d_leave 小宝离开D*，一般在场景出口，路过触发
   CC.ShopScene[0]={sceneid=1,d_shop=16,d_leave={17,18}, };
   CC.ShopScene[1]={sceneid=3,d_shop=14,d_leave={15,16}, };
   CC.ShopScene[2]={sceneid=40,d_shop=20,d_leave={21,22}, };
   CC.ShopScene[3]={sceneid=60,d_shop=16,d_leave={17,18}, };
   CC.ShopScene[4]={sceneid=61,d_shop=9,d_leave={10,11,12}, };

  --其他常量
   CC.MWidth=480;       --主地图宽
   CC.MHeight=480;      --主地图高

   CC.SWidth=64;     --子场景地图大小
   CC.SHeight=64;

   CC.DNum=200;       --D*每个场景的事件数

   CC.XScale=CONFIG.XScale;    --贴图一半的宽高
   CC.YScale=CONFIG.YScale;

   CC.Frame=50;     --每帧毫秒数
   CC.SceneMoveFrame=CC.Frame*2;           --场景移动帧速，用于场景移动事件
   CC.PersonMoveFrame=CC.Frame*2;          --主角移动速度，用于主角移动事件
   CC.AnimationFrame=CC.Frame*3;           --动画显示帧速，用于显示动画事件

   CC.WarAutoDelay=300;                   --自动战斗时显示头像的延时

   CC.DirectX={0,1,-1,0};  --不同方向x，y的加减值，用于走路改变坐标值
   CC.DirectY={-1,0,0,1};

   CC.MyStartPic=2501;      --主角走路起始贴图
   CC.BoatStartPic=3715;    --船起始贴图

   CC.Level=30;                  ---人物等级和每等级经验
   CC.Exp={    50,    150,     300 ,500   , 750 ,
               1050,  1400,   1800 ,2250  , 2750 ,
               3850,  5050,   6350 ,7750  , 9250 ,
               10850, 12550, 14350 ,16750 , 18250 ,
               21400, 24700, 28150 ,31750 , 35500 ,
	           39400, 43450, 47650 ,52000 , 60000  };

    CC.MMapBoat={};    --主地图船可以进入的贴图
	local tmpBoat={ {0x166,0x16a},{0x176,0x17c},{0x1ca,0x1d0},{0x1fa,0x262},{0x3f8,0x3fe},};
    for i,v in ipairs(tmpBoat) do      --把这些数据变换成数组，其中有值就是可以进入
        for j=v[1],v[2],2 do
            CC.MMapBoat[j]=1;
        end
    end

    CC.SceneWater={};    --场景人不能进入的贴图
    local tmpWater={ {0x166,0x16a},{0x176,0x17c},{0x1ca,0x1d0},{0x1fa,0x262},{0x332,0x338},
                     {0x346,0x346},{0x3a6,0x3a8},{0x3f8,0x3fe},{0x52c,0x544},};
    for i,v in ipairs(tmpWater) do      --把这些数据变换成数组，其中空项就是可以进入的贴图
        for j=v[1],v[2],2 do
            CC.SceneWater[j]=1;
        end
    end

    CC.WarWater={};    --战斗地图人不能进入的贴图
    local tmpWater={ {0x166,0x16a},{0x176,0x17c},{0x1ca,0x1d0},{0x1fa,0x262},{0x332,0x338},
                     {0x346,0x346},{0x3a6,0x3a8},{0x3f8,0x3fe},{0x52c,0x544},};
    for i,v in ipairs(tmpWater) do      --把这些数据变换成数组，其中空项就是可以进入的贴图
        for j=v[1],v[2],2 do
            CC.WarWater[j]=1;
        end
    end


    --离队人员列表: {人员id，离队调用函数}      ----如果有新的离队人员加入，直接在这里增加
    CC.PersonExit={
                    {0x3F,154},{0x1,198},{0x2d,130},{0x31,136},
                    {0x55,184},{0x4c,166},{0x24,122},{0x52,178},
                    {0x57,188},{0x34,140},{0x59,192},{0x37,118},
                    {0x4d,168},{0x3a,150},{0x1d,116},{0x25,124},
                    {0x35,142},{0x11,110},{0x4e,170},{0x4,104},
                    {0x49,160},{0x4f,172},{0x36,144},{0x51,176},
                    {0x53,180},{0x2c,128},{0x38,148},{0x1c,114},
                    {0x5a,194},{0x50,174},{0x48,158},{0x58,190},
                    {0x4a,162},{0x19,112},{0x42,156},{0x3b,152},
                    {0x1e,146},{0x2,102},{0x30,134},{0x26,126},
                    {0x4B,164},{0x09,106},{0x5b,196},{0x10,108}
                  }

    --所有可加入人员离队需要清除的D*事件，清除后这些人就找不到了。得到武林帖指令使用
    CC.AllPersonExit={ {0,0},{49,2},{4,1},{44,0},{44,1},{37,5},{30,0},{59,0},{40,3},{56,1},{1,7},{1,8},{1,10},
                       {40,7},{40,8},{77,0},{54,0},{62,3},{62,4},{60,2},{60,15},{52,1},{61,0},{61,8},{78,0},
                       {18,0},{18,1},{69,0},{69,1},{45,0},{52,2},{42,6},{42,7},{8,8},{7,6},{80,1}, };

    CC.BookNum=14;               --天书个数
    CC.BookStart=144;            --14天书起始物品id

    CC.MoneyID=174;              --金钱物品id

    CC.Shemale={ [78]=1,[93]=1}   --需要自宫的书的id

   CC.Effect={[0]=9,14,17,9,13,                    --eft.idx/grp贴图各个武功效果贴图个数
                 17,17,17,18,19,
                 19,15,13,10,10,
                 15,21,16,9,11,
                 8,9,8,8,7,
                 8,8,9,12,19,
                 11,14,12,17,8,
                 11,9,13,10,19,
                 14,17,19,14,21,
                 16,13,18,14,17,
                 17,16,7,   };

    CC.ExtraOffense={{106,57,100},             --武功武器配合增加攻击力， 依次为：武器物品id，武功id，攻击力增加
                   {107,49,50},
                   {108,49,50},
                   {110,54,80},
                   {115,63,50},
                   {116,67,70},
                   {119,68,100},}

    CC.NewPersonName="小蝦米";                --新游戏的数据
    CC.NewGameSceneID=70;                      --场景ID
    CC.NewGameSceneX=19;                       --场景坐标
    CC.NewGameSceneY=20;
    CC.NewGameEvent=691;                       --新游戏场景执行事件。如果没有，则看新游戏坐标后面有没有事件。
    CC.NewPersonPic=3445;                      --开始主角pic

   CC.PersonAttribMax={};             --人物属性最大值
   CC.PersonAttribMax["经验"]=60000;
   CC.PersonAttribMax["物品修炼点数"]=60000;
   CC.PersonAttribMax["修炼点数"]=60000;
   CC.PersonAttribMax["生命最大值"]=999;
   CC.PersonAttribMax["受伤程度"]=100;
   CC.PersonAttribMax["中毒程度"]=100;
   CC.PersonAttribMax["内力最大值"]=9999;
   CC.PersonAttribMax["体力"]=100;
   CC.PersonAttribMax["攻击力"]=500;
   CC.PersonAttribMax["防御力"]=500;
   CC.PersonAttribMax["轻功"]=500;
   CC.PersonAttribMax["医疗能力"]=320;
   CC.PersonAttribMax["用毒能力"]=320;
   CC.PersonAttribMax["解毒能力"]=320;
   CC.PersonAttribMax["抗毒能力"]=320;
   CC.PersonAttribMax["拳掌功夫"]=320;
   CC.PersonAttribMax["御剑能力"]=320;
   CC.PersonAttribMax["耍刀技巧"]=320;
   CC.PersonAttribMax["特殊兵器"]=320;
   CC.PersonAttribMax["暗器技巧"]=320;
   CC.PersonAttribMax["武学常识"]=100;
   CC.PersonAttribMax["品德"]=100;
   CC.PersonAttribMax["资质"]=100;
   CC.PersonAttribMax["攻击带毒"]=100;

    CC.WarDataSize=186;         --战斗数据大小  war.sta数据结构
    CC.WarData_S={};        --战斗数据结构
    CC.WarData_S["代号"]={0,0,2};
    CC.WarData_S["名称"]={2,2,10};
    CC.WarData_S["地图"]={12,0,2};
    CC.WarData_S["经验"]={14,0,2};
    CC.WarData_S["音乐"]={16,0,2};
    for i=1,6 do
        CC.WarData_S["手动选择参战人"  .. i]={18+(i-1)*2,0,2};
        CC.WarData_S["自动选择参战人"  .. i]={30+(i-1)*2,0,2};
        CC.WarData_S["我方X"  .. i]={42+(i-1)*2,0,2};
        CC.WarData_S["我方Y"  .. i]={54+(i-1)*2,0,2};
    end
    for i=1,20 do
        CC.WarData_S["敌人"  .. i]={66+(i-1)*2,0,2};
        CC.WarData_S["敌方X"  .. i]={106+(i-1)*2,0,2};
        CC.WarData_S["敌方Y"  .. i]={146+(i-1)*2,0,2};
    end

    CC.WarWidth=64;        --战斗地图大小
    CC.WarHeight=64;

	--显示主地图和场景地图坐标
	--如果显示坐标，则会增加cpu占用。机器速度慢的话可能会卡。这个在调试时有用。
	--注意: 如果设置了CONFIG.FastShowScreen=1，则场景视角范围超出后显示的坐标不正确。
	CC.ShowXY=0     --0 不显示 1 显示

	--以下为控制显示方式的参数

	CC.RowPixel=4         -- 每行字的间距像素数

	CC.MenuBorderPixel=5  -- 菜单四周边框留的像素数，也用于绘制字符串的box四周留得像素

	if CONFIG.Type==0 then      --320*240显示方式
		CC.DefaultFont=16

		CC.StartMenuFontSize=16  --开始菜单字号

		CC.NewGameFontSize =16   --新游戏属性选择字号

		CC.MainMenuX=10;         --主菜单开始坐标
		CC.MainMenuY=10;

		CC.GameOverX=90;
		CC.GameOverY=65;

        CC.PersonStateRowPixel= 1;    --显示人物状态行间距像素

	elseif CONFIG.Type==1 then  --640*480显示方式
		CC.DefaultFont=24;

		CC.StartMenuFontSize=32;

		CC.NewGameFontSize =24;

		CC.MainMenuX=10;
		CC.MainMenuY=10;

		CC.GameOverX=255;
		CC.GameOverY=165;

        CC.PersonStateRowPixel= 4;  --显示人物状态行间距像素

	end

    CC.StartMenuY=CC.ScreenH-3*(CC.StartMenuFontSize+CC.RowPixel)-20;
	CC.NewGameY=CC.ScreenH-4*(CC.NewGameFontSize+CC.RowPixel)-10;

	--子菜单的开始坐标
	CC.MainSubMenuX=CC.MainMenuX+2*CC.MenuBorderPixel+2*CC.DefaultFont+5;       --主菜单为两个汉字
	CC.MainSubMenuY=CC.MainMenuY;

	--二级子菜单开始坐标
	CC.MainSubMenuX2=CC.MainSubMenuX+2*CC.MenuBorderPixel+4*CC.DefaultFont+5;   --子菜单为四个字符

	CC.SingleLineHeight=CC.DefaultFont+2*CC.MenuBorderPixel+5;  --带框的单行字符高

	------------------------以下为物品菜单参数
	if CONFIG.Type==0 then
		CC.ThingFontSize = 16;

		CC.ThingPicWidth=40;    --物品图片宽高
		CC.ThingPicHeight=40;

		CC.MenuThingXnum=5      --一行显示几个物品
		CC.MenuThingYnum=3      --物品显示几列

		CC.ThingGapOut=10;      --物品图像显示四周留白
		CC.ThingGapIn=5;        --物品图像显示中间间隔

	elseif CONFIG.Type==1 then

		CC.ThingFontSize = 24;  --

		CC.ThingPicWidth=40;    --物品图片宽高
		CC.ThingPicHeight=40;

		CC.MenuThingXnum=10      --一行显示几个物品
		CC.MenuThingYnum=5      --物品显示几列

		CC.ThingGapOut=10;      --物品图像显示四周留白
		CC.ThingGapIn=10;        --物品图像显示中间间隔
	end


    --场景视角范围。超出此范围则只移动主角，场景不移动了。也就是主角不在屏幕中央了
	if CONFIG.Type==0 then      --320*240显示方式
        CC.SceneXMin=12
        CC.SceneYMin=12
        CC.SceneXMax=45;
        CC.SceneYMax=45;
	elseif CONFIG.Type==1 then
        CC.SceneXMin=11
        CC.SceneYMin=11
        CC.SceneXMax=47;
        CC.SceneYMax=47;
	end

	CC.SceneFlagPic={2749,2846}    --场景贴图中旗帜的贴图编号。

	if CONFIG.FastShowScreen==0 then
        CC.ShowFlag=1;                 --0 不显示旗帜动画 1 显示。不显示旗帜动画可以增加场景中主角不动时的显示速度
		if CONFIG.Type==1 then
            CC.AutoWarShowHead=1;          --1 战斗时一直显示头像 0 不显示。如果设为1，则战斗时将重绘整个屏幕，会降低显示速度。
		else
		    CC.AutoWarShowHead=0;
		end
	else
        CC.ShowFlag=0;
		CC.AutoWarShowHead=0;
	end

    CC.LoadThingPic=1           --读取物品贴图方式 0 从mmap/smap/wmap中读取  1 读取独立的thing.idx/grp
	CC.StartThingPic=0          --物品贴图在mmap/smap/wmap中的起始编号。CC.LoadThingPic=0有效


end
