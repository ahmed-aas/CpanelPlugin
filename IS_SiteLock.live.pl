#!/usr/local/cpanel/3rdparty/bin/perl

BEGIN {
    unshift @INC, '/usr/local/cpanel';
}

use Cpanel::LiveAPI ();
my $cpanel = Cpanel::LiveAPI->new();

# Turn off buffering
$| = 1;

my $USERPATH = $cpanel->cpanelprint('$homedir');
print "Content-type: text/html\r\n\r\n";
print $cpanel->header('Internet Solutions Site Lock! v1.1');



print <<END;
<!DOCTYPE html>
<html>
<head>
<title>
Internet Solutions Site Lock</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style type="text/css">
body {background-color:ffffff;background-repeat:no-repeat;background-position:top left;background-attachment:fixed;}
h3{font-family:Cursive;color:FFFFCC;background-color:3333CC;}
p {font-family:verdana;font-size:16px;font-style:normal;font-weight:bold;color:000000;background-color:FFFFCC;}
</style>

<style>
	/* The switch - the box around the slider */
.switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
}

/* Hide default HTML checkbox */
.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

/* The slider */
.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  -webkit-transition: .4s;
  transition: .4s;
}

.slider:before {
  position: absolute;
  content: "";
  height: 26px;
  width: 26px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  -webkit-transition: .4s;
  transition: .4s;
}

input:checked + .slider {
  background-color: #2196F3;
}

input:focus + .slider {
  box-shadow: 0 0 1px #2196F3;
}

input:checked + .slider:before {
  -webkit-transform: translateX(26px);
  -ms-transform: translateX(26px);
  transform: translateX(26px);
}

/* Rounded sliders */
.slider.round {
  border-radius: 34px;
}

.slider.round:before {
  border-radius: 50%;
}
</style>

<style>
#myProgress {
  width: 100%;
  background-color: #ddd;
}

#myBar {
  width: 0%;
  height: 30px;
  background-color: #4CAF50;
  text-align: center;
  line-height: 30px;
  color: white;
}
</style>
<script>
function move() {
  var elem = document.getElementById("myBar");   
  var width = 0;
  var id = setInterval(frame, 700);
  function frame() {
    if (width >= 100) {
      clearInterval(id);
      location.href=location.href;
    } else {
      width++; 
      elem.style.width = width + '%'; 
      elem.innerHTML = width * 1  + '%';
    }
  }

}
</script>


</head>
<body>
<p>This is a webhosting site lock tool that designed to secure wordpress websites from hackers .. <b>Developed by Eng. Ahmed Abdel Fattah  </b>
<br><br>
</p>

<hr>
<div id="myProgress">
  <div id="myBar">0%</div>
</div>

END

#==============================================

print "<font color='grey'>The locking operation for site $USERPATH  may take upto 1 minute to update ...</font><P>\n";
#print  $USERPATH;

#check the folder attr if locked (Immutable) applied
my $string = qx[lsattr -l -d $USERPATH/public_html];

my $substring='immutable';
my $CurrentStatus='';
#print index(lc($string), $substring);
#print $substring;
if (index(lc($string), $substring) != -1) {
$CurrentStatus='checked'; 
#print "Lock On"}else{print "Lock Off"
}
#check lock current status
if($CurrentStatus == "checked"){
#print "<br>do check"}else{print "<br>don't check"
}

# check if wp protection applied 
my $Wpcheck = qx[ grep -iRl "BEGIN ISsitelock code Password Protected" $USERPATH/public_html/.htaccess];

if ($Wpcheck){
$CurrentWpStatus="checked";
}
else{
$CurrentWpStatus="";
}



#get the checkbox action
use CGI;
my $q = CGI->new();
if ( $q->param("submit") )
{

use DateTime;
my $dt = DateTime->now;

if ($q->param('chkStatus')) {
    # checkbox was checked
    print "<br>checked....please wait.<script>move()</script>";
#log action time in file

my @WriteFile = qx[ echo "lock@"+$dt >> $USERPATH/isLock.txt];

# apply lock cmd
my @WriteCronFile = qx[echo $USERPATH >> /usr/local/cpanel/base/frontend/paper_lantern/IS_SiteLock/cronLock.txt];
}
else {
    # checkbox left unchecked
    print "<br>un checked....please wait<script>move()</script>";
#log action time in file

my @WriteFile = qx[ echo "unlock@"+$dt >> $USERPATH/isLock.txt];

my @WriteCronFile = qx[echo $USERPATH >> /usr/local/cpanel/base/frontend/paper_lantern/IS_SiteLock/cronUnLock.txt];
}

#start wpadmin protect 
if ($q->param('chkWpadmin')) {
print "add admin protection";
###########add  wpadmin protect
# Create the password file

my @Wpadmin = qx[ echo -e "adminis:"'\$apr1''\$OBDtrwGs''\$o'"/kpsL2zqtg3CZf00Mkjv/" > $USERPATH/.IsSiteLock-wpadmin];

# remove old code from .htaccess if any
my @WpadminR = qx[ sed -i '/#BEGIN ISsitelock/,/#END ISsitelock/d' $USERPATH/public_html/.htaccess];

# add the protection rule in .htaccess
my @WpadminA = qx[ echo '#BEGIN ISsitelock code Password Protected wp-admin directory
ErrorDocument 401 "Unauthorized Access"
ErrorDocument 403 "Forbidden"
<FilesMatch "wp-login.php">
AuthName "Authorized Only"
AuthType Basic
AuthUserFile $USERPATH/.IsSiteLock-wpadmin
require valid-user
</FilesMatch>
#END ISsitelock ' >> $USERPATH/public_html/.htaccess];

##########
}
else{
# remove old code from .htaccess if any
my @WpadminR = qx[ sed -i '/#BEGIN ISsitelock/,/#END ISsitelock/d' $USERPATH/public_html/.htaccess];

}

}
#==============================================



print <<END;

<form method="post" action="?">
<br><br>
Site Lock
<br>
<label class="switch">
  <input name="chkStatus" type="checkbox"  $CurrentStatus>
  <span class="slider round"></span>
</label>

<br><br>
Protect WP Admin directory with authorization,  user# <b>adminis</b>  || password# <b>is\@1234</b> (unlock sitelock first to apply)

<br>
<label class="switch">
  <input name="chkWpadmin" type="checkbox"  $CurrentWpStatus>
  <span class="slider round"></span>
</label>
<br><br>
<div style='height:100px'>
<input type="submit" name="submit" value="Proceed">
<br>

</div>
</form>


<p>
Please note that this is test lock tool. Each directory should be carefully examined for security issues. YOU SHOULD NOT BLINDLY COUNT ON THIS TOOL!
<p>
<a href="../index.html"><< return to Home</a>
END

print $cpanel->footer();
$cpanel->end();

