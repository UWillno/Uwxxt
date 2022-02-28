getunamepasswd(){
uname=$(gpz 1)
passwd=$(gpz 2)
echo $uname $passwd
if [ $uname == "" ] || [ $passwd == "" ];then
	echo  "没有账号密码！"
else
	echo  "获取账号密码成功"
	getcookies $uname $passwd

fi
}
getcookies(){
status=$(curl -A "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.0)" -d "uname=$1&password=$2" -X POST https://passport2.chaoxing.com/fanyalogin -c cookies.txt  | cut -d":" -f4|cut -d"}" -f1)
if [ $status == true ];then
	echo $(date)获取cookies成功！ >> status.txt
else 
	echo $(date)账号或密码错误！>> status.txt
fi
}

getcourse(){
if [ -f cookies.txt ] && [ $status == true ] ;then
	echo 已有cookies
	html=$(curl -s -b cookies.txt -A "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.0)" -d "courseType=1&courseFolderId=0&courseFolderSize=1" http://mooc1-1.chaoxing.com/visit/courselistdata)
	if [[ $html == "" ]];then
		$status=false
		echo > "cookies可能失效"
		getunamepasswd
	else
		curl -s -b cookies.txt -A "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.0)" -d "courseType=1&courseFolderId=0&courseFolderSize=1" http://mooc1-1.chaoxing.com/visit/courselistdata > html.txt
		grep "<a href=\"https" html.txt  | cut -d  "\"" -f2 > urls.txt
	fi
else
	getunamepasswd
fi
}

getid(){
coursenum=$(sed -n '$=' urls.txt)
i=1
while (( i<=$coursenum ))
do
	courseid=$(sed -n "${i}p" urls.txt |cut -d"=" -f2|cut -d"&" -f1)
	clazzid=$(sed -n "${i}p" urls.txt |cut -d"=" -f3|cut -d"&" -f1)
	getactivities $courseid $clazzid
	((i++))
done
}
getactivities(){
curl -b cookies.txt "http://mobilelearn.chaoxing.com/v2/apis/active/student/activelist?fid=0&courseId=$1&classId=$2" > temp.txt
#echo "http://mobilelearn.chaoxing.com/v2/apis/active/student/activelist?fid=0&courseId=$1&classId=$2" >> Log.txt

sed -i "s/"\"status\":1"/#/g" temp.txt
ac_num=$(cat temp.txt | awk -F'#' '{print NF-1}')
j=1
if [ $ac_num > 0 ];then
	while (( j<=$ac_num ))
	do
		otherId=$(cat temp.txt | cut -d'#' -f$j | sed 's/"//g' |sed 's/,/\n/g' |sed 's/:/\n/g'|grep -A 1 otherId | grep '[0-9]')
		activity_id=$(cat temp.txt | cut -d'#' -f$j | sed 's/"//g' |sed 's/,/\n/g' |sed 's/:/\n/g'|grep -A 1 id | grep '[0-9]')
		sign $otherId $activity_id
		#result=$(curl -b cookies.txt "https://mobilelearn.chaoxing.com/v2/apis/sign/signIn?activeId=$activity_id")
		#result=$(echo $result | grep "success")
		if [[ "$result" != "" ]];then
			echo $(date)可能签到成功 >> Log.txt
		else
			echo $(date)暂不支持该类型签到 >> Log.txt
		fi
	((j++))		
	done
fi
}
gpz(){
	echo $(sed -n "${1}p" info.txt | cut -d'=' -f2 | cut -d '#' -f1)
}
sign(){
localsign=$(gpz 4)
 if [ $1 == 0 ] || [ $1 == 3 ] || [ $1 == 5 ];then
	 echo "普通签到或拍照签到或手势签到或学习码签到"
	result=$(curl -b cookies.txt "https://mobilelearn.chaoxing.com/v2/apis/sign/signIn?activeId=$2")
	result=$(echo $result | grep "success")
	photosign=$(gpz 3)
	if [ $photosign == 1 ];then
	result1=$(curl -b cookies.txt "https://mobilelearn.chaoxing.com/pptSign/stuSignajax?activeId=$2")
	fi
	if [[ "$result" != "" ]] || [[ "$result1" != "" ]];then
		echo $(date)可能签到成功 >> Log.txt
	else
		echo $(date)签到失败 >> Log.txt
	fi
elif [ $1 == 4 ] && [ $localsign == 1 ];then
	echo "位置签到"
	local=$(gpz 5)
	local_c=$(echo $local | tr -d '\n' | xxd -plain | sed 's/\(..\)/%\1/g')
	lat=$(gpz 6)
	lon=$(gpz 7)
	result=$(curl -b cookies.txt "https://mobilelearn.chaoxing.com/pptSign/stuSignajax?address=$local_c&activeId=$2&latitude=$lat&longitude=$lon&fid=0&appType=15&ifTiJiao=1")	
	if [[ "$result" != "" ]];then
			echo $(date)可能签到成功 >> Log.txt
		else
			echo $(date)签到失败 >> Log.txt
	fi

else
	echo "不支持自动签到类型或已经签到过了"
fi
}
#status=true
#getcourse
#getid
#getactivities 220800198 46763858
#getid
echo " " > Log.txt
getunamepasswd
while true
do
	getcourse
	getid
done
