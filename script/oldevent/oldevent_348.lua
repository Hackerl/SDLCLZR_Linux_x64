--function oldevent_348()

    if instruct_28(0,75,999,0,104) ==true then    --  28(1C):判断资差品德75-999否则跳转到:Label0
        instruct_37(1);   --  37(25):增加道德1
        instruct_1(1319,54,0);   --  1(1):[袁承志]说: 既然少侠需要，这本书就送*给你吧。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(1314,247,1);   --  1(1):[???]说: 哈哈，太好了，多谢袁公子！
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_2(156,1);   --  2(2):得到物品[碧血剑][1]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(1315,54,0);   --  1(1):[袁承志]说: 看到你高兴的样子，我的心*也再度活跃起来。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(1316,0,1);   --  1(1):[资差]说: 那袁公子何不与我一同闯荡*江湖？
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_3(104,75,1,0,966,0,0,6818,6818,6818,-2,-2,-2);   --  3(3):修改事件定义:场景[钓鱼岛]:场景事件编号 [75]

        if instruct_20(24,0) ==false then    --  20(14):队伍是否满？是则跳转到:Label1
            instruct_1(1317,54,0);   --  1(1):[袁承志]说: 好，愿陪少侠走一遭！
            instruct_0();   --  0(0)::空语句(清屏)
            instruct_3(-2,-2,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:当前场景事件编号
            instruct_0();   --  0(0)::空语句(清屏)
            instruct_10(54);   --  10(A):加入人物[袁承志]
            instruct_0();   --  0(0)::空语句(清屏)
            do return; end
        end    --:Label1

        instruct_1(12,54,0);   --  1(1):[袁承志]说: 你的队伍已满，我就直接去*小村吧。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_3(-2,-2,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:当前场景事件编号
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_3(70,18,1,0,145,0,0,6818,6818,6818,-2,-2,-2);   --  3(3):修改事件定义:场景[资差居]:场景事件编号 [18]
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
        instruct_0();   --  0(0)::空语句(清屏)
    end    --:Label0

    instruct_1(1320,54,0);   --  1(1):[袁承志]说: 少侠想强夺此书吗？
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_5(0,35) ==true then    --  5(5):是否选择战斗？否则跳转到:Label2
        instruct_37(-3);   --  37(25):增加道德-3

        if instruct_6(101,4,0,0) ==false then    --  6(6):战斗[101]是则跳转到:Label3
            instruct_15(0);   --  15(F):战斗失败，死亡
            do return; end
            instruct_0();   --  0(0)::空语句(清屏)
        end    --:Label3

        instruct_3(-2,-2,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:当前场景事件编号
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_13();   --  13(D):重新显示场景
        instruct_2(156,1);   --  2(2):得到物品[碧血剑][1]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_37(-3);   --  37(25):增加道德-3
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label2

--end

