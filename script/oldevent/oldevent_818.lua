--function oldevent_818()
    instruct_1(3308,21,0);   --  1(1):[定闲]说: 大胆恶贼，竟擅闯无色庵．
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(3309,0,1);   --  1(1):[资差]说: 无色？你是色盲啊？*这儿五颜六色这麽多，*还说什麽无色．
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(3310,21,0);   --  1(1):[定闲]说: 大胆！胆敢在此清净之地，*口出狂言．
    instruct_0();   --  0(0)::空语句(清屏)

    if instruct_6(24,4,0,0) ==false then    --  6(6):战斗[24]是则跳转到:Label0
        instruct_0();   --  0(0)::空语句(清屏)
        instruct_15(0);   --  15(F):战斗失败，死亡
        do return; end
    end    --:Label0

    instruct_0();   --  0(0)::空语句(清屏)
    instruct_13();   --  13(D):重新显示场景
    instruct_1(3311,21,0);   --  1(1):[定闲]说: 莫非是左冷禅派你来的！*想不到左盟主为了五岳并派*之事，也不顾同盟之谊了．*回去告诉左冷禅，定闲还不*至忘了师祖的遗训，并派一*事我是绝对不会答应的．
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_2(131,1);   --  2(2):得到物品[万花剑法][1]
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_3(-2,-2,-2,0,819,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
--end

