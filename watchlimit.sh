# @Author: Teng Fu
# @Date:   2019-07-29 18:08:00
# @Last Modified by:   Teng Fu
# @Last Modified time: 2019-07-29 18:08:16
echo fs.inotify.max_user_instances=1024 | tee -a /etc/sysctl.conf
echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf
sysctl -p