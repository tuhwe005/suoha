#!/bin/bash
# censys.io
echo 给 https://t.me/CF_NAT/38811 这里面对应架构的文件
echo 重命名为 iptestport 并放到脚本同一目录下

a=1
function resolve(){
b=1
for i in `cat ip.txt | awk '{print $1":"$2}'`
do
	ip=$(echo $i | awk -F: '{print $1}')
	port=$(echo $i | awk -F: '{print $2}')
	if [ $a == $b ]
	then
		a=$[$a+1]
		if [ $(curl -s --resolve search.censys.io:$port:$ip 'https://search.censys.io:'$port'/cdn-cgi/trace' | grep 'h=search.censys.io' | wc -l) == 1 ]
		then
			echo $ip:$port 可用
			break
		else
			echo $ip:$port 不可用
		fi
	else
		b=$[$b+1]
	fi
done
}

read -p "请输入选择模式(默认1.国家或地区模式,0.自治域模式): " mode
if [ -z "$mode" ]
then
	mode=1
fi
read -p "请输入需要TLS(默认1.是,0.否): " tls
if [ -z "$tls" ]
then
	tls=1
fi
chmod +x iptestport
if [ $mode == 1 ]
then
	read -p "请输入需要搜索的国家或者地区(默认Hong Kong): " country
	if [ -z "$country" ]
	then
		country="Hong Kong"
	fi
	country=$(echo $country | sed -e 's/ /+/g')
	echo $(echo $country | sed -e 's/+/ /g') TLS $tls
	if [ $tls == 1 ]
	then
		resolve
		while true
		do
			curl -s --resolve search.censys.io:$port:$ip 'https://search.censys.io:'$port'/_search?resource=hosts&sort=RELEVANCE&per_page=100&virtual_hosts=EXCLUDE&q=%28services.http.response.body_hash%3D%22sha1%3A441671eacb9398792d435443beaddd3fc5fa1910%22+or+services.http.response.body_hash%3D%22sha1%3A108b6115dc6ebfde76aef4336126f605252d957f%22%29+and+location.country%3D%60'$country'%60+and+ip%3A+0.0.0.0%2F0+and+not+autonomous_system.asn%3A+%7B209242%2C13335%7D'>temp
			if [ $(grep ratelimit temp | wc -l) == 1 ] || [ $(grep Results temp | awk '{print $3}' | wc -l) == 0 ]
			then
				resolve
			else
				break
			fi
		done
		grep "/HTTP</a>" temp | awk -F/ '{print $5,$7}' | awk -F? '{print $1,$2}' | awk -F\> '{print $1,$5}' | awk '{print $1,$3}'>$country-tls.txt
		echo 当前搜索结果 $(grep Results temp | awk '{print $3}' | awk -F\< '{print $1}') 个
		sleep 1
		while true
		do
			if [ $(tail -n 6 temp | grep disabled | wc -l) == 1 ]
			then
				rm -rf temp
				break
			else
				cursor=$(tail -n 6 temp | grep cursor | awk -F'cursor=' '{print $2}' | awk -F\> '{print $1}')
				while true
				do
					curl -s --resolve search.censys.io:$port:$ip 'https://search.censys.io:'$port'/_search?resource=hosts&sort=RELEVANCE&per_page=100&virtual_hosts=EXCLUDE&q=%28services.http.response.body_hash%3D%22sha1%3A441671eacb9398792d435443beaddd3fc5fa1910%22+or+services.http.response.body_hash%3D%22sha1%3A108b6115dc6ebfde76aef4336126f605252d957f%22%29+and+location.country%3D%60'$country'%60+and+ip%3A+0.0.0.0%2F0+and+not+autonomous_system.asn%3A+%7B209242%2C13335%7D&cursor='$cursor''>temp
					if [ $(grep ratelimit temp | wc -l) == 1 ] || [ $(grep Results temp | awk '{print $3}' | wc -l) == 0 ]
					then
						resolve
					else
						break
					fi
				done
				grep "/HTTP</a>" temp | awk -F/ '{print $5,$7}' | awk -F? '{print $1,$2}' | awk -F\> '{print $1,$5}' | awk '{print $1,$3}'>>$country-tls.txt
				echo 当前搜索结果 $(grep Results temp | awk '{print $3}' | awk -F\< '{print $1}') 个
				sleep 1
			fi
		done
	else
		resolve
		while true
		do
			curl -s --resolve search.censys.io:$port:$ip 'https://search.censys.io:'$port'/_search?resource=hosts&sort=RELEVANCE&per_page=100&virtual_hosts=EXCLUDE&q=services.http.response.html_tags%3D%22%3Ctitle%3EDirect+IP+access+not+allowed+%7C+Cloudflare%3C%2Ftitle%3E%22+and+location.country%3D%60'$country'%60+and+ip%3A+0.0.0.0%2F0+and+not+autonomous_system.asn%3A+%7B209242%2C13335%7D'>temp
			if [ $(grep ratelimit temp | wc -l) == 1 ] || [ $(grep Results temp | awk '{print $3}' | wc -l) == 0 ]
			then
				resolve
			else
				break
			fi
		done
		grep "/HTTP</a>" temp | awk -F/ '{print $5,$7}' | awk -F? '{print $1,$2}' | awk -F\> '{print $1,$5}' | awk '{print $1,$3}'>$country.txt
		echo 当前搜索结果 $(grep Results temp | awk '{print $3}' | awk -F\< '{print $1}') 个
		sleep 1
		while true
		do
			if [ $(tail -n 6 temp | grep disabled | wc -l) == 1 ]
			then
				rm -rf temp
				break
			else
				cursor=$(tail -n 6 temp | grep cursor | awk -F'cursor=' '{print $2}' | awk -F\> '{print $1}')
				while true
				do
					curl -s --resolve search.censys.io:$port:$ip 'https://search.censys.io:'$port'/_search?resource=hosts&sort=RELEVANCE&per_page=100&virtual_hosts=EXCLUDE&q=services.http.response.html_tags%3D%22%3Ctitle%3EDirect+IP+access+not+allowed+%7C+Cloudflare%3C%2Ftitle%3E%22+and+location.country%3D%60'$country'%60+and+ip%3A+0.0.0.0%2F0+and+not+autonomous_system.asn%3A+%7B209242%2C13335%7D&cursor='$cursor''>temp
					if [ $(grep ratelimit temp | wc -l) == 1 ] || [ $(grep Results temp | awk '{print $3}' | wc -l) == 0 ]
					then
						resolve
					else
						break
					fi
				done
				grep "/HTTP</a>" temp | awk -F/ '{print $5,$7}' | awk -F? '{print $1,$2}' | awk -F\> '{print $1,$5}' | awk '{print $1,$3}'>>$country.txt
				echo 当前搜索结果 $(grep Results temp | awk '{print $3}' | awk -F\< '{print $1}') 个
				sleep 1
			fi
		done
	fi
	clear
	echo 完成
	if [ $tls == 1 ]
	then
		if [ $(cat $country-tls.txt | wc -l) == 0 ]
		then
			echo 没有搜索结果
			rm -rf $country-tls.txt
		else
			./iptestport -file=$country-tls.txt -outfile=$country-tls.csv -tls=true -speedtest=0
		fi
	else
		if [ $(cat $country.txt | wc -l) == 0 ]
		then
			echo 没有搜索结果
			rm -rf $country.txt
		else
			./iptestport -file=$country.txt -outfile=$country.csv -tls=false -speedtest=0
		fi
	fi
else
	read -p "请输入需要搜索的AS(默认8075): " asn
	if [ -z "$asn" ]
	then
		asn=8075
	fi
	echo AS$asn TLS $tls
	if [ $tls == 1 ]
	then
		resolve
		while true
		do
			curl -s --resolve search.censys.io:$port:$ip 'https://search.censys.io:'$port'/_search?resource=hosts&sort=RELEVANCE&per_page=100&virtual_hosts=EXCLUDE&q=%28services.http.response.body_hash%3D%22sha1%3A441671eacb9398792d435443beaddd3fc5fa1910%22+or+services.http.response.body_hash%3D%22sha1%3A108b6115dc6ebfde76aef4336126f605252d957f%22%29+and+autonomous_system.asn%3A+'$asn'+and+ip%3A+0.0.0.0%2F0'>temp
			if [ $(grep ratelimit temp | wc -l) == 1 ] || [ $(grep Results temp | awk '{print $3}' | wc -l) == 0 ]
			then
				resolve
			else
				break
			fi
		done
		grep "/HTTP</a>" temp | awk -F/ '{print $5,$7}' | awk -F? '{print $1,$2}' | awk -F\> '{print $1,$5}' | awk '{print $1,$3}'>$asn-tls.txt
		echo 当前搜索结果 $(grep Results temp | awk '{print $3}' | awk -F\< '{print $1}') 个
		sleep 1
		while true
		do
			if [ $(tail -n 6 temp | grep disabled | wc -l) == 1 ]
			then
				rm -rf temp
				break
			else
				cursor=$(tail -n 6 temp | grep cursor | awk -F'cursor=' '{print $2}' | awk -F\> '{print $1}')
				while true
				do
					curl -s --resolve search.censys.io:$port:$ip 'https://search.censys.io:'$port'/_search?resource=hosts&sort=RELEVANCE&per_page=100&virtual_hosts=EXCLUDE&q=%28services.http.response.body_hash%3D%22sha1%3A441671eacb9398792d435443beaddd3fc5fa1910%22+or+services.http.response.body_hash%3D%22sha1%3A108b6115dc6ebfde76aef4336126f605252d957f%22%29+and+autonomous_system.asn%3A+'$asn'+and+ip%3A+0.0.0.0%2F0&cursor='$cursor''>temp
					if [ $(grep ratelimit temp | wc -l) == 1 ] || [ $(grep Results temp | awk '{print $3}' | wc -l) == 0 ]
					then
						resolve
					else
						break
					fi
				done
				grep "/HTTP</a>" temp | awk -F/ '{print $5,$7}' | awk -F? '{print $1,$2}' | awk -F\> '{print $1,$5}' | awk '{print $1,$3}'>>$asn-tls.txt
				echo 当前搜索结果 $(grep Results temp | awk '{print $3}' | awk -F\< '{print $1}') 个
				sleep 1
			fi
		done
	else
		resolve
		while true
		do
			curl -s --resolve search.censys.io:$port:$ip 'https://search.censys.io:'$port'/_search?resource=hosts&sort=RELEVANCE&per_page=100&virtual_hosts=EXCLUDE&q=services.http.response.html_tags%3D%22%3Ctitle%3EDirect+IP+access+not+allowed+%7C+Cloudflare%3C%2Ftitle%3E%22+and+autonomous_system.asn%3A+'$asn'+and+ip%3A+0.0.0.0%2F0'>temp
			if [ $(grep ratelimit temp | wc -l) == 1 ] || [ $(grep Results temp | awk '{print $3}' | wc -l) == 0 ]
			then
				resolve
			else
				break
			fi
		done
		grep "/HTTP</a>" temp | awk -F/ '{print $5,$7}' | awk -F? '{print $1,$2}' | awk -F\> '{print $1,$5}' | awk '{print $1,$3}'>$asn.txt
		echo 当前搜索结果 $(grep Results temp | awk '{print $3}' | awk -F\< '{print $1}') 个
		sleep 1
		while true
		do
			if [ $(tail -n 6 temp | grep disabled | wc -l) == 1 ]
			then
				rm -rf temp
				break
			else
				cursor=$(tail -n 6 temp | grep cursor | awk -F'cursor=' '{print $2}' | awk -F\> '{print $1}')
				while true
				do
					curl -s --resolve search.censys.io:$port:$ip 'https://search.censys.io:'$port'/_search?resource=hosts&sort=RELEVANCE&per_page=100&virtual_hosts=EXCLUDE&q=services.http.response.html_tags%3D%22%3Ctitle%3EDirect+IP+access+not+allowed+%7C+Cloudflare%3C%2Ftitle%3E%22+and+autonomous_system.asn%3A+'$asn'+and+ip%3A+0.0.0.0%2F0&cursor='$cursor''>temp
					if [ $(grep ratelimit temp | wc -l) == 1 ] || [ $(grep Results temp | awk '{print $3}' | wc -l) == 0 ]
					then
						resolve
					else
						break
					fi
				done
				grep "/HTTP</a>" temp | awk -F/ '{print $5,$7}' | awk -F? '{print $1,$2}' | awk -F\> '{print $1,$5}' | awk '{print $1,$3}'>>$asn.txt
				echo 当前搜索结果 $(grep Results temp | awk '{print $3}' | awk -F\< '{print $1}') 个
				sleep 1
			fi
		done
	fi
	clear
	echo 完成
	if [ $tls == 1 ]
	then
		if [ $(cat $asn-tls.txt | wc -l) == 0 ]
		then
			echo 没有搜索结果
			rm -rf $asn-tls.txt
		else
			./iptestport -file=$asn-tls.txt -outfile=$asn-tls.csv -tls=true -speedtest=0
		fi
	else
		if [ $(cat $asn.txt | wc -l) == 0 ]
		then
			echo 没有搜索结果
			rm -rf $asn.txt
		else
			./iptestport -file=$asn.txt -outfile=$asn.csv -tls=false -speedtest=0
		fi
	fi
fi
