--function oldevent_507()
    instruct_14();   --  14(E):场景变黑
    instruct_26(61,0,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_26(61,8,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_26(61,17,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_26(61,16,1,0,0);   --  26(1A):增加场景事件编号的三个触发事件编号
    instruct_3(-2,-2,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
    instruct_3(32,12,1,0,512,0,0,7104,7104,7104,-2,-2,-2);   --  3(3):修改事件定义:场景[牛家村]:场景事件编号 [12]
    instruct_3(41,1,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:场景[山洞]:场景事件编号 [1]
    instruct_13();   --  13(D):重新显示场景
    instruct_30(22,34,19,32);   --  30(1E):主角走动22-34--19-32
    instruct_40(2);   --  40(28):改变主角站立方向2
    instruct_1(2089,65,0);   --  1(1):[一灯]说: 阿弥陀佛
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2090,244,1);   --  1(1):[???]说: 一灯大师，原来是这么慈祥*和蔼的老和尚啊……
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2091,56,0);   --  1(1):[黄蓉]说: 大师，这小子不是好东西！
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2092,65,0);   --  1(1):[一灯]说: 不知施主此来，所为何事？
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_5(0,254) ==true then    --  5(5):是否选择战斗？否则跳转到:Label0
        instruct_47(60,90);   --  47(2F):欧阳锋增加攻击力90
        instruct_35(60,1,104,900);   --  35(23):设置欧阳锋武功1:逆运真经攻击力900
        instruct_37(-10);   --  37(25):增加道德-10
        instruct_1(2093,245,1);   --  1(1):[???]说: 来取你性命！
        instruct_0();   --  0(0)::空语句(清屏)

        if instruct_6(68,3,0,0) ==false then    --  6(6):战斗[68]是则跳转到:Label1
            instruct_15(0);   --  15(F):战斗失败，死亡
            do return; end
        end    --:Label1

        instruct_3(-2,6,1,0,0,0,0,6226,6226,6226,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [6]
        instruct_3(-2,12,1,0,0,0,0,5440,5440,5440,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [12]
        instruct_3(-2,11,1,0,0,0,0,5432,5432,5432,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [11]
        instruct_3(-2,10,1,0,0,0,0,5428,5428,5428,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [10]
        instruct_3(-2,9,1,0,0,0,0,5154,5154,5154,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [9]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_13();   --  13(D):重新显示场景
        instruct_1(2094,56,0);   --  1(1):[黄蓉]说: 靖哥哥，我们打不过他，快*跑。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(2095,55,0);   --  1(1):[郭靖]说: 可是一灯大师他……
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(2096,56,0);   --  1(1):[黄蓉]说: 我们要把一灯大师译出来的*真经交给师父，让师父尽快*恢复功力。然后找师父和我*爹爹为段皇爷报仇！
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(2097,55,0);   --  1(1):[郭靖]说: 好吧，也只好如此了。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_14();   --  14(E):场景变黑
        instruct_3(-2,7,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [7]
        instruct_3(-2,8,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [8]
        instruct_3(-2,15,0,0,0,0,0,6104,6104,6104,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [15]
        instruct_3(-2,14,0,0,0,0,0,8218,8218,8218,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [14]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_13();   --  13(D):重新显示场景
        instruct_1(2098,67,0);   --  1(1):[裘千仞]说: 这小子还真行啊，哈哈，锋*兄，这回华山之上你又少了*一个劲敌啊。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(2099,60,0);   --  1(1):[欧阳锋]说: 我的克儿死了，我还要找黄*老邪报仇。小子，我现在就*正是收你为徒，教你我的蛤*蟆神功。
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_2(73,1);   --  2(2):得到物品[蛤蟆功法][1]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(2100,67,0);   --  1(1):[裘千仞]说: 喂，小子，你可是在找《射*雕英雄传》一书？
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(2101,0,1);   --  1(1):[资差]说: 是啊，裘帮主知道下落？
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(2102,67,0);   --  1(1):[裘千仞]说: 此书就在重阳宫！
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_1(2103,60,0);   --  1(1):[欧阳锋]说: 小子，到重阳宫抢书可不容*易，好好练练吧！
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_14();   --  14(E):场景变黑
        instruct_3(-2,14,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [14]
        instruct_3(-2,15,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [15]
        instruct_3(19,0,1,0,510,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:场景[重阳宫]:场景事件编号 [0]
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_13();   --  13(D):重新显示场景
        do return; end
    end    --:Label0

    instruct_37(4);   --  37(25):增加道德4
    instruct_46(65,2000);   --  46(2E):一灯增加内力2000
    instruct_1(2104,244,1);   --  1(1):[???]说: 我，我，大师，我……
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2105,65,0);   --  1(1):[一灯]说: 孩子，有人让你来杀我，是*不是？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2106,0,1);   --  1(1):[资差]说: 是，晚辈一时糊涂，差点误*入歧途
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2107,65,0);   --  1(1):[一灯]说: 苦海无边，回头是岸
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,15,0,0,0,0,0,6104,6104,6104,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [15]
    instruct_3(-2,14,0,0,0,0,0,8218,8218,8218,-2,-2,-2);   --  3(3):修改事件定义:当前场景:场景事件编号 [14]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(2108,67,0);   --  1(1):[裘千仞]说: 这小子果然靠不住
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2109,60,0);   --  1(1):[欧阳锋]说: 嘿嘿，我已查清，害死我侄*儿的就是你这小子，拿命来
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_47(60,90);   --  47(2F):欧阳锋增加攻击力90

    if instruct_6(175,3,0,0) ==false then    --  6(6):战斗[175]是则跳转到:Label2
        instruct_15(0);   --  15(F):战斗失败，死亡
        do return; end
    end    --:Label2

    instruct_3(-2,14,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [14]
    instruct_3(-2,15,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [15]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(2110,0,1);   --  1(1):[资差]说: 大师，你没事吧。都怪我不*好……
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2111,65,0);   --  1(1):[一灯]说: 孩子，不要自责，你能够悬*崖勒马，十分难能，我这里*有本一阳指秘笈，就送与少*侠吧。望你能洗心革面，重*新做人。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_2(96,1);   --  2(2):得到物品[一阳指法][1]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2112,0,1);   --  1(1):[资差]说: 谨遵大师教诲。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2113,65,0);   --  1(1):[一灯]说: 蓉儿，你和靖儿也回去吧。*用我教你们的方法给七公疗*伤，很快就能痊愈。然后叫*你师父和你爹爹都来重阳宫*。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2114,56,0);   --  1(1):[黄蓉]说: 重阳宫？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2115,65,0);   --  1(1):[一灯]说: 是啊，此事关系重大，让他*们二人尽快赶到。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(2116,56,0);   --  1(1):[黄蓉]说: 是，那我们告辞了。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,7,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [7]
    instruct_3(-2,8,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [8]
    instruct_3(19,28,1,0,511,0,0,6124,6124,6124,-2,-2,-2);   --  3(3):修改事件定义:场景[重阳宫]:场景事件编号 [28]
    instruct_3(19,29,1,0,511,0,0,6152,6152,6152,-2,-2,-2);   --  3(3):修改事件定义:场景[重阳宫]:场景事件编号 [29]
    instruct_3(19,30,1,0,511,0,0,8238,8238,8238,-2,-2,-2);   --  3(3):修改事件定义:场景[重阳宫]:场景事件编号 [30]
    instruct_3(19,0,1,0,511,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:场景[重阳宫]:场景事件编号 [0]
    instruct_3(75,41,1,0,484,0,0,6088,6088,6088,-2,-2,-2);   --  3(3):修改事件定义:场景[桃花岛]:场景事件编号 [41]
    instruct_3(75,42,1,0,484,0,0,6090,6090,6090,-2,-2,-2);   --  3(3):修改事件定义:场景[桃花岛]:场景事件编号 [42]
    instruct_35(60,1,104,900);   --  35(23):设置欧阳锋武功1:逆运真经攻击力900
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
--end

