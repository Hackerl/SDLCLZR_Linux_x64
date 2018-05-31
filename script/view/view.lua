--计算贴图改变形成的Clip裁剪
--(dx1,dy1) 新贴图和绘图中心点的坐标偏移。在场景中，视角不同而主角动时用到
--pic1 旧的贴图编号
--id1 贴图文件加载编号
--(dx2,dy2) 新贴图和绘图中心点的偏移
--pic2 旧的贴图编号
--id2 贴图文件加载编号
--返回，裁剪矩形 {x1,y1,x2,y2}
function Cal_PicClip(dx1,dy1,pic1,id1,dx2,dy2,pic2,id2)   --计算贴图改变形成的Clip裁剪

    local w1,h1,x1_off,y1_off=lib.PicGetXY(id1,pic1*2);
    local old_r={};
    old_r.x1=CC.XScale*(dx1-dy1)+CC.ScreenW/2-x1_off;
    old_r.y1=CC.YScale*(dx1+dy1)+CC.ScreenH/2-y1_off;
    old_r.x2=old_r.x1+w1;
    old_r.y2=old_r.y1+h1;

    local w2,h2,x2_off,y2_off=lib.PicGetXY(id2,pic2*2);
    local new_r={};
    new_r.x1=CC.XScale*(dx2-dy2)+CC.ScreenW/2-x2_off;
    new_r.y1=CC.YScale*(dx2+dy2)+CC.ScreenH/2-y2_off;
    new_r.x2=new_r.x1+w2;
    new_r.y2=new_r.y1+h2;

    return MergeRect(old_r,new_r);
end

function MergeRect(r1,r2)     --合并矩形
    local res={};
    res.x1=math.min(r1.x1, r2.x1);
    res.y1=math.min(r1.y1, r2.y1);
    res.x2=math.max(r1.x2, r2.x2);
    res.y2=math.max(r1.y2, r2.y2);
    return res;
end

----对矩形进行屏幕剪裁
--返回剪裁后的矩形，如果超出屏幕，返回空
function ClipRect(r)    --对矩形进行屏幕剪裁
    if r.x1>=CC.ScreenW or r.x2<= 0 or r.y1>=CC.ScreenH or r.y2 <=0 then
        return nil
    else
        local res={};
        res.x1=limitX(r.x1,0,CC.ScreenW);
        res.x2=limitX(r.x2,0,CC.ScreenW);
        res.y1=limitX(r.y1,0,CC.ScreenH);
        res.y2=limitX(r.y2,0,CC.ScreenH);
        return res;
    end
end

function GetMyPic()      --计算主角当前贴图
    local n;
    if JY.Status==GAME_MMAP and JY.Base["乘船"]==1 then
        if JY.MyCurrentPic >=4 then
            JY.MyCurrentPic=0
        end
    else
        if JY.MyCurrentPic >6 then
            JY.MyCurrentPic=1
        end
    end

    if JY.Base["乘船"]==0 then
        n=CC.MyStartPic+JY.Base["人方向"]*7+JY.MyCurrentPic;
    else
        n=CC.BoatStartPic+JY.Base["人方向"]*4+JY.MyCurrentPic;
    end
    return n;
end

--增加当前主角走路动画帧, 主地图和场景地图都使用
function AddMyCurrentPic()        ---增加当前主角走路动画帧,
    JY.MyCurrentPic=JY.MyCurrentPic+1;
end