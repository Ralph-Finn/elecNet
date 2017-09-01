<?php
	//move_uploaded_file($tmp_name,'./upload/'.iconv("UTF-8", "gbk",$name));
	header("Content-type: text/html; charset=utf-8"); 
	if(move_uploaded_file($_FILES['file']['tmp_name'],'./server/data.xls')){
		//echo '上传成功！！！';  
    }  
    else  
    {
		$res = 0;
		//echo json_encode($res);  
		}
	///////进入文件传输机
	set_time_limit(0);
	date_default_timezone_set('Asia/ShangHai');
	$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
	$con=socket_connect($socket,'127.0.0.1',4004);
	if(!$con){socket_close($socket);exit;}	
	$a = 0;
	while($con){
			$words='x';
			socket_write($socket,$words);
			$a = $a + 1;
			if($a==1000){break;}
	}
	$hear=socket_read($socket,1024);
	socket_shutdown($socket);
	echo '上传成功！！！'; 	
?>