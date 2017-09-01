<?php 
function downfile()
{
 $filename=realpath("./server/result.xls"); //文件名
 $date=date("Ymd-H:i:m");
 Header( "Content-type:  application/octet-stream "); 
 Header( "Accept-Ranges:  bytes "); 
 Header( "Accept-Length: " .filesize($filename));
 header( "Content-Disposition:  attachment;  filename= {$date}.xls"); 
 echo file_get_contents($filename);
 readfile($filename); 
}
downfile();
?>