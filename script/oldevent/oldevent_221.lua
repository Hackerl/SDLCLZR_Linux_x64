--function oldevent_221()
    instruct_1(515,0,1);   --  1(1):[资差]说: 又一大群蜘蛛，看我灭之！
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_6(64,4,0,0) ==false then    --  6(6):战斗[64]是则跳转到:Label0
        instruct_15(0);   --  15(F):战斗失败，死亡
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label0

    instruct_3(-2,36,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [36]
    instruct_3(-2,37,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [37]
    instruct_3(-2,38,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [38]
    instruct_3(-2,39,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [39]
    instruct_3(-2,40,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [40]
    instruct_3(-2,41,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [41]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_2(210,5);   --  2(2):得到物品[食材][5]
    instruct_0();   --  0(0)::空语句(清屏)
--end

