function Init_MMap()   --初始化主地图数据
    lib.PicInit();
    lib.LoadMMap(CC.MMapFile[1],CC.MMapFile[2],CC.MMapFile[3],
            CC.MMapFile[4],CC.MMapFile[5],CC.MWidth,CC.MHeight,JY.Base["人X"],JY.Base["人Y"]);

    lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],0);
    lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
    if CC.LoadThingPic==1 then
        lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],2);
    end

    JY.EnterSceneXY=nil;         --设为空，强制重新生成场景入口数据。防止有事件更改了场景入口。
    JY.oldMMapX=-1;
    JY.oldMMapY=-1;

    PlayMIDI(JY.MmapMusic);
end

function Game_MMap()      --主地图

    local direct = -1;
    local keypress = lib.GetKey();
    if keypress ~= -1 then
        JY.MyTick=0;
        if keypress==VK_ESCAPE then
            MMenu();
            if JY.Status==GAME_FIRSTMMAP then
                return ;
            end
            JY.oldMMapX=-1;         --强制重绘
            JY.oldMMapY=-1;
        elseif keypress==VK_UP then
            direct=0;
        elseif keypress==VK_DOWN then
            direct=3;
        elseif keypress==VK_LEFT then
            direct=2;
        elseif keypress==VK_RIGHT then
            direct=1;
        end
    end

    local x,y;              --按照方向键要到达的坐标
    if direct ~= -1 then   --按下了光标键
        AddMyCurrentPic();         --增加主角贴图编号，产生走路效果
        x=JY.Base["人X"]+CC.DirectX[direct+1];
        y=JY.Base["人Y"]+CC.DirectY[direct+1];
        JY.Base["人方向"]=direct;
    else
        x=JY.Base["人X"];
        y=JY.Base["人Y"];
    end

    JY.SubScene=CanEnterScene(x,y);   --判断是否进入子场景

    if lib.GetMMap(x,y,3)==0 and lib.GetMMap(x,y,4)==0 then     --没有建筑，可以到达
        JY.Base["人X"]=x;
        JY.Base["人Y"]=y;
    end
    JY.Base["人X"]=limitX(JY.Base["人X"],10,CC.MWidth-10);           --限制坐标不能超出范围
    JY.Base["人Y"]=limitX(JY.Base["人Y"],10,CC.MHeight-10);

    if CC.MMapBoat[lib.GetMMap(JY.Base["人X"],JY.Base["人Y"],0)]==1 then
        JY.Base["乘船"]=1;
    else
        JY.Base["乘船"]=0;
    end

    local pic=GetMyPic();

    if CONFIG.FastShowScreen==1 then  --设置快速显示，并且主角位置不变，则显示裁剪窗口
        if JY.oldMMapX==JY.Base["人X"] and JY.oldMMapY==JY.Base["人Y"] then
            if JY.oldMMapPic>=0 and JY.oldMMapPic ~= pic then        --主角贴图有变化，则刷新显示。
                local rr=ClipRect(Cal_PicClip(0,0,JY.oldMMapPic,0,0,0,pic,0));
                if rr~=nil then
                    lib.SetClip(rr.x1,rr.y1,rr.x2,rr.y2);
                    lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],pic);             --显示主地图
                end
            end
        else
            lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);
            lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],pic);             --显示主地图
        end
    else  --全部显示
        lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],pic);             --显示主地图
    end

    if CC.ShowXY==1 then
        DrawString(10,CC.ScreenH-20,string.format("%d %d",JY.Base["人X"],JY.Base["人Y"]) ,C_GOLD,16);
    end

    ShowScreen(CONFIG.FastShowScreen);
    lib.SetClip(0,0,0,0);

    JY.oldMMapX=JY.Base["人X"];
    JY.oldMMapY=JY.Base["人Y"];
    JY.oldMMapPic=pic;

    if JY.SubScene >= 0 then          --进入子场景
        CleanMemory();
        lib.UnloadMMap();
        lib.PicInit();
        lib.ShowSlow(50,1)

        JY.Status=GAME_SMAP;
        JY.MMAPMusic=-1;

        JY.MyPic=GetMyPic();
        JY.Base["人X1"]=JY.Scene[JY.SubScene]["入口X"]
        JY.Base["人Y1"]=JY.Scene[JY.SubScene]["入口Y"]

        Init_SMap(1);
    end

end


--场景是否可进
--id 场景代号
--x,y 当前主地图坐标
--返回：场景id，-1表示没有场景可进
function CanEnterScene(x,y)         --场景是否可进
    if JY.EnterSceneXY==nil then    --如果为空，则重新产生数据。
        Cal_EnterSceneXY();
    end

    local id=JY.EnterSceneXY[y*CC.MWidth+x];
    if id~=nil then
        local e=JY.Scene[id]["进入条件"];
        if e==0 then        --可进
            return id;
        elseif e==1 then    --不可进
            return -1
        elseif e==2 then    --有轻功高者进
            for i=1,CC.TeamNum do
                local pid=JY.Base["队伍" .. i];
                if pid>=0 then
                    if JY.Person[pid]["轻功"]>=70 then
                        return id;
                    end
                end
            end
        end
    end
    return -1;
end

function Cal_EnterSceneXY()   --计算哪些坐标可以进入场景
    JY.EnterSceneXY={};
    for id = 0,JY.SceneNum-1 do
        local scene=JY.Scene[id];
        if scene["外景入口X1"]>0 and scene["外景入口Y1"] then
            JY.EnterSceneXY[scene["外景入口Y1"]*CC.MWidth+scene["外景入口X1"]]=id;
        end
        if scene["外景入口X2"]>0 and scene["外景入口Y2"] then
            JY.EnterSceneXY[scene["外景入口Y2"]*CC.MWidth+scene["外景入口X2"]]=id;
        end
    end
end