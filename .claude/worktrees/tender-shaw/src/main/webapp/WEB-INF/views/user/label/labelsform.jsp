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
						<button id="btnLabelAdd" type="button" class="btn btn-warning mt-n1" data-bs-toggle="modal" data-bs-target="#labelAddModal"><i class="fas fa-plus"></i> 등록</button>
					</div>
					
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><b><i class="fas fa-list"></i> 라벨목록</b></h1>
					</div>
					
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="labelNm" class="col-form-label col-sm-3 text-sm-end"><b>라벨명</b></label>
												<div class="col-sm-8">
													<input type="text" id="labelNm" class="form-control" autocomplete="off">
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					
					<div class="card" >
						<div class="card-header">
							<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 라벨 목록</h5>
						</div>
						<div class="card-body">
							<table id="LabelTable" class="table table-striped" style="width:100%">
								<thead>
									<tr>
										<th>No</th>
										<th>수정</th>
										<th>삭제</th>
										<th>라벨명</th>
										<th>생성일자</th>
										<th>수정일자</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
					
				</div>
			</main>

			<%@ include file="/WEB-INF/views/user/include/footer.jsp"%>
		</div>
		
		
	</div>

<div class="modal fade" id="labelAddModal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-sm" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 라벨 추가</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body m-3">
				<div class="card">
					<form id ="labelAddform">
						<div class="mb-3">
							<label for="addLabelNm" class="form-label"><b>라벨명</b></label>
							<input type="text" id="addLabelNm" class="form-control is-valid" required autocomplete="off">
						</div>
					</form>
				</div>
				
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				<button type="button" id="btnLabelAddModal" class="btn btn-primary">저장</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="labelUpdateModal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-sm" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 라벨 수정</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body m-3">
				<div class="card">
					<form id ="labelUpdateform">
						<div class="mb-3">
							<label for="updateLabelNm" class="form-label"><b>라벨명</b></label>
							<input type="text" id="updateLabelNm" class="form-control" autocomplete="off">
							<input type="text" id="updateLabelId" class="form-control" hidden>
						</div>
					</form>
				</div>
				
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				<button type="button" id="btnLabelUpdateModal" class="btn btn-primary">저장</button>
			</div>
		</div>
	</div>
</div>
<%@ include file="/WEB-INF/views/user/include/script.jsp" %>

<script>
let dtLabels;
let gLabelId;

$(function() {
	fnSetMenuSelection();
	fnSetLabels();
	fnSetEvent();
})

function fnSetMenuSelection() {
	gfnSelectMenu("labelManage", "labelSide", "labels");
}

function fnSetEvent() {
	$("#btnSearch").off("click").on("click", function (e) {
		e.preventDefault();
		fnReselGrid();
	});
	
	$("#labelNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnReselGrid();
		}
	});
	
	$("#btnLabelAddModal").off("click").on("click", function (e) {
		e.preventDefault();
		fnLabelAdd();
	});
	
	$("#addLabelNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnLabelAdd();
		}
	});
	
	$("#btnLabelUpdateModal").off("click").on("click", function (e) {
		e.preventDefault();
		fnLabelUpdate();
	});
	
	$("#updateLabelNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnLabelUpdate();
		}
	});
	
}

//라벨목록 조회
function fnSetLabels(label) {
	dtLabels = $("#LabelTable").DataTable({
		ajax: {
			url : "/rest/user/labels/me",
            type : "POST",
			dataSrc : "data",
			data : function (d) {
				d.labelNm = $("#labelNm").val();
		    },
		    error : function (xhr, error, code) {
		    	gfnFailAlert(gCmmnLabelNm + gCmmnEM_ServiceError, gDelay_Long);
			}	
		},
       	columns: [
       		{
				data : 'labelId',
				className: 'text-center',
				width : "30px",
				render: function (data, type, row, meta) {
			        return meta.row + meta.settings._iDisplayStart + 1;
			    }
			},
       		{
   				data: null,
   				className: 'text-center',
   				width : "80px",
   				render: function(data) {
   					gLabelNm = data.labelNm;
   					return '<button class="btn btn-info btn-sm" type="button" data-bs-toggle="modal" data-bs-target="#labelUpdateModal" onclick="fnUpdateLabelModal(' + data.labelId + ',\'' + data.labelNm + '\')"><i class="fas fa-pencil"></i> 수정</button>';
   				}
   			},
   			{
   				data: 'labelId',
   				className: 'text-center',
   				width : "80px",
   				render: function(data) {
   					return '<button class="btn btn-danger btn-sm" type="button" onclick="fnDeleteLabelChk(' + data + ')"><i class="fas fa-trash"></i> 삭제</button>';
   				}
   			},
       		{
       			data: 'labelNm',
       			className: 'text-left'
       		},
       		{
   				data: 'createDt',
   				width : "140px",
   				render: function(data) {
   					if(data == null || data == '') return "";
   					else return gfnYmdFormat(gfnNoFormatDate(data), "-");
   				}
   			},
       		{
   				data: 'updateDt',
   				width : "140px",
   				render: function(data) {
   					if(data == null || data == '') return "";
   					else return gfnYmdFormat(gfnNoFormatDate(data), "-");
   				}
   			}
       	],
       	processing: true,
		serverSide: true,
		ordering : false,
       	destroy: true,
       	responsive: true,
       	info: true,
		select: false,
		searching: false,
		scrollY: '365',
		scrollCollapse : false,
		paging : true,
		lengthChange : true,
		lengthMenu : [10, 50, 100, 500],
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		},
		initComplete: function () {
			gfnSuccessAlert(gCmmnLabelNm + gCmmnSM_List, gDelay_Short);
		}
 	});
}

//라벨목록 재조회
function fnReselGrid() {
	dtLabels.ajax.reload(function (json) {
		if (json.resultCode === "SUCCESS") {
			gfnSuccessAlert(gCmmnLabelNm + gCmmnSM_List, gDelay_Short);
		}
		else {
			gfnFailAlert(gCmmnLabelNm + gCmmnEM_ServiceError, gDelay_Long);
		}
	});
}

//라벨 추가
function fnLabelAdd() {
	gfnShowLoadingBar();
	let apiUrl = '/rest/user/labels';
	let params = new Object();
	params.labelNm = $("#addLabelNm").val();
	$.ajax({
        url: apiUrl,
        data: params,
        type: 'POST',
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
	}).done(function(data) {
		gfnSuccessAlert(gCmmnLabelNm + gCmmnSM_Insert, gDelay_Short);
		$('#labelAddModal').modal('hide');
		fnReselGrid();
	}).fail(function(request, status, error) {
		gfnFailAlert(gCmmnLabelNm + gCmmnEM_ServiceError, gDelay_Long);
	}).always(function(msg) {
		gfnHideLoadingBar();
		$("#addLabelNm").val("");
	});
	
}

//라벨 수정
function fnLabelUpdate() {
	gfnShowLoadingBar();
	let labelId = $("#updateLabelId").val();
	let labelNm = $("#updateLabelNm").val();
	
	let apiUrl = '/rest/user/labels/' + labelId;
	let params = new Object();
	params.labelNm = labelNm;
	$.ajax({
        url: apiUrl,
        data: params,
        type: 'PATCH',
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
	}).done(function(data) {
		gfnSuccessAlert(gCmmnLabelNm + gCmmnSM_Update, gDelay_Short);
		$('#labelUpdateModal').modal('hide');
		fnReselGrid();
	}).fail(function(request, status, error) {
		gfnFailAlert(gCmmnLabelNm + gCmmnEM_ServiceError, gDelay_Long);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

//라벨수정 버튼 클릭시 modal Set
function fnUpdateLabelModal(labelId, labelNm) {
	$("#updateLabelId").val(labelId);
	$("#updateLabelNm").val(labelNm);
}

//라벨 삭제 Dialog
function fnDeleteLabelChk(labelId) {
	glabelId = labelId;
	let msg = "해당 라벨을 삭제하시겠습니까?";
	let callback = fnDeleteLabel;
	gfnInitWrnCfmMdlDialog(msg, callback);
}

//라벨 삭제
function fnDeleteLabel() {
	gfnShowLoadingBar();
	let apiUrl = '/rest/user/labels/' + glabelId;
	
	$.ajax({
        url: apiUrl,
        type: 'delete',
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
	}).done(function(data) {
		gfnSuccessAlert(gCmmnLabelNm + gCmmnSM_Delete, gDelay_Short);
		fnReselGrid();
	}).fail(function(request, status, error) {
		gfnFailAlert(gCmmnLabelNm + gCmmnEM_ServiceError, gDelay_Long);
	}).always(function(msg) {
		gfnHideLoadingBar();
	});
}

</script>
</body>

</html>