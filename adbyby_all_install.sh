#!/bin/sh
#kysdm(gxk7231@gmail.com)
export ADBYBY=/usr/share/adbyby
export config=/etc/config
crontab=/etc/crontabs/root
cron=/etc/config/cron
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

sh_ver="1.0.2"

Download_adupdate(){
    wget -t3 -T10 --no-check-certificate -O $ADBYBY/adupdate.sh https://raw.githubusercontent.com/kysdm/adbyby/master/adupdate.sh
    chmod 777 $ADBYBY/adupdate.sh
    echo -e "${Info} 下载成功"   #可增加判断机制
}
Update_adupdate(){
    echo -e "${Error} 暂时未完成此功能"
}
delete_adupdate(){
 	rm -f $ADBYBY/adupdate.sh
 	echo -e "${Info} 删除成功"
}
run_adupdate(){
    sh $ADBYBY/adupdate.sh
}
restart_adbyby(){
    /etc/init.d/adbyby restart 2>&1
    echo -e "${Info} 重启完成"
}
restart_crontab(){
    /etc/init.d/cron restart 2>&1
    echo -e "${Info} 重启完成"
}
check_adupdate_log(){
    cat /tmp/log/adupdate.log
}
stop_adbyby(){
    /etc/init.d/adbyby stop
    echo -e "${Info} 停止成功"
}
auto_adupdate_install(){
	echo && echo -e "
—————未安装规则辅助更新脚本
 ${Green_font_prefix}1.${Font_color_suffix} 添加自动更新规则功能，web计划任务界面为一个框(常见界面需自己手打任务时间)
—————已安装规则辅助更新脚本
 ${Green_font_prefix}2.${Font_color_suffix} 添加自动更新规则功能，web计划任务界面为可视化操控界面(新版pandorabox固件)
 ${Green_font_prefix}3.${Font_color_suffix} 添加自动更新规则功能，web计划任务界面为一个框(常见界面需自己手打任务时间)
 ${Green_font_prefix}4.${Font_color_suffix} 添加自动更新规则功能，web计划任务界面为可视化操控界面(非新版pandorabox固件)
————————————
 ${Green_font_prefix}5.${Font_color_suffix} 重启crontab进程
 ${Green_font_prefix}6.${Font_color_suffix} 退出
————————————" && echo
    read -p " 现在选择顶部选项 [1-6]: " input
    case $input in 
	 1) auto_adupdate4_install;;
	 2) auto_adupdate1_install;;
	 3) auto_adupdate2_install;;
     4) auto_adupdate3_install;;
	 5) restart_crontab;;
	 6) exit 0	;;
	 *) echo -e "${Error} 请输入正确的数字 [1-6]" && exit 1;;
    esac
}
auto_adupdate1_install(){
	if  grep -q adupdate $cron ; then
	   plan_the_task_line=$(grep -n "$ADBYBY/adupdate.sh" $cron  | awk '{print $1}' | sed 's/://g')
	   rod=`expr $plan_the_task_line - 4`
	   sed -i "$rod,+4d" $cron
       echo "" >> $cron
       echo "config task" >> $cron
       echo "	option enabled '1'" >> $cron
       echo "	option task_name 'adbyby规则更新'" >> $cron
       echo "	option custom '1'" >> $cron
       echo "	option custom_cron_table '30 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1'" >> $cron
       /etc/init.d/cron restart
       echo -e "${Info} 写入完成";
	 else
	   echo "" >> $cron
       echo "config task" >> $cron
       echo "	option enabled '1'" >> $cron
       echo "	option task_name 'adbyby规则更新'" >> $cron
       echo "	option custom '1'" >> $cron
       echo "	option custom_cron_table '30 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1'" >> $cron
       /etc/init.d/cron restart
       echo -e "${Info} 写入完成";
	fi 
}
auto_adupdate2_install(){
	sed -i '/adbyby/d' $crontab
    echo '30 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1' >> $crontab
    /etc/init.d/cron restart 
    echo -e "${Info} 写入完成"
}
auto_adupdate3_install(){
    echo -e "${Error} 因没有对应固件无法做支持"
    echo -e "${Info} 请手动添加计划任务到系统中，命令如下"
	echo -e "${Info} '30 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1'"
}
auto_adupdate4_install(){
	sed -i '/adbyby/d' $crontab
    echo '30 */6 * * * /etc/init.d/adbyby restart 2>&1' >> $crontab
    /etc/init.d/cron restart 
    echo -e "${Info} 写入完成"
}

auto_adupdate_uninstall(){
	echo && echo -e "
—————未安装规则辅助更新脚本启用自动更新规则功能的
 ${Green_font_prefix}1.${Font_color_suffix} 删除自动更新规则功能，web计划任务界面为一个框(常见界面需自己手打任务时间)
—————已安装规则辅助更新脚本启用自动更新规则功能的
 ${Green_font_prefix}2.${Font_color_suffix} 删除自动更新规则功能，web计划任务界面为可视化操控界面(新版pandorabox固件)
 ${Green_font_prefix}3.${Font_color_suffix} 删除自动更新规则功能，web计划任务界面为一个框(常见界面需自己手打任务时间)
 ${Green_font_prefix}4.${Font_color_suffix} 删除自动更新规则功能，web计划任务界面为可视化操控界面(非新版pandorabox固件)
————————————
 ${Green_font_prefix}5.${Font_color_suffix} 重启crontab进程
 ${Green_font_prefix}6.${Font_color_suffix} 退出
————————————" && echo
    read -p " 现在选择顶部选项 [1-6]: " input
    case $input in 
	 1) auto_adupdate4_uninstall;;
	 2) auto_adupdate1_uninstall;;
	 3) auto_adupdate2_uninstall;;
     4) auto_adupdate3_uninstall;;
	 5) restart_crontab;;
	 6) exit 0	;;
	 *) echo -e "${Error} 请输入正确的数字 [1-6]" && exit 1;;
    esac
}
auto_adupdate1_uninstall(){
	if  grep -q adupdate $cron ; then
	   plan_the_task_line=$(grep -n "$ADBYBY/adupdate.sh" $cron  | awk '{print $1}' | sed 's/://g')
	   rod=`expr $plan_the_task_line - 4`
	   sed -i "$rod,+4d" $cron
	   /etc/init.d/cron restart
       echo -e "${Info} 删除成功";
	 else
     echo -e "${Info} 未添加计划任务"
	fi 
}
auto_adupdate2_uninstall(){
	sed -i '/adbyby/d' $crontab
    /etc/init.d/cron restart 
    echo -e "${Info} 删除成功"
}
auto_adupdate3_uninstall(){
    echo -e "${Error} 因没有对应固件无法做支持"
    echo -e "${Info} 请手动删除添加的计划任务"
}
auto_adupdate4_uninstall(){
	sed -i '/adbyby/d' $crontab
    /etc/init.d/cron restart 
    echo -e "${Info} 删除成功"
}
#主菜单
# cat << EOF
#  ADBYBY一键管理脚本  ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
# ********请输入您的选择:(1-13)****
#  \${Green_font_prefix}1.${Font_color_suffix} 安装LCUI_ADBYBY程序  待做
#  \${Green_font_prefix}2.${Font_color_suffix} 删除LCUI_ADBYBY程序  待做 
# ————————————
#  ${Green_font_prefix}3.${Font_color_suffix} 下载规则辅助更新脚本
#  ${Green_font_prefix}4.${Font_color_suffix} 更新规则辅助更新脚本  待做
#  ${Green_font_prefix}5.${Font_color_suffix} 删除规则辅助更新脚本
#  ${Green_font_prefix}6.${Font_color_suffix} 运行规则辅助更新脚本
# ————————————
#  ${Green_font_prefix}7.${Font_color_suffix} 添加自动更新规则功能
# ————————————
#  ${Green_font_prefix}8.${Font_color_suffix} 重启ADBYBY主程序
#  ${Green_font_prefix}9.${Font_color_suffix} 停止ADBYBY进程
#  ${Green_font_prefix}10.${Font_color_suffix} 查看规则辅助更新脚本日志
# ————————————
#  ${Green_font_prefix}11.${Font_color_suffix} 其他功能 待做
#  ${Green_font_prefix}12.${Font_color_suffix} 升级脚本 待做
#  ${Green_font_prefix}13.${Font_color_suffix} 退出菜单
# ————————————
# EOF
echo && echo -e "
  ADBYBY一键管理脚本  ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
————————————
 ${Green_font_prefix}1.${Font_color_suffix} 安装LCUI_ADBYBY程序  待做
 ${Green_font_prefix}2.${Font_color_suffix} 删除LCUI_ADBYBY程序  待做 
————————————
 ${Green_font_prefix}3.${Font_color_suffix} 下载规则辅助更新脚本
 ${Green_font_prefix}4.${Font_color_suffix} 更新规则辅助更新脚本  待做
 ${Green_font_prefix}5.${Font_color_suffix} 删除规则辅助更新脚本
 ${Green_font_prefix}6.${Font_color_suffix} 运行规则辅助更新脚本
————————————
 ${Green_font_prefix}7.${Font_color_suffix} 添加自动更新规则功能
 ${Green_font_prefix}8.${Font_color_suffix} 删除自动更新规则功能
————————————
 ${Green_font_prefix}9.${Font_color_suffix} 重启ADBYBY主程序
 ${Green_font_prefix}10.${Font_color_suffix} 停止ADBYBY进程
 ${Green_font_prefix}11.${Font_color_suffix} 查看规则辅助更新脚本日志
————————————
 ${Green_font_prefix}12.${Font_color_suffix} 其他功能 待做
 ${Green_font_prefix}13.${Font_color_suffix} 升级脚本 待做
 ${Green_font_prefix}14.${Font_color_suffix} 退出菜单
————————————" && echo
read -p "现在选择顶部选项 [1-14]: " input
case $input in 
	1) echo -e  "${Error} 未完成";;
	2) echo -e  "${Error} 未完成";;
	3) Download_adupdate;;
    4) Update_adupdate;;
	5) delete_adupdate;;
	6) run_adupdate;;
	7) auto_adupdate_install;;
	8) auto_adupdate_uninstall;;	
	9) restart_adbyby;;
	10) stop_adbyby;;
	11) check_adupdate_log;;
	12) echo -e  "${Error} 未完成";;
	13) echo -e  "${Error} 未完成";;
	14) exit 0	;;
	*) echo -e "${Error} 请输入正确的数字 [1-14]" && exit 1;;
esac