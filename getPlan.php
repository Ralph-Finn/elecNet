<?php
$servername = "localhost";
$username = "root";
$password = "root";
$dbname = "elecnet";
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("连接失败: " . $conn->connect_error);
}
function queryDB($conn, $table) 
{ 
$sql = "SELECT * from"." ".$table;//从数据库中名为node的表中获取所有的节点数据
$result = $conn->query($sql);
 
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
		$data[] = $row;
    }
	return $data;
} else {
    echo "0 result";
}
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
	
$data = array(queryDB($conn,"node"),queryDB($conn,"line"),readCSV('addNode'),readCSV('addLine'),readCSV('addInfo'),readCSV('addEqu'));
echo json_encode($data);
$conn->close();
?>
