<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en">

<%@ include file="/WEB-INF/views/user/include/meta.jsp"%>
<!--
  HOW TO USE: 
  data-theme: default (default), dark, light, colored
  data-layout: fluid (default), boxed
  data-sidebar-position: left (default), right
  data-sidebar-layout: default (default), compact
-->

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
	<div class="wrapper">
		<%@ include file="/WEB-INF/views/user/include/sidebar.jsp"%>

		<div class="main">
			<%@ include file="/WEB-INF/views/user/include/header.jsp"%>

			<main class="content">
				<div class="container-fluid p-0">

					<div style="float:right;">
						<button id="btnSearch" class="btn btn-primary mt-n1"><i class="fas fa-search"></i> 조회</button>
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><i class="align-middle" data-feather="edit"></i> <b>태스크 통계</b></h1>
					</div>
					
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskStartDt" class="col-form-label col-sm-3 text-sm-end"><b>시작일</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input id="taskStartDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" />
														<button id="btnClearTaskStartDt" class="btn btn-secondary" type="button"><i class="fas fa-times"></i></button>
													</div>
												</div>  
											</div>
										</div>
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="taskEndDt" class="col-form-label col-sm-3 text-sm-end"><b>종료일</b></label>
												<div class="col-sm-8">
													<div class="input-group">
														<input id="taskEndDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" />
														<button id="btnClearTaskEndDt" class="btn btn-secondary" type="button"><i class="fas fa-times"></i></button>
													</div>
												</div>
											</div>
										</div>
										
									</div>
									
								</div>
							</div>
						</div>
					</div>

					<div class="row">

						<div class="col-12 col-lg-4">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title">상태별 통계</h5>
								</div>
								<div class="card-body text-center" style="height: 405px;">
									<div class="chart w-100">
										<div id="apexcharts-pie" style="max-width: 440px;margin:auto;"></div>
									</div>
								</div>
							</div>
						</div>
						
						<div class="col-12 col-lg-8">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title">역할별 통계</h5>
								</div>
								<div class="card-body">
									<div class="chart w-100">
										<div id="apexcharts-bar"></div>
									</div>
								</div>
							</div>
						</div>

						
					</div>

				</div>
			</main>

			<%@ include file="/WEB-INF/views/user/include/footer.jsp"%>
		</div>

	</div>

<%@ include file="/WEB-INF/views/user/include/script.jsp" %>
<script>
let fpTaskStartDt;
let fpTaskEndDt;
let pieChart;
let barChart;

$(function() {
	fnSetMenuSelection();
	fnSetEvent();
	fnSetComponent();
})

function fnSetMenuSelection() {
	gfnSelectMenu("taskManage", "taskSide", "statisticsform");
}

function fnSetComponent() {
	// Flatpickr
	fpTaskStartDt = flatpickr("#taskStartDt", {
		dateFormat: "Y-m-d"
	});

	fpTaskEndDt = flatpickr("#taskEndDt", {
		dateFormat: "Y-m-d"
	});
	
	fpTaskStartDt.setDate(fnGetCurYM() + "-01");
	
	fnDrawPieChart();
	fnDrawBarChart();
}

function fnSetEvent() {
	
	$("#btnSearch").off("click").on("click", function (e) {
		e.preventDefault();
		fnUpdatePieChart();
		fnUpdateBarChart();
	});
	
	$("#btnClearTaskStartDt").off("click").on("click", function (e) {
		e.preventDefault();
		fpTaskStartDt.clear();
	});

	$("#btnClearTaskEndDt").off("click").on("click", function (e) {
		e.preventDefault();
		fpTaskEndDt.clear();
	});
	
}

function fnDrawPieChart() {
	let taskcnt = [0,0,0,0];
	let apiUrl = '/rest/user/tasks/taskcnt';
	let params = new Object();
	params.taskStartDt = gfnNoFormatDate(fpTaskStartDt.selectedDates); 
	params.taskEndDt = gfnNoFormatDate(fpTaskEndDt.selectedDates); 
	
	$.ajax({
	    url: apiUrl,
	    type: 'get',
	    data: params,
	    beforeSend : function(xmlHttpRequest) {
	    	xmlHttpRequest.setRequestHeader("AJAX", "true");
	    }
	}).done(function(data) {
		$.each(data, function(idx, item){
			taskcnt[getTaskCntByEmpNum(item.taskStateCd)] = item.count;
	    });
		
		// Pie chart
		var options = {
			chart: {
				height: 350,
				type: "donut",
			},
			dataLabels: {
				enabled: false
			},
			series: taskcnt,
			labels: ["할일", "진행", "보류", "완료"],
			colors: [window.theme.warning, window.theme.primary, "#6C757D", window.theme.success]
		};
		pieChart = new ApexCharts(
			document.querySelector("#apexcharts-pie"),
			options
		);
		pieChart.render();
	});
	
}

//Pie Chart 재조회
function fnUpdatePieChart() {
	let taskcnt = [0,0,0,0];
	let apiUrl = '/rest/user/tasks/taskcnt';
	let params = new Object();
	params.taskStartDt = gfnNoFormatDate(fpTaskStartDt.selectedDates); 
	params.taskEndDt = gfnNoFormatDate(fpTaskEndDt.selectedDates); 
	
	$.ajax({
	    url: apiUrl,
	    type: 'get',
	    data: params,
	    beforeSend : function(xmlHttpRequest) {
	    	xmlHttpRequest.setRequestHeader("AJAX", "true");
	    }
	}).done(function(data) {
		$.each(data, function(idx, item){
			taskcnt[getTaskCntByEmpNum(item.taskStateCd)] = item.count;
	    });
		pieChart.updateSeries(taskcnt);
	});
	
}

function fnDrawBarChart() {
	let todoCnt = [0,0,0]; let progressCnt = [0,0,0]; let holdingCnt = [0,0,0]; let completedCnt = [0,0,0];
	let apiUrl = '/rest/user/tasks/taskcnt/emp';
	let params = new Object();
	params.taskStartDt = gfnNoFormatDate(fpTaskStartDt.selectedDates); 
	params.taskEndDt = gfnNoFormatDate(fpTaskEndDt.selectedDates);
	
	$.ajax({
	    url: apiUrl,
	    type: 'get',
	    data: params,
	    beforeSend : function(xmlHttpRequest) {
	    	xmlHttpRequest.setRequestHeader("AJAX", "true");
	    }
	}).done(function(data) {
		$.each(data, function(idx, item){
			if(item.taskStateCd == "CM001CD001") todoCnt[getTaskCntByEmpNum(item.taskEmpCd)] = item.count;
			else if(item.taskStateCd == "CM001CD002") progressCnt[getTaskCntByEmpNum(item.taskEmpCd)] = item.count;
			else if(item.taskStateCd == "CM001CD003") holdingCnt[getTaskCntByEmpNum(item.taskEmpCd)] = item.count;
			else if(item.taskStateCd == "CM001CD004") completedCnt[getTaskCntByEmpNum(item.taskEmpCd)] = item.count;
	    });
		
		// Bar chart
		var options = {
			chart: {
				height: 350,
				type: "bar",
				stacked: true,
			},
			plotOptions: {
				bar: {
					horizontal: true,
				},
			},
			stroke: {
				width: 1,
				colors: ["#fff"]
			},
			series: [{
				name: "할일",
				data: todoCnt
			}, {
				name: "진행",
				data: progressCnt
			}, {
				name: "보류",
				data: holdingCnt
			}, {
				name: "완료",
				data: completedCnt
			}],
			xaxis: {
				categories: ["소유", "할당", "공유"],
				labels: {
					formatter: function(val) {
						return val
					}
				}
			},
			yaxis: {
				title: {
					text: undefined
				},
			},
			tooltip: {
				y: {
					formatter: function(val) {
						return val
					}
				}
			},
			fill: {
				opacity: 1
			},
			legend: {
				position: "top",
				horizontalAlign: "left",
				offsetX: 40
			},
			colors: [window.theme.warning, window.theme.primary, "#6C757D", window.theme.success]
		}
		barChart = new ApexCharts(
			document.querySelector("#apexcharts-bar"),
			options
		);
		barChart.render();
		
	});
	
}

//Bar Chart 재조회
function fnUpdateBarChart() {
	let todoCnt = [0,0,0]; let progressCnt = [0,0,0]; let holdingCnt = [0,0,0]; let completedCnt = [0,0,0];
	let apiUrl = '/rest/user/tasks/taskcnt/emp';
	let params = new Object();
	params.taskStartDt = gfnNoFormatDate(fpTaskStartDt.selectedDates); 
	params.taskEndDt = gfnNoFormatDate(fpTaskEndDt.selectedDates);
	
	$.ajax({
	    url: apiUrl,
	    type: 'get',
	    data: params,
	    beforeSend : function(xmlHttpRequest) {
	    	xmlHttpRequest.setRequestHeader("AJAX", "true");
	    }
	}).done(function(data) {
		$.each(data, function(idx, item){
			if(item.taskStateCd == "CM001CD001") todoCnt[getTaskCntByEmpNum(item.taskEmpCd)] = item.count;
			else if(item.taskStateCd == "CM001CD002") progressCnt[getTaskCntByEmpNum(item.taskEmpCd)] = item.count;
			else if(item.taskStateCd == "CM001CD003") holdingCnt[getTaskCntByEmpNum(item.taskEmpCd)] = item.count;
			else if(item.taskStateCd == "CM001CD004") completedCnt[getTaskCntByEmpNum(item.taskEmpCd)] = item.count;
	    });
		
		barChart.updateSeries([
			{
				name: "할일",
				data: todoCnt
			}, {
				name: "진행",
				data: progressCnt
			}, {
				name: "보류",
				data: holdingCnt
			}, {
				name: "완료",
				data: completedCnt
			}
		]);
	});
	
}

//TASK_EMP_CD에서 마지막 숫자 추출
function getTaskCntByEmpNum(taskEmpCd) {
	return Number(taskEmpCd.substr(taskEmpCd.length-1, 1))-1;
}

function fnGetCurYM() {
	let rtVal = "";
	let today = new Date();
	let monthOfYear = today.getMonth();
	today.setMonth(monthOfYear - 3);
	
	let year = today.getFullYear(); 
	let month = today.getMonth() + 1; 

	if (Number(month) < 10) {
		month = "0" + month;
	}

	rtVal = year + "-" + month; 
	return rtVal;
}

</script>

</body>

</html>