--function oldevent_422()
    instruct_37(-1);   --  37(25):增加道德-1
    instruct_26(61,19,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_26(61,18,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_3(-2,-2,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:当前场景事件编号
    instruct_25(20,14,15,11);   --  25(19):场景移动20-14--15-11
    instruct_1(1603,41,0);   --  1(1):[张三]说: 侠客岛使者拜会长乐帮石帮*主。请接赏善罚恶令。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1604,38,0);   --  1(1):[石破天]说: 我……我……
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1605,238,0);   --  1(1):[???]说: 果然是天哥，快救人
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_6(169,4,0,0) ==false then    --  6(6):战斗[169]是则跳转到:Label0
        instruct_15(0);   --  15(F):战斗失败，死亡
        do return; end
        instruct_0();   --  0(0)::空语句(清屏)
    end    --:Label0

    instruct_3(-2,27,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [27]
    instruct_3(-2,26,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [26]
    instruct_3(-2,15,0,0,0,0,0,6374,6374,6374,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [15]
    instruct_19(15,13);   --  19(13):主角移动至F-D
    instruct_40(0);   --  40(28):改变主角站立方向0
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(1606,38,0);   --  1(1):[石破天]说: 丁丁当当，你来啦，我想死*你了。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1607,238,0);   --  1(1):[???]说: 呸，还以为你生病之后转了*性，原来还是没半句正经。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1608,38,0);   --  1(1):[石破天]说: 生病？什么病？……
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1609,164,0);   --  1(1):[???]说: 你这狗杂种，总算让我找到*你了。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,23,0,0,0,0,0,8238,8238,8238,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [23]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(1610,164,0);   --  1(1):[???]说: 狗杂种，有什么事要求我？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1611,38,0);   --  1(1):[石破天]说: 你，你，你是什么人？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1612,164,0);   --  1(1):[???]说: 你居然装作不认识我谢烟客*？岂有此理！
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1613,38,0);   --  1(1):[石破天]说: ＜哇，他的内功好厉害，我*还是敷衍一下算了＞
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1614,164,0);   --  1(1):[???]说: 快说，你有什么事要求我办*？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1615,38,0);   --  1(1):[石破天]说: 求你？啊，啊，对，求你去*灭了雪山派！
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1616,164,0);   --  1(1):[???]说: 好小子，想给老子出难题，*好，咱们这就走！
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1617,38,0);   --  1(1):[石破天]说: 啊，怎么还抓着我啊
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1618,238,0);   --  1(1):[???]说: 天哥——
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,15,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [15]
    instruct_3(-2,23,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [23]
    instruct_3(-2,16,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [16]
    instruct_3(39,10,0,0,0,0,0,7074,7074,7074,-2,-2,-2);   --  3(3):修改事件定义:场景[凌霄城]:场景事件编号 [10]
    instruct_3(39,18,0,0,0,0,0,7074,7074,7074,-2,-2,-2);   --  3(3):修改事件定义:场景[凌霄城]:场景事件编号 [18]
    instruct_3(39,19,0,0,0,0,0,6374,6374,6374,-2,-2,-2);   --  3(3):修改事件定义:场景[凌霄城]:场景事件编号 [19]
    instruct_3(39,9,1,0,424,0,0,5274,5274,5274,-2,-2,-2);   --  3(3):修改事件定义:场景[凌霄城]:场景事件编号 [9]
    instruct_3(39,11,0,0,0,0,0,8238,8238,8238,-2,-2,-2);   --  3(3):修改事件定义:场景[凌霄城]:场景事件编号 [11]
    instruct_3(39,12,0,0,0,0,423,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:场景[凌霄城]:场景事件编号 [12]
    instruct_3(39,13,0,0,0,0,423,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:场景[凌霄城]:场景事件编号 [13]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(1619,0,1);   --  1(1):[资差]说: 他怎么又被抓上雪山派了？
    instruct_0();   --  0(0)::空语句(清屏)
--end

