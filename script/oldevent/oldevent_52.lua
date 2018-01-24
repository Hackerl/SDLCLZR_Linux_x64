--function oldevent_52()
    instruct_26(3,3,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_26(3,2,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_3(-2,1,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [1]
    instruct_3(-2,2,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [2]
    instruct_3(-2,0,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [0]
    instruct_25(44,25,36,25);   --  25(19):场景移动44-25--36-25
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_30(44,25,40,25);   --  30(1E):主角走动44-25--40-25
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(238,0,1);   --  1(1):[资差]说: 咦？这你们在做什么？一堆*大男人围着一个小姑娘……
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(239,137,0);   --  1(1):[???]说: 哪来的野小子，少关闲事，*一边凉快去！
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(240,245,1);   --  1(1):[???]说: 你凭什么这么横！你不让我*管，我就非管不可。
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_6(92,4,0,0) ==false then    --  6(6):战斗[92]是则跳转到:Label0
        instruct_15(0);   --  15(F):战斗失败，死亡
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label0

    instruct_3(-2,6,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [6]
    instruct_3(-2,7,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [7]
    instruct_3(-2,8,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [8]
    instruct_3(-2,9,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [9]
    instruct_3(-2,5,0,0,0,0,0,5926,5926,5926,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [5]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(241,0,1);   --  1(1):[资差]说: 看你还横！
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(242,137,0);   --  1(1):[???]说: 不敢不敢，少侠饶命……这*位少侠，你别杀我，我告诉*你一个秘密。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(243,0,1);   --  1(1):[资差]说: 秘密？什么秘密？说来听听*。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(244,137,0);   --  1(1):[???]说: 这个小姑娘身上有个地图，*是关于高昌迷宫的。据说，*高昌迷宫中藏有无数的宝藏*。少侠，你饶了我，我帮你*找宝藏。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(245,0,1);   --  1(1):[资差]说: 你以为我傻啊，拿了地图我*不会自己找。
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_5(0,279) ==true then    --  5(5):是否选择战斗？否则跳转到:Label1
        instruct_1(246,0,1);   --  1(1):[资差]说: 像你这样的恶人，留在世上*何用？
        instruct_37(1);   --  37(25):增加道德1
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_14();   --  14(E):场景变黑
        instruct_3(-2,5,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [5]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_13();   --  13(D):重新显示场景
        instruct_30(40,25,36,25);   --  30(1E):主角走动40-25--36-25
        instruct_1(247,242,0);   --  1(1):[???]说: 多谢少侠救命之恩
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(248,0,1);   --  1(1):[资差]说: ＜这姑娘身上有藏宝图，我*应该杀了她拿宝藏呢，还是*……＞
        instruct_0();   --  0(0)::空语句(清屏)

        if instruct_5(0,88) ==true then    --  5(5):是否选择战斗？否则跳转到:Label2
            instruct_37(-5);   --  37(25):增加道德-5
            instruct_1(249,0,1);   --  1(1):[资差]说: 谁说我要救你？刚才那家伙*说了，你身上有什么宝藏图*，拿出来瞧瞧。
            instruct_0();   --  0(0)::空语句(清屏)
            instruct_1(250,242,0);   --  1(1):[???]说: 啊，少侠，你，你……
            instruct_0();   --  0(0)::空语句(清屏)
            instruct_1(251,246,1);   --  1(1):[???]说: 我怎么啦？我刚才杀了那个*家伙，只不过想独吞宝藏而*已。
            instruct_0();   --  0(0)::空语句(清屏)
            instruct_1(252,242,0);   --  1(1):[???]说: 天啊，为什么，宝藏真的那*么重要？
            instruct_0();   --  0(0)::空语句(清屏)
            instruct_1(253,245,1);   --  1(1):[???]说: 废话少说，把藏宝图交出来*！
            instruct_0();   --  0(0)::空语句(清屏)
            instruct_14();   --  14(E):场景变黑
            instruct_3(-2,4,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [4]
            instruct_3(-2,3,1,0,60,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [3]
            instruct_0();   --  0(0)::空语句(清屏)
            instruct_13();   --  13(D):重新显示场景

            if instruct_31(10000,0,7) ==true then    --  31(1F):判断银子是否够10000否则跳转到:Label3
                instruct_2(222,1);   --  2(2):得到物品[手帕][1]
                instruct_0();   --  0(0)::空语句(清屏)
                instruct_39(15);   --  39(27):打开场景沙漠废墟
                do return; end
            end    --:Label3


            if instruct_31(5000,0,8) ==true then    --  31(1F):判断银子是否够5000否则跳转到:Label4
                instruct_2(223,1);   --  2(2):得到物品[手帕][1]
                instruct_0();   --  0(0)::空语句(清屏)
                instruct_39(86);   --  39(27):打开场景沙漠废墟
                do return; end
                instruct_0();   --  0(0)::空语句(清屏)
            end    --:Label4

            instruct_2(224,1);   --  2(2):得到物品[手帕][1]
            instruct_0();   --  0(0)::空语句(清屏)
            instruct_39(87);   --  39(27):打开场景沙漠废墟
            do return; end
        end    --:Label2

        instruct_1(254,0,1);   --  1(1):[资差]说: 路见不平，拔刀相助，姑娘*不必客气了。敢问姑娘芳名*？
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(255,242,0);   --  1(1):[???]说: 我叫李文秀。对了少侠，这*位大叔中了毒针，你帮帮他*吧。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(256,0,1);   --  1(1):[资差]说: 好的，我尽力而为吧。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(257,0,2);   --  1(1):[资差]说: 你将地上之人反转过来，*见他背后有三块瘀青，于是*赶紧用小刀将他体内的毒针*取出。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_14();   --  14(E):场景变黑
        instruct_3(-2,3,0,0,0,0,0,6796,6796,6796,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [3]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_13();   --  13(D):重新显示场景
        instruct_1(258,138,0);   --  1(1):[???]说: 你为什么要救我？是不是想*让我带你去高昌迷宫？
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(259,0,1);   --  1(1):[资差]说: ＜他也知道高昌迷宫？就算*是我也不能这么说呀。＞我*根本不知道什么高昌迷宫，*是这位姑娘求我帮你的。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(260,138,0);   --  1(1):[???]说: 哼，我谁也不相信！不过你*既然救了我，这三枚毒针就*送给你吧。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_2(35,1);   --  2(2):得到物品[黑血神针][1]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(261,246,1);   --  1(1):[???]说: ＜就这么点酬劳啊＞
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(262,138,0);   --  1(1):[???]说: 我走了，你们不要跟来。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_14();   --  14(E):场景变黑
        instruct_3(-2,3,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [3]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_37(2);   --  37(25):增加道德2
        instruct_13();   --  13(D):重新显示场景
        instruct_1(263,0,1);   --  1(1):[资差]说: 姑娘，你今后有何打算？
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(264,242,0);   --  1(1):[???]说: 我也不知道，我爹娘都被那*些恶人害死了，我喜欢的人*又有了别的心上人……
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(265,0,1);   --  1(1):[资差]说: 如果姑娘不嫌弃的话，我们*一起闯荡江湖如何？
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(266,242,0);   --  1(1):[???]说: 我知道，少侠你这个人是很*好很好的，你的建议也是很*好很好的，可是，我偏偏不*喜欢，有什么法子？这匹白*马，从小和我一起长大，就*赠与少侠留作纪念吧，我要*走了……
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_2(230,1);   --  2(2):得到物品[白马][1]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_14();   --  14(E):场景变黑
        instruct_3(-2,4,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [4]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_13();   --  13(D):重新显示场景
        instruct_1(3991,0,1);   --  1(1):[资差]说: 唉，人已经走了，看来这什*么高昌迷宫只能靠我自己找*了，应该就在沙漠里吧。
        instruct_0();   --  0(0)::空语句(清屏)

        if instruct_31(10000,0,3) ==true then    --  31(1F):判断银子是否够10000否则跳转到:Label5
            instruct_39(15);   --  39(27):打开场景沙漠废墟
            do return; end
        end    --:Label5


        if instruct_31(5000,0,4) ==true then    --  31(1F):判断银子是否够5000否则跳转到:Label6
            instruct_39(86);   --  39(27):打开场景沙漠废墟
            do return; end
            instruct_0();   --  0(0)::空语句(清屏)
        end    --:Label6

        instruct_39(87);   --  39(27):打开场景沙漠废墟
        do return; end
    end    --:Label1

    instruct_37(2);   --  37(25):增加道德2
    instruct_1(269,0,1);   --  1(1):[资差]说: 不过上天有好生之德，我姑*且饶你一命，快滚吧。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,5,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [5]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(247,242,0);   --  1(1):[???]说: 多谢少侠救命之恩
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(254,0,1);   --  1(1):[资差]说: 路见不平，拔刀相助，姑娘*不必客气了。敢问姑娘芳名*？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(255,242,0);   --  1(1):[???]说: 我叫李文秀。对了少侠，这*位大叔中了毒针，你帮帮他*吧。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(256,0,1);   --  1(1):[资差]说: 好的，我尽力而为吧。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(257,0,2);   --  1(1):[资差]说: 你将地上之人反转过来，*见他背后有三块瘀青，于是*赶紧用小刀将他体内的毒针*取出。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,3,0,0,0,0,0,6796,6796,6796,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [3]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(258,138,0);   --  1(1):[???]说: 你为什么要救我？是不是想*让我带你去高昌迷宫？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(259,0,1);   --  1(1):[资差]说: ＜他也知道高昌迷宫？就算*是我也不能这么说呀。＞我*根本不知道什么高昌迷宫，*是这位姑娘求我帮你的。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(260,138,0);   --  1(1):[???]说: 哼，我谁也不相信！不过你*既然救了我，这三枚毒针就*送给你吧。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_2(35,1);   --  2(2):得到物品[黑血神针][1]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(261,246,1);   --  1(1):[???]说: ＜就这么点酬劳啊＞
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(262,138,0);   --  1(1):[???]说: 我走了，你们不要跟来。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,3,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [3]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_37(2);   --  37(25):增加道德2
    instruct_13();   --  13(D):重新显示场景
    instruct_1(263,0,1);   --  1(1):[资差]说: 姑娘，你今后有何打算？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(264,242,0);   --  1(1):[???]说: 我也不知道，我爹娘都被那*些恶人害死了，我喜欢的人*又有了别的心上人……
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(265,0,1);   --  1(1):[资差]说: 如果姑娘不嫌弃的话，我们*一起闯荡江湖如何？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(266,242,0);   --  1(1):[???]说: 我知道，少侠你这个人是很*好很好的，你的建议也是很*好很好的，可是，我偏偏不*喜欢，有什么法子？这匹白*马，从小和我一起长大，就*赠与少侠留作纪念吧，我要*走了……
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_2(230,1);   --  2(2):得到物品[白马][1]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,4,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [4]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(3991,0,1);   --  1(1):[资差]说: 唉，人已经走了，看来这什*么高昌迷宫只能靠我自己找*了，应该就在沙漠里吧。
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_31(10000,0,3) ==true then    --  31(1F):判断银子是否够10000否则跳转到:Label7
        instruct_39(15);   --  39(27):打开场景沙漠废墟
        do return; end
    end    --:Label7


    if instruct_31(5000,0,4) ==true then    --  31(1F):判断银子是否够5000否则跳转到:Label8
        instruct_39(86);   --  39(27):打开场景沙漠废墟
        do return; end
        instruct_0();   --  0(0)::空语句(清屏)
    end    --:Label8

    instruct_39(87);   --  39(27):打开场景沙漠废墟
--end

