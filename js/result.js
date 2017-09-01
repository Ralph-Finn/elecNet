
$(function(){
	$('#list,#list1').hide();
	driving = routeClub();//这里生成的一个全局的变量
	console.log(driving);
	$( "#dialog" ).dialog({
		  autoOpen: false,
		  show: {
			effect: "blind",
			duration: 1000
		  },
		  hide: {
			effect: "explode",
			duration: 1
		  },
			width:800,
			height:400
    });
	$.ajax({
	url:'./getPlan.php',
	type:'post',
	dataType:'json', 
	success:function(data){
		console.log(data);
		drawPoint(data,0);
		drawRoute(data,0,1,driving[0],0);
		setTable(data[4]);
		
	}
	});
});

$("#drawS").click(function(){
	$("#list").show();
	type = $("#select").val();
	console.log(type);
	$.ajax({
	url:'./getPlan.php',
	type:'post',
	dataType:'json', 
	success:function(data){
		map.clearOverlays();
		//drawRoute(data,0,1,driving[0],0);
		drawPoint(data,0);
		drawTime(data,type);
	}
	});
});
/////////////////////////////////////////////
$("#drawR").click(function(){
	$("#list").show();
	//driving = routeClub();
	type = $("#select1").val();
	method = $('#select2').val();
	console.log([type,method]);
	$.ajax({
	url:'./getPlan.php',
	type:'post',
	dataType:'json', 
	success:function(data){
			map.clearOverlays();
			drawRoute(data,0,1,driving[0],type);
			drawSection(data,driving,type,method);
			drawPoint(data,type);
		
	}
	});
});
//////map的相关设置//////////////////////
var map = new BMap.Map('allmap');
//map.addControl(new BMap.NavigationControl());
map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
map.addControl(new BMap.MapTypeControl());
map.centerAndZoom(new BMap.Point(113.340217, 23.12408 ), 16);
////////////////////////////////////////////////////////
function drawPoint(data,type)
 {
	var point1=new BMap.Point(113.14,23.08);
	pointClub = data[0];
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
	var grey0 = new BMap.Icon("./resource/g0.png", new BMap.Size(25, 25), {});
	var grey1= new BMap.Icon("./resource/g1.png", new BMap.Size(10, 10), {});
	for(var key in pointClub){ 	
		point1.lng=pointClub[key]['lng'];
		point1.lat=pointClub[key]['lat'];
		if(type == 0){
		if(pointClub[key]['center']==1){
			var marker = new BMap.Marker(point1,{icon: grey0});
		}else if(pointClub[key]['center']==0){
			var marker = new BMap.Marker(point1,{icon: grey1});
	    }
		}
		else if(pointClub[key]['section'] == type){
		if(pointClub[key]['center']==1){
			var marker = new BMap.Marker(point1,{icon: grey0});
		}else if(pointClub[key]['center']==0){
			var marker = new BMap.Marker(point1,{icon: grey1});
	    }
		console.log('draw a point');
		}
		
		map.addOverlay(marker);
	}

 }
 
 var color = ['#777','#FF0000','#00FF00','#0000FF','#FFFF00','#00FFFF','#FF00FF','#A52A2A'];
 
 function getOptions(type)
 {
 var options = {
	onSearchComplete: function(results){
		//if (driving.getStatus() == BMAP_STATUS_SUCCESS){
			var plan = results.getPlan(0);
			var route = plan.getRoute(0);
			var tt=route.getPath();
			var polyline = new BMap.Polyline(tt, {strokeColor:color[type], strokeWeight:2, strokeOpacity:1}); 
			map.addOverlay(polyline);   //增加折线
			console.log('draw a route');
		//}
	}
	};
return options;
 }
 
 function routeClub(){
	routeClub = new Array();
	for(type in color)
	{
		var driving = new BMap.DrivingRoute(map, getOptions(type));
		routeClub.push(driving);
	}
	return routeClub;
 }
 
function drawRoute(data,pointindex,lineindex,driving,type)
 {
	var pointClub = data[pointindex];
	var lineClub = data[lineindex];
	for(key in lineClub){ 
		if(type == 0){
		  point = getLineData(key, lineClub, pointClub);
		  driving.search(point[0], point[1]);
		}else if(lineClub[key]['section'] == type){
		  point = getLineData(key, lineClub, pointClub);
		  driving.search(point[0], point[1]);	
		}
	}

 }
 function getLineData(key, lineClub, pointClub)
 {
	var point1=new BMap.Point(113.14,23.08);
	var point2=new BMap.Point(113.14,23.08);
	var keygen1 = lineClub[key]['start'];
	point1.lng=pointClub[keygen1-1]['lng'];
	point1.lat=pointClub[keygen1-1]['lat'];
	var keygen2 = lineClub[key]['end'];
	point2.lng=pointClub[keygen2-1]['lng'];
	point2.lat=pointClub[keygen2-1]['lat'];
	return [point1,point2];
 }
 var opts = {
  width : 200,     // 信息窗口宽度
  height: 50,     // 信息窗口高度
  title : "五年充电容量变化:" , // 信息窗口标题
  enableMessage:true,//设置允许信息窗发送短息
};
 function drawSection(data,driving,type,method)
 {
	 addNode = data[2];
	 addLine = data[3];
	 addInfo = data[4];
	 Icon = new Array();
	 Mcon = new Array();//两个图标的数组
	 var point=new BMap.Point(113.14,23.08);
	 for(i=0;i<8;i++)
	{
		var iac = new BMap.Icon("./resource/n"+ String(i)+".png", new BMap.Size(10, 10), {});
		Icon.push(iac);
		var mac = new BMap.Icon("./resource/m"+ String(i)+".png", new BMap.Size(15, 15), {});
		Mcon.push(mac);
	}
	var grey= new BMap.Icon("./resource/g1.png", new BMap.Size(10, 10), {});
	if(method == 1){
	 for(key in addNode){
		 if(addNode[key][4] == type&&addNode[key][0]>0){
			point.lng=addNode[key][2];
			point.lat=addNode[key][3];
			 var marker = new BMap.Marker(point,{icon: Icon[addNode[key][0]]});
			 map.addOverlay(marker);
		 }
	 }
	 for(key in addLine){
		 if(addLine[key][4] == type&&addNode[key][0]>0){
			pointx = getSectionLine(key, addNode, addLine);
			driving[addLine[key][0]].search(pointx[0], pointx[1]);	
		 }
	 }
	}else if(method == 2){
		for(key in addNode){
		 if(addNode[key][4] == type){
			point.lng=addNode[key][2];
			point.lat=addNode[key][3];
			var marker = new BMap.Marker(point,{icon: grey});
			if(addNode[key][0]<1){
			var mess = addNode[key][5];
			}else{
			var mess = '0';
			}
			for (var i = 1;i<=5;i++){
				var meat = addNode[key][i+5];
				if(addNode[key][0]>0&&i==addNode[key][0]){
					meat = addNode[key][5];
				}
				mess += '+'+meat;
				if(meat!=0){
					marker = new BMap.Marker(point,{icon: Mcon[i]});	
				}
			}
			map.addOverlay(marker);
			addClickHandler(mess,marker);//这个函数是真的厉害
		 }
		}
		for(key in addLine){
		 if(addLine[key][4] == type&&addNode[key][0]>0){
			pointx = getSectionLine(key, addNode, addLine);
			driving[0].search(pointx[0], pointx[1]);	
		 }
		}
	}else{
		setTable(getTableData(data,type));
		$( "#dialog" ).dialog( "open" );
		
		
	}
 }
 
 function getSectionLine(key,addNode,addLine)
 {
	var point1=new BMap.Point(113.14,23.08);
	var point2=new BMap.Point(113.14,23.08);
	var keygen1 = addLine[key][2];
	point1.lng=addNode[keygen1-1][2];
	point1.lat=addNode[keygen1-1][3];
	var keygen2 = addLine[key][3];
	point2.lng=addNode[keygen2-1][2];
	point2.lat=addNode[keygen2-1][3];
	return [point1,point2];
 }
 
 function getTimeLine(key,addNode,addEqu)
 {
	var point1=new BMap.Point(113.14,23.08);
	var point2=new BMap.Point(113.14,23.08);
	point1.lng=addEqu[key][1];
	point1.lat=addEqu[key][2];
	var keygen = addEqu[key][4];
	point2.lng=addNode[keygen-1][2];
	point2.lat=addNode[keygen-1][3];
	return [point1,point2];
 }
 function drawTime(data,type)
 {
	 addEqu = data[5];
	 addNode = data[2];
	 Icon = new Array();
	 var point=new BMap.Point(113.14,23.08);
	 var station = new BMap.Icon("./resource/station.png", new BMap.Size(40, 40), {});
	 for(key in addEqu){
		 if(addEqu[key][0]!=0&&addEqu[key][3]==type){
			point.lng=addEqu[key][1];
			point.lat=addEqu[key][2];
			var marker = new BMap.Marker(point,{icon: station});
			var mess = addEqu[key][0]+"桩";
			var label = new BMap.Label(mess,{offset:new BMap.Size(0,-20)});
			map.addOverlay(marker);
			marker.setLabel(label);
			pointx = getTimeLine(key, addNode, addEqu);
			driving[type].search(pointx[0], pointx[1]);	
		}
	 } 
 }
 function addClickHandler(content,marker){
		marker.addEventListener("click",function(e){
			openInfo(content,e)}
		);
}

function openInfo(content,e){
	var p = e.target;
	var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
	var infoWindow = new BMap.InfoWindow(content,opts);  // 创建信息窗口对象 
	map.openInfoWindow(infoWindow,point); //开启信息窗口
}

function getTableData(data,type){
	var tableData = [];
	for(var key in data[4]){
		if(data[4][key][9]==type){
			tableData.push(data[4][key]);
		}
	}
	return tableData;
}

function setTable(data){
	$('#myTable').dataTable( {
		"dom": '<"top">t<"bottom"><"clear"iflp>',
        "data": data,
		"autoWidth": false,
		"scrollX": false,
		 "info": false,
		 "paging": false,
		 "jQueryUI": true,
		 "scrollY": 200,
         "scrollCollapse": true,
		 "hover":true,
		 "destroy": true,
		 "searching": false,
        "columns": [
            { "title": "规划年","width":"100px" },
            { "title": "编号" ,"width":"100px"},
            { "title": "连接节点" ,"width":"100px"},
			{ "title": "造价/W" ,"width":"100px"},
			{ "title": "电阻/Ω" ,"width":"100px"},
			{ "title": "电抗/H" ,"width":"100px"},
			{ "title": "电容/F" ,"width":"100px"},
			{ "title": "长度/km" ,"width":"100px"},
			{ "title": "电流上限/k" ,"width":"100px"}
        ]
    } );
	$("#myTable tr").hover(function(){
    $(this).css("background-color","#81C0C0");
    },function(){
    $(this).css("background-color","white");
	});
}