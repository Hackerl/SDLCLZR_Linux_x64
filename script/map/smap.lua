--showname  =1 显示场景名 0 不显示
function Init_SMap(showname)   --初始化场景数据
    lib.PicInit();
    lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],0);
    lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],1);
    if CC.LoadThingPic==1 then
        lib.PicLoadFile(CC.ThingPicFile[1],CC.ThingPicFile[2],2);
    end

    PlayMIDI(JY.Scene[JY.SubScene]["进门音乐"]);

    JY.oldSMapX=-1;
    JY.oldSMapY=-1;

    JY.SubSceneX=0;
    JY.SubSceneY=0;
    JY.OldDPass=-1;

    JY.D_Valid=nil;

    DrawSMap();
    lib.ShowSlow(50,0)
    lib.GetKey();

    if showname==1 then
        DrawStrBox(-1,10,JY.Scene[JY.SubScene]["名称"],C_WHITE,CC.DefaultFont);
        ShowScreen();
        WaitKey();
        Cls();
        ShowScreen();
    end

end

--场景处理主函数
function Game_SMap()         --场景处理主函数

    DrawSMap(CONFIG.FastShowScreen);
    if CC.ShowXY==1 then
        DrawString(10,CC.ScreenH-20,string.format("%s %d %d",JY.Scene[JY.SubScene]["名称"],JY.Base["人X1"],JY.Base["人Y1"]) ,C_GOLD,16);
    end

    ShowScreen(CONFIG.FastShowScreen);

    lib.SetClip(0,0,0,0);

    local d_pass=GetS(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],3);   --当前路过事件
    if d_pass>=0 then
        if d_pass ~=JY.OldDPass then     --避免重复触发
            EventExecute(d_pass,3);       --路过触发事件
            JY.OldDPass=d_pass;
            JY.oldSMapX=-1;
            JY.oldSMapY=-1;
            JY.D_Valid=nil;
        end
    else
        JY.OldDPass=-1;
    end

    local isout=0;                --是否碰到出口
    if (JY.Scene[JY.SubScene]["出口X1"] ==JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y1"] ==JY.Base["人Y1"]) or
       (JY.Scene[JY.SubScene]["出口X2"] ==JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y2"] ==JY.Base["人Y1"]) or
       (JY.Scene[JY.SubScene]["出口X3"] ==JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y3"] ==JY.Base["人Y1"]) then
       isout=1;
    end

    if isout==1 then    --出去，返回主地图
        JY.Status=GAME_MMAP;

        lib.PicInit();
        CleanMemory();
        lib.ShowSlow(50,1)

        if JY.MMAPMusic<0 then
            JY.MMAPMusic=JY.Scene[JY.SubScene]["出门音乐"];
        end

        Init_MMap();

        JY.SubScene=-1;
        JY.oldSMapX=-1;
        JY.oldSMapY=-1;

        lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],GetMyPic());
        lib.ShowSlow(50,0)
        lib.GetKey();
        return;
    end

    --是否跳转到其他场景
    if JY.Scene[JY.SubScene]["跳转场景"] >=0 then
        if JY.Base["人X1"]==JY.Scene[JY.SubScene]["跳转口X1"] and JY.Base["人Y1"]==JY.Scene[JY.SubScene]["跳转口Y1"] then
            JY.SubScene=JY.Scene[JY.SubScene]["跳转场景"];
            lib.ShowSlow(50,1);

            if JY.Scene[JY.SubScene]["外景入口X1"]==0 and JY.Scene[JY.SubScene]["外景入口Y1"]==0 then
                JY.Base["人X1"]=JY.Scene[JY.SubScene]["入口X"];            --新场景的外景入口为0，表示这是一个内部场景
                JY.Base["人Y1"]=JY.Scene[JY.SubScene]["入口Y"];
            else
                JY.Base["人X1"]=JY.Scene[JY.SubScene]["跳转口X2"];         --外部场景，即从其他内部场景跳回。
                JY.Base["人Y1"]=JY.Scene[JY.SubScene]["跳转口Y2"];
            end

            Init_SMap(1);

            return;
        end
    end

    local x,y;
    local keypress = lib.GetKey();
    local direct=-1;
    if keypress ~= -1 then
        JY.MyTick=0;
        if keypress==VK_ESCAPE then
            MMenu();
            JY.oldSMapX=-1;
            JY.oldSMapY=-1;
        elseif keypress==VK_UP then
            direct=0;
        elseif keypress==VK_DOWN then
            direct=3;
        elseif keypress==VK_LEFT then
            direct=2;
        elseif keypress==VK_RIGHT then
            direct=1;
        elseif keypress==VK_SPACE or keypress==VK_RETURN  then
            if JY.Base["人方向"]>=0 then        --当前方向下一个位置
                local d_num=GetS(JY.SubScene,JY.Base["人X1"]+CC.DirectX[JY.Base["人方向"]+1],JY.Base["人Y1"]+CC.DirectY[JY.Base["人方向"]+1],3);
                if d_num>=0 then
                    EventExecute(d_num,1);       --空格触发事件
                    JY.oldSMapX=-1;
                    JY.oldSMapY=-1;
                    JY.D_Valid=nil;
                end
            end
        end
    end

    if JY.Status~=GAME_SMAP then
        return ;
    end

    if direct ~= -1 then
        AddMyCurrentPic();
        x=JY.Base["人X1"]+CC.DirectX[direct+1];
        y=JY.Base["人Y1"]+CC.DirectY[direct+1];
        JY.Base["人方向"]=direct;
    else
        x=JY.Base["人X1"];
        y=JY.Base["人Y1"];
    end

    JY.MyPic=GetMyPic();

    DtoSMap();

    if SceneCanPass(x,y)==true then          --新的坐标可以走过去
        JY.Base["人X1"]=x;
        JY.Base["人Y1"]=y;
    end

    JY.Base["人X1"]=limitX(JY.Base["人X1"],1,CC.SWidth-2);
    JY.Base["人Y1"]=limitX(JY.Base["人Y1"],1,CC.SHeight-2);

end

--场景坐标(x,y)是否可以通过
--返回true,可以，false不能
function SceneCanPass(x,y)  --场景坐标(x,y)是否可以通过
    local ispass=true;        --是否可以通过

    if GetS(JY.SubScene,x,y,1)>0 then     --场景层1有物品，不可通过
        ispass=false;
    end

    local d_data=GetS(JY.SubScene,x,y,3);     --事件层4
    if d_data>=0 then
        if GetD(JY.SubScene,d_data,0)~=0 then  --d*数据为不能通过
            ispass=false;
        end
    end

    if CC.SceneWater[GetS(JY.SubScene,x,y,0)] ~= nil then   --水面，不可进入
        ispass=false;
    end
    return ispass;
end