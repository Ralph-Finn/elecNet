<?php
# $commandBt="C:/Users/Ralph/desktop/test/for_testing/test.exe";
#　exec($commandBt);
set_time_limit(0);
date_default_timezone_set('Asia/ShangHai');
$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
$con=socket_connect($socket,'127.0.0.1',4004);
if(!$con){socket_close($socket);exit;}
if ($_POST['type'] ==1){	
	$fp = fopen('./server/inputData.csv', 'w');  
	fputcsv($fp,array($_POST['ratio'],$_POST['weekday'],$_POST['delta'],$_POST['start'],$_POST['end']));
	fclose($fp);
}
if ($_POST['type'] ==2){
	$fp = fopen('./server/inputDatax.csv', 'w');  
	fputcsv($fp,array($_POST['ratio'],$_POST['weekday'],$_POST['fluency']));
	fclose($fp);
}
if ($_POST['type'] ==3){
	$fp = fopen('./server/inputDatay.csv', 'w');  
	fputcsv($fp,array($_POST['ratio'],$_POST['weekday'],$_POST['fluency']));
	fclose($fp);
}
$a = 0;
while($con){
        $words='0'+$_POST['type'];
        socket_write($socket,$words);
		$a = $a + 1;
        if($a==1000){break;}
}
$hear=socket_read($socket,1024);
socket_shutdown($socket);
$hear = $hear - 0;
if($hear == 0){
	echo json_encode($hear);
}else{
	readResult();
}


function readCSV($name){
	$data = array();
	$name = './server/output/'.$name.'.csv';
	$file = fopen($name,'r');	
	while ($row = fgetcsv($file)) {
		$data[] = $row;
	}
	return $data;
}

function readResult(){
	$data = array();
	$data[]=readCSV('charge_EV');
	$data[]=readCSV('MTFM');
	$data[]=readCSV('op_x');
	echo json_encode($data);
}
?>