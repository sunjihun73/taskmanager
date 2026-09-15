<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en">

<%@ include file="/WEB-INF/views/admin/include/meta.jsp"%>
<!--
  HOW TO USE: 
  data-theme: default (default), dark, light, colored
  data-layout: fluid (default), boxed
  data-sidebar-position: left (default), right
  data-sidebar-layout: default (default), compact
-->

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
	<div class="wrapper">
		<%@ include file="/WEB-INF/views/admin/include/sidebar.jsp"%>

		<div class="main">
			<%@ include file="/WEB-INF/views/admin/include/header.jsp"%>

			<main class="content">
				<div class="container-fluid p-0">

					<div style="float:right;">
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><i class="fas fa-sitemap"></i> <b>부서 관리</b></h1>
					</div>
					
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-3">
											<div class="row">
												<label for="empCompanyCd" class="col-form-label col-sm-3 text-sm-end"><b>회사</b></label>
												<div class="col-sm-8">
													<select id="empCompanyCd" class="form-select mb-2" onchange="fnChangeCompany()">
													</select>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					
					<div class="row">
						<div class="col-12 col-xl-4">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 부서 목록</h5>
								</div>
								<div class="card-body">
									<div class="input-group">
										<input type="text" id="deptDeptNm" class="form-control" placeholder="부서명">
										<button class="btn btn-secondary" id="btnDeptNmSearch"><i class="fas fa-search"></i></button> 
									</div>
									<div id="treeDeptList" style="height:440px;overflow:auto;"></div>
								</div>
							</div>
						</div>
						<div class="col-12 col-xl-8">
							<div class="card" style="height:575px;">
								<div class="card-header">
									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 부서 상세</h5>
								</div>
								<div class="card-body">
									<form id ="deptform">
										<div class="mb-4 row">
											<label for="parentDeptNm" class="col-form-label col-sm-2 text-sm-end"><b>상위부서</b></label>
											<div class="col-sm-8">
												<input type="text" id="parentDeptNm" class="form-control" disabled readonly>
											</div>
										</div>
										<div class="mb-4 row">
											<label for="deptNm" class="col-form-label col-sm-2 text-sm-end"><b>부서명</b></label>
											<div class="col-sm-8">
												<input type="text" id="deptNm" class="form-control is-valid" disabled readonly>
											</div>
										</div>
										<div class="mb-4 row">
											<label for="deptCd" class="col-form-label col-sm-2 text-sm-end"><b>부서코드</b></label>
											<div class="col-sm-8">
												<input type="text" id="deptCd" class="form-control" disabled readonly>
											</div>
										</div>
										<div class="mb-4 row">
											<label for="deptOrd" class="col-form-label col-sm-2 text-sm-end"><b>부서순서</b></label>
											<div class="col-sm-4">
												<input type="text" id="deptOrd" class="form-control" disabled readonly>
											</div>
										</div>
										<div class="mb-4 row">
											<label for="deptUseYn" class="col-form-label col-sm-2 text-sm-end"><b>사용여부</b></label>
											<div class="col-sm-4">
												<select id="deptUseYn" class="form-select" disabled>
													<option selected value="">-선택-</option>
													<option value="Y">Y</option>
													<option value="N">N</option>
												</select>
											</div>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</main>

			<%@ include file="/WEB-INF/views/admin/include/footer.jsp"%>
		</div>

	</div>

<%@ include file="/WEB-INF/views/admin/include/script.jsp" %>

<script>
let dtEmpList;
let gDeptCd = "";

$(function() {
	fnSetMenuSelection();
	fnSetCompany();
	fnSetEvent();
})

function fnSetMenuSelection() {
	gfnSelectMenu("deptmngform", "", "");
}

function fnSetEvent() {
	$("#deptDeptNm").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			let searchString = $("#deptDeptNm").val();
			$('#treeDeptList').jstree(true).search(searchString);
		}
	});
	$("#btnDeptNmSearch").off("click").on("click", function (e) {
		e.preventDefault();
		let searchString = $("#deptDeptNm").val();
		$('#treeDeptList').jstree(true).search(searchString);
	});
	
}

//회사목록 SelectBox 조회
function fnSetCompany() {
	let apiUrl = '/rest/admin/companies';
	$.ajax({
	    url: apiUrl,
	    type: 'get',
	    beforeSend : function(xmlHttpRequest) {
	    	xmlHttpRequest.setRequestHeader("AJAX", "true");
	    }
	}).done(function(data) {
		$.each(data, function(idx, item){
			let option = $("<option value=" + item.companyCd + ">" + item.companyNm + "</option>");
	    	$('#empCompanyCd').append(option);
	    });
	}).always(function(msg) {
		fnInitTree();
	});
}

//부서상세 데이터 Set
function fnSetData(deptCd) {
	let apiUrl = '/rest/admin/depts/' + deptCd;
	let params = new Object();
	params.companyCd = $("#empCompanyCd").val();
	
	$.ajax({
        url: apiUrl,
        type: 'get',
        data: params,
        beforeSend : function(xmlHttpRequest) {
        	xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
     }).done(function(data) {
         $('#deptNm').val(gfnUnescapeHTML(data.deptNm));
         $('#deptCd').val(data.deptCd);
         $('#parentDeptNm').val(gfnUnescapeHTML(data.parentDeptNm));
         $('#deptOrd').val(data.deptOrd);
         $('#deptUseYn').val(data.deptUseYn);
	});
}

//부서트리 생성
function fnInitTree() {
	let apiUrl = "/rest/admin/depts/all";
	let params = new Object();
	params.companyCd = $("#empCompanyCd").val();
	
	let deptList = new Array();
 	$.ajax({
		type:'get',
		url:apiUrl,
		data: params,
		dataType:'json',
		success: function(data) {
	        $.each(data, function(idx, item){
	        	if(item.parentDeptCd == '0') deptList[idx] = {id:item.deptCd, parent:'#', text:item.deptNm, icon:'/adminkit/common/common/images/company.png'};
	        	else deptList[idx] = {id:item.deptCd, parent:item.parentDeptCd, text:item.deptNm};
	        });
	        $('#treeDeptList').jstree({
	            'core': {
	                'data': deptList
	            },
	            'types': {
	                'default': {
	                	'icon': '/adminkit/common/common/images/dept.png'
	                }
	            },
	            'plugins' : ["search", "types"]
	        })
	        // 노드 선택시 발생하는 이벤트
	        .bind('select_node.jstree', function(event, data){
	        	let deptCd = data.instance.get_node(data.selected).id;
	        	fnSetData(deptCd);
	        })
	        gfnSuccessAlert(gCmmnDeptNm + gCmmnSM_List, 2000);
		},
		error:function (data) {
			gfnFailAlert(gCmmnUsrAdmNm + gCmmnEM_ServiceError, 5000);
		}
	});
}

//트리 재조회
function fnReselTree() {
	let apiUrl = "/rest/admin/depts/all";
	let params = new Object();
	params.companyCd = $("#empCompanyCd").val();
	let deptList = new Array();
 	$.ajax({
		type:'get',
		url:apiUrl,
		data: params,
		dataType:'json',
		success: function(data) {
			$.each(data, function(idx, item){
	        	if(item.parentDeptCd == '0') deptList[idx] = {id:item.deptCd, parent:'#', text:item.deptNm, icon:'common/common/images/company.png'};
	        	else deptList[idx] = {id:item.deptCd, parent:item.parentDeptCd, text:item.deptNm};
	        });
	  		$('#treeDeptList').jstree(true).settings.core.data = deptList;
	  		$('#treeDeptList').jstree(true).refresh();
		}
	});
}

//회사 select box 변경
function fnChangeCompany() {
	fnResetDeptSearch();
	fnResetDeptDetail();
	fnReselTree();
}

//부서트리 검색 초기화
function fnResetDeptSearch() {
	gDeptCd = '';
	$("#deptDeptNm").val("");
	$("#treeDeptList").jstree("deselect_all");
	$("#treeDeptList").jstree(true).clear_search()
}

//부서상세 초기화
function fnResetDeptDetail() {
	$("#parentDeptNm").val("");
	$("#deptNm").val("");
	$("#deptCd").val("");
	$("#deptOrd").val("");
	$("#deptUseYn").val("");
}

</script>

</body>

</html>