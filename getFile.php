<?php

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
	$data[]=readCSV('Fast_PC');
	$data[]=readCSV('Slow_PC');
	$data[]=readCSV('Fast_PT');
	$data[]=readCSV('Slow_PT');
	$data[]=readCSV('weekday_flow');
	$data[]=readCSV('init');
	$data[]=readCSV('Fast_Station');
	echo json_encode($data);
}
readResult();
?>