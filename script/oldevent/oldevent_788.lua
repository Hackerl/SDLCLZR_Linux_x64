--function oldevent_788()

    if instruct_4(215,2,0) ==false then    --  4(4):是否使用物品[溪山行旅图]？是则跳转到:Label0
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label0

    instruct_1(3196,31,0);   --  1(1):[丹青生]说:  啊！*这是北宋范宽的真迹*“溪山行旅图”，你．．．*你是从何处得来的？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(3197,0,1);   --  1(1):[资差]说: 这个你不必管。***我听江湖上传言，梅庄四庄*主好酒，好画，好剑，人称*三绝。*那想必对我这幅画定是垂涎*三尺了！
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(3198,31,0);   --  1(1):[丹青生]说: 你这小子，*到底有什麽企图？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(3199,0,1);   --  1(1):[资差]说: “企图”没有，*“行旅图”倒是有一幅．
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(3200,31,0);   --  1(1):[丹青生]说: 小子，少贫嘴，我看你是找*死！
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_6(43,4,0,0) ==false then    --  6(6):战斗[43]是则跳转到:Label1
        instruct_15(0);   --  15(F):战斗失败，死亡
        do return; end
        instruct_0();   --  0(0)::空语句(清屏)
    end    --:Label1

    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(3201,31,0);   --  1(1):[丹青生]说: 小子，你等着，*待我去请我三哥．
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,-2,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
    instruct_3(-2,8,1,0,789,0,0,6048,6048,6048,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [8]
    instruct_17(-2,1,37,42,0);   --  17(11):修改场景贴图:当前场景层1坐标25-2A
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
--end

