<?php
	//move_uploaded_file($tmp_name,'./upload/'.iconv("UTF-8", "gbk",$name));
	header("Content-type: text/html; charset=utf-8"); 
	if(move_uploaded_file($_FILES['file']['tmp_name'],'./resource/up.xls')){
		echo '上传成功！！！';  
    }  
    else  
    {
		$res = 0;
		echo json_encode($res);  
		} 
?>