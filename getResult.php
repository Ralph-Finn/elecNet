<?php
# $commandBt="C:/Users/Ralph/desktop/test/for_testing/test.exe";
#　exec($commandBt);
set_time_limit(0);
date_default_timezone_set('Asia/ShangHai');
$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
$con=socket_connect($socket,'127.0.0.1',4004);
if(!$con){socket_close($socket);exit;}	
$a = 0;
while($con){
        $words='1';
        socket_write($socket,$words);
		$a = $a + 1;
        if($a==1000){break;}
}
$hear=socket_read($socket,1024);
socket_shutdown($socket);
$hear = $hear - 0;
readResult();


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
	echo json_encode($data);
}
?>