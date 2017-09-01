	var map = new BMap.Map('allmap');
	map.addControl(new BMap.NavigationControl());
	map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
	map.addControl(new BMap.MapTypeControl()); 
	map.centerAndZoom(new BMap.Point(113.340217, 23.12408 ), 16);
	$(function(){
		$.ajax({
			url:'./getMux.php',
			type:'post',
			dataType:'json', 
			success:function(data){
				console.log(data);
				drawPoint(data);
				showTable(data);
				$("#blank").css("height","20px");
			}
		});
	});
	
	
function drawPoint(data)
 {
	var point1=new BMap.Point(113.14,23.08);
	pointClub = data[7];
	console.log('in drawPoint function');
	var Icon = new Array();
	var Center = new Array();
	for(i=0;i<8;i++)
	{
		//构造icon的列表，这里面的图片非常的完全。
		var mac = new BMap.Icon("./resource/n"+ String(i)+".png", new BMap.Size(15, 15), {});
		var cen = new BMap.Icon("./resource/t"+ String(i)+".png", new BMap.Size(25, 25), {});
		Icon.push(mac);
		Center.push(cen);
	}
	var station = new BMap.Icon("./resource/station.png", new BMap.Size(40, 40), {});
	for(var key in pointClub){ 	
		point1.lng=pointClub[key]['lng'];
		point1.lat=pointClub[key]['lat'];
	  //覆盖物点坐标
		if(pointClub[key]['center']==1){
			var marker = new BMap.Marker(point1,{icon: Center[pointClub[key]['section']]});
		}else if(pointClub[key]['center']==0){
			var marker = new BMap.Marker(point1,{icon: Icon[pointClub[key]['section']]});
				}else{
						var marker = new BMap.Marker(point1,{icon:station});
					}
		map.addOverlay(marker);
	}

 }
 
 function showTable(data){
	var tableData = new Array();
	for(var key in data[7]){
		var gu = [];
		gu.push(parseFloat(data[7][key]['lng']).toFixed( 4 ),parseFloat(data[7][key]['lat']).toFixed( 4 ),data[7][key]['val']);
		//表格中每一行均包含有四个数据
		tableData.push(gu);
	}
	console.log(tableData);
	setTable(tableData);
}
 
 function setTable(tableData){
	$('#myTable').dataTable( {
		"dom": '<"top">t<"bottom"><"clear"iflp>',
        "data": tableData,
		"autoWidth": false,
		"scrollX": false,
		 "info": false,
		 "paging": false,
		 "jQueryUI": true,
		 "scrollY": 300,
         "scrollCollapse": true,
		 "hover":true,
		 "destroy": true,
		 "searching": false,
        "columns": [
            { "title": "经度","width":"100px" },
            { "title": "纬度" ,"width":"100px"},
            { "title": "建桩数" ,"width":"80px"}
        ]
    } );
	$("#myTable tr").hover(function(){
    $(this).css("background-color","#81C0C0");
    },function(){
    $(this).css("background-color","white");
	});
}
