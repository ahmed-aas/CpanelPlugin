#run cmd ./cron.sh > out.txt
#cron job 
#* * * * * /usr/local/cpanel/base/frontend/paper_lantern/IS_SiteLock/cron.sh
#empty text file : > access.log
#chmod a=rwx cronUnLock.txt

#start lock operation
while read p; do
  echo "$p";
if [ -d "$p" ]
then
 chattr -R +i $p/public_html ;
 chattr -R -i $p/public_html/wp-content/uploads;
 chattr -R -i $p/public_html/wp-content/wflogs;
 chattr -R -i $p/public_html/error_log;

echo  "# Disallows execution, except for browser readable images
<FilesMatch '(^#.*#|\.(asp|bak|config|cxz|dist|exe|fla|htm|inc|ini|jsp|log|mso|php|pl|psd|py|sh|shtml|sql|sw[op])|~)$'>
 Order allow,deny
 Deny from all
 Satisfy All
 </FilesMatch>" > $p/public_html/wp-content/uploads/.htaccess ;
 
else
 echo "not exist";
fi

# chattr -R +i $p/public_html;
done < /usr/local/cpanel/base/frontend/paper_lantern/IS_SiteLock/cronLock.txt

#empty text file
: > /usr/local/cpanel/base/frontend/paper_lantern/IS_SiteLock/cronLock.txt

#====================================
#start unlock operation
while read p; do
  echo "$p";
if [ -d "$p" ]
then
 chattr -R -i $p/public_html ;
  
else
 echo "not exist";
fi

done < /usr/local/cpanel/base/frontend/paper_lantern/IS_SiteLock/cronUnLock.txt

#empty text file
: > /usr/local/cpanel/base/frontend/paper_lantern/IS_SiteLock/cronUnLock.txt

