--function oldevent_372()

    if instruct_4(203,2,0) ==false then    --  4(4):是否使用物品[玄冰碧火酒]？是则跳转到:Label0
        do return; end
        instruct_0();   --  0(0)::空语句(清屏)
    end    --:Label0

    instruct_26(61,19,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_26(61,18,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_1(1388,238,0);   --  1(1):[???]说: 哇，得手啦，太好了。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1389,0,1);   --  1(1):[资差]说: 拿去吧，快去救你的天哥吧*。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1390,238,0);   --  1(1):[???]说: ……*能不能再麻烦你一次？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1391,0,1);   --  1(1):[资差]说: 怎么了？救人也要我替你去*？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1392,238,0);   --  1(1):[???]说: 天哥现在在长乐帮，我……*我不方便过去，你帮我送过*去吧。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1393,246,1);   --  1(1):[???]说: 奇奇怪怪的，你的天哥到底*是谁啊？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1394,238,0);   --  1(1):[???]说: 他叫石破天，是长乐帮的帮*主。他手下有个姓贝的，是*个大夫，知道这酒的作用，*你去找他就行。我，我……*我还是不要露面的好。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1395,0,0);   --  1(1):[资差]说: 喂，感觉你在遛我啊，什么*好处也没有，我为啥要替你*跑腿啊。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1396,238,0);   --  1(1):[???]说: 这是我四爷爷的家传鞭法，*送给你，这总行了吧。你不*要罗嗦了，快去啊。*我的天哥……
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,-2,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:当前场景事件编号
    instruct_3(94,1,1,0,377,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:场景[长乐帮]:场景事件编号 [1]
    instruct_3(94,0,1,0,377,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:场景[长乐帮]:场景事件编号 [0]
    instruct_3(94,2,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:场景[长乐帮]:场景事件编号 [2]
    instruct_3(94,9,1,0,374,375,0,7028,0,0,-2,-2,-2);   --  3(3):修改事件定义:场景[长乐帮]:场景事件编号 [9]
    instruct_17(94,2,37,19,5156);   --  17(11):修改场景贴图:场景[长乐帮]层2坐标25-13
    instruct_17(94,2,34,21,4866);   --  17(11):修改场景贴图:场景[长乐帮]层2坐标22-15
    instruct_3(94,14,1,0,380,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:场景[长乐帮]:场景事件编号 [14]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_2(185,1);   --  2(2):得到物品[毒龙鞭法][1]
    instruct_0();   --  0(0)::空语句(清屏)
--end

