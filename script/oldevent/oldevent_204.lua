--function oldevent_204()

    if instruct_18(217,0,52) ==true then    --  18(12):是否有物品[鸳刀]否则跳转到:Label0
        instruct_3(-2,-2,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:当前场景事件编号
        instruct_32(217,-1);   --  32(20):物品[鸳刀]+[-1]
        instruct_1(458,0,1);   --  1(1):[资差]说: 哈！*这刀孔大小正适合放这把*鸳刀．
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_14();   --  14(E):场景变黑
        instruct_17(-2,1,24,39,0);   --  17(11):修改场景贴图:当前场景层1坐标18-27
        instruct_17(-2,1,23,39,0);   --  17(11):修改场景贴图:当前场景层1坐标17-27
        instruct_3(-2,7,1,0,207,0,0,6078,6078,6078,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [7]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_13();   --  13(D):重新显示场景
        do return; end
    end    --:Label0

    instruct_0();   --  0(0)::空语句(清屏)
--end

