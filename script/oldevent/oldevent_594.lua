--function oldevent_594()
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,25,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [25]
    instruct_3(-2,14,0,0,0,0,0,6382,6382,6382,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [14]
    instruct_3(-2,39,1,0,596,0,0,6376,6376,6376,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [39]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_30(39,30,17,30);   --  30(1E):主角走动39-30--17-30
    instruct_1(2575,207,0);   --  1(1):[???]说: 现在这位庄少侠已经连胜十*场，若再无人挑战，则……
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2576,0,1);   --  1(1):[资差]说: 谁说无人挑战？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2577,207,0);   --  1(1):[???]说: 哦，你，你不就是……
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2578,0,1);   --  1(1):[资差]说: 姓名不重要，你们看这是什*么？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2579,207,0);   --  1(1):[???]说: 啊，打狗棒，怎么会在你手*上？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2580,0,1);   --  1(1):[资差]说: 我有打狗棒在手，自然是下*一任帮主。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2581,48,0);   --  1(1):[游坦之]说: 你也要当帮主，先胜过我再*说！
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_6(88,4,0,0) ==false then    --  6(6):战斗[88]是则跳转到:Label0
        instruct_15(0);   --  15(F):战斗失败，死亡
        do return; end
        instruct_0();   --  0(0)::空语句(清屏)
    end    --:Label0

    instruct_3(-2,14,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [14]
    instruct_3(-2,38,1,0,597,0,0,6380,6380,6380,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [38]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(2582,247,1);   --  1(1):[???]说: 怎么样，这帮主之位舍我其*谁？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2583,69,0);   --  1(1):[洪七公]说: 好大的口气，现问过我们再*说！
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_6(83,4,0,0) ==false then    --  6(6):战斗[83]是则跳转到:Label1
        instruct_15(0);   --  15(F):战斗失败，死亡
        do return; end
        instruct_0();   --  0(0)::空语句(清屏)
    end    --:Label1

    instruct_0();   --  0(0)::空语句(清屏)
    instruct_3(-2,12,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [12]
    instruct_3(-2,37,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [37]
    instruct_3(-2,36,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [36]
    instruct_3(-2,35,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [35]
    instruct_3(-2,34,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [34]
    instruct_3(-2,33,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [33]
    instruct_3(-2,32,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [32]
    instruct_3(-2,31,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [31]
    instruct_3(-2,30,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [30]
    instruct_3(-2,29,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [29]
    instruct_3(-2,28,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [28]
    instruct_3(-2,27,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [27]
    instruct_3(-2,26,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [26]
    instruct_3(-2,13,1,0,595,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [13]
    instruct_13();   --  13(D):重新显示场景
    instruct_1(2584,247,1);   --  1(1):[???]说: 哈哈，这回没人反对了吧？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2585,207,0);   --  1(1):[???]说: ……***这位少侠武功盖世，自*是丐帮下一代帮主，这是丐*帮历代相传的打狗棒法。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2586,0,1);   --  1(1):[资差]说: 嘿嘿，我就是为它而来的！
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_2(167,1);   --  2(2):得到物品[打狗棒法][1]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_37(-5);   --  37(25):增加道德-5
--end

