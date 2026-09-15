<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en">

<%@ include file="/WEB-INF/views/user/include/meta.jsp"%>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
	<div class="wrapper">
		<%@ include file="/WEB-INF/views/user/include/sidebar.jsp"%>

		<div class="main">
			<%@ include file="/WEB-INF/views/user/include/header.jsp"%>

			<main class="content">
				<div class="container-fluid p-0">

					<div style="float:right;">
						<button class="btn btn-info mt-n1" id="btnAddProject"><i class="fas fa-save"></i> 저장</button>
						<button class="btn btn-warning mt-n1" id="btnGoProjectList"><i class="fas fa-list"></i> 목록</button>
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><i class="align-middle" data-feather="edit"></i> <b>프로젝트 등록</b></h1>
					</div>

					<div class="row">
						<div class="col-md-12">
							<div class="card">
<%--								<div class="card-header">--%>
<%--									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 태스크 등록</h5>--%>
<%--								</div>--%>
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-12">
											<form id ="projectform">
												<div class="mb-3 row">
													<label for="projectNm" class="col-form-label col-sm-2 text-sm-end"><b>프로젝트명</b></label>
													<div class="col-sm-9">
														<input type="text" id="projectNm" class="form-control is-valid" required autocomplete="off">
													</div>
												</div>

                                                <div class="mb-3 row">
													<label for="projectStateCd" class="col-form-label col-sm-2 text-sm-end"><b>상태</b></label>
													<div class="col-sm-2">
														<select id="projectStateCd" class="form-select is-valid" required>
															<option selected value="">-선택-</option>
                                                            <c:forEach var="item" items="${PROJECT_STATE_CD_LIST}">
                                                                <option value="${item.code}">${item.codeNm}</option>
                                                            </c:forEach>
														</select>
													</div>
												</div>

                                                <div class="mb-3 row">
                                                    <label for="projectDesc" class="col-form-label col-sm-2 text-sm-end"><b>설명</b></label>
                                                    <div class="col-sm-9">
                                                        <textarea id="projectDesc" class="form-control" style="min-height: 17rem;" ></textarea>
                                                    </div>
                                                </div>



												<div class="mb-3 row">
													<label class="col-form-label col-sm-2 text-sm-end"><b>소유자</b></label>
													<div id ="empAdd" class="col-sm-9">
														<span id="empAddSpan"></span>
														<button id="btnEmpAdd" type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#empAddModal" style="margin-top:4px;"><i class="far fa-fw fa-user"></i> 변경</button>
													</div>
												</div>

                                                <div class="mb-3 row">
                                                    <label class="col-form-label col-sm-2 text-sm-end"><b>참여자</b></label>
                                                    <div id ="shareEmpAdd" class="col-sm-9">
                                                        <span id="shareEmpAddSpan"></span>
                                                        <button id="btnShareEmpAdd" type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#shareEmpAddModal" style="margin-top:4px;"><i class="far fa-fw fa-user"></i> 추가</button>
                                                    </div>
                                                </div>

                                                <div class="mb-3 row">
                                                    <label for="projectStartDt" class="col-form-label col-sm-2 text-sm-end"><b>시작일</b></label>
                                                    <div class="col-sm-2">
                                                        <input id="projectStartDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" autocomplete="off"/>
                                                    </div>
                                                </div>
                                                <div class="mb-3 row">
                                                    <label for="projectEndDt" class="col-form-label col-sm-2 text-sm-end"><b>종료일</b></label>
                                                    <div class="col-sm-2">
                                                        <input id="projectEndDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" autocomplete="off"/>
                                                    </div>
                                                </div>
											</form>
										</div>
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

    <%--소유자 변경을 위한 모달 --%>
    <div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" style=" --bs-modal-width:1100px">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 사용자 검색</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body m-3">
                    <div class="row">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-12 col-xl-4">
                                        <div class="row">
                                            <label for="empCompanyCd_Modal" class="col-form-label col-sm-3 text-sm-end"><b>회사</b></label>
                                            <div class="col-sm-8">
                                                <select id="empCompanyCd_Modal" class="form-select mb-2">
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-xl-4">
                                        <div class="row">
                                            <label for="empEmpNm_Modal" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
                                            <div class="col-sm-8">
                                                <div class="input-group">
                                                    <input type="text" id="empEmpNm_Modal" class="form-control">
                                                    <button class="btn btn-secondary" id="btnEmpNmSearch_Modal"><i class="fas fa-search"></i></button>
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
                                <div class="card-body">
                                    <div class="input-group">
                                        <input type="text" id="empDeptNm_Modal" class="form-control" placeholder="부서명">
                                        <button class="btn btn-secondary" id="btnEmpDeptNmSearch_Modal"><i class="fas fa-search"></i></button>
                                    </div>
                                    <div id="treeDeptList_Modal" style="height:440px;overflow:auto;"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-xl-8">
                            <div class="card">
                                <div class="card-body">
                                    <table id="empAddTable_Modal" class="table table-striped" style="width:100%">
                                        <thead>
                                            <tr>
                                                <th>회사</th>
                                                <th>도메인ID</th>
                                                <th>회사코드</th>
                                                <th>성명</th>
                                                <th>직위</th>
                                                <th>부서</th>
                                                <th>이메일</th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnEmpSelect_Modal" class="btn btn-vimeo">선택</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <%-- 참여자 추가 모달 --%>
    <div class="modal fade" id="shareEmpAddModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" style=" --bs-modal-width:1100px">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 사용자 검색</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body m-3">
                    <div class="row">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-12 col-xl-4">
                                        <div class="row">
                                            <label for="shareEmpCompanyCd_Modal" class="col-form-label col-sm-3 text-sm-end"><b>회사</b></label>
                                            <div class="col-sm-8">
                                                <select id="shareEmpCompanyCd_Modal" class="form-select mb-2">
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-12 col-xl-4">
                                        <div class="row">
                                            <label for="shareEmpNm_Modal" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
                                            <div class="col-sm-8">
                                                <div class="input-group">
                                                    <input type="text" id="shareEmpNm_Modal" class="form-control">
                                                    <button class="btn btn-secondary" id="btnShareEmpNmSearch_Modal"><i class="fas fa-search"></i></button>
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
                                <div class="card-body">
                                    <div class="input-group">
                                        <input type="text" id="shareEmpDeptNm_Modal" class="form-control" placeholder="부서명">
                                        <button class="btn btn-secondary" id="btnShareEmpDeptNmSearch_Modal"><i class="fas fa-search"></i></button>
                                    </div>
                                    <div id="shareEmpTreeDeptList_Modal" style="height:440px;overflow:auto;"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-xl-8">
                            <div class="card">
                                <div class="card-body">
                                    <table id="shareEmpAddTable_Modal" class="table table-striped" style="width:100%">
                                        <thead>
                                        <tr>
                                            <th>회사</th>
                                            <th>도메인ID</th>
                                            <th>회사코드</th>
                                            <th>성명</th>
                                            <th>직위</th>
                                            <th>부서</th>
                                            <th>이메일</th>
                                        </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnShareEmpSelect_Modal" class="btn btn-vimeo">선택</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

<form id="frmHiddenParam">
  <input type="hidden" id="pDomainId" name="pDomainId" value="<c:out value="${DOMAIN_ID}"/>"/>
  <input type="hidden" id="pCompanyCd" name="pCompanyCd" value="<c:out value="${COMPANY_CD}"/>"/>
  <input type="hidden" id="pEmail" name="pEmail" value="<c:out value="${EMAIL}"/>"/>
  <input type="hidden" id="pEmpNm" name="pEmpNm" value="<c:out value="${empNm}"/>"/>
  <input type="hidden" id="pDeptCd" name="pDeptCd" value="<c:out value="${DEPT_CD}"/>"/>
</form>

<%@ include file="/WEB-INF/views/user/include/script.jsp" %>

<script>
let empHeight = 0;
let shareEmpHeight = 0;
let empOwnerArr = new Array();
let shareEmpArr = new Array();
let dtEmpList;
let dtShareEmpList;
let gDeptCd = "";
let referrer = document.referrer; //이전 페이지

$(function() {
	fnSetMenuSelection();
	fnSetEvent();
	fnSetComponent();
})

// **************************** MENU SELECT ***********************************//
function fnSetMenuSelection() {
	gfnSelectMenu("projectManage", "projectSide", "projectaddform");
}
// **************************** MENU SELECT 끝 ********************************//

// **************************** SET Component *********************************//
function fnSetComponent() {
    flatpickr.localize(flatpickr.l10ns.ko);

	flatpickr(".flatpickr-minimum", {
		dateFormat: "Y-m-d"
	});

	flatpickr(".flatpickr-datetime", {
		enableTime: true,
		dateFormat: "Y-m-d H:i",
	});

    // 최초에 로그인 사용자를 프로젝트 오너로 셋팅
    fnSetInitProjectOwnerEmp();

    // ====== 소유자 변경용 사용자 검색 컾포넌트 초기화 ====== //
    fnSetCompany_Modal();
    // ====== 소유자 변경용 사용자 검색 컾포넌트 초기화 끝. ====== //

    // ====== 참여자 추가용 사용자 검색 컾포넌트 초기화 ====== //
    fnSetShareEmpCompany_Modal();
    // ====== 참여자 추가용 사용자 검색 컾포넌트 초기화 끝. ====== //
}
// **************************** SET Component 끝 *****************************//

// **************************** SET Event ***********************************//
function fnSetEvent() {
    // PROJECT 저장
	$("#btnAddProject").off("click").on("click", function (e) {
		e.preventDefault();
        fnAddProject();
	});

    // 목록 이동
	$("#btnGoProjectList").off("click").on("click", function (e) {
		e.preventDefault();
		location.href = "/user/projects/projectsform";
	});

    // Textarea 크기 자동 조정
    $("#projectDesc").on("keydown keyup", function(e) {
        gfnTextAreaResize(this);
    });

    // 소유자 변경용 사용자 검색 팝업 호출
    $("#btnEmpAdd").off("click").on("click", function (e) {
        e.preventDefault();
        setTimeout(fnOpenEmpModal_Modal, 500);
    });

    // 참여자 추가용 사용자 검색 팝업 호출
    $("#btnShareEmpAdd").off("click").on("click", function (e) {
        e.preventDefault();
        setTimeout(fnOpenShareEmpModal_Modal, 500);
    });


    // ============== 소유자 변경용 사용자 검색 팝업 이벤트 처리 ============= //
    $("#empCompanyCd_Modal").change(function (e) {
        e.preventDefault();
        fnChangeCompany_Modal();
    });

	$("#btnEmpSelect_Modal").off("click").on("click", function (e) {
		e.preventDefault();
		fnSetProjectOwnerEmp();
	});
	
	$("#empDeptNm_Modal").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			let searchString = $("#empDeptNm_Modal").val();
			$('#treeDeptList_Modal').jstree(true).search(searchString);
		}
	});

	$("#btnEmpDeptNmSearch_Modal").off("click").on("click", function (e) {
		e.preventDefault();
		let searchString = $("#empDeptNm_Modal").val();
		$('#treeDeptList_Modal').jstree(true).search(searchString);
	});
	
	$("#empEmpNm_Modal").keydown(function(e) {
		if (e.keyCode == 13) {
			e.preventDefault();
			fnResetDeptSearch_Modal();
			fnReselEmpList_Modal();
		}
	});

	$("#btnEmpNmSearch_Modal").off("click").on("click", function (e) {
		e.preventDefault();
		fnResetDeptSearch_Modal();
		fnReselEmpList_Modal();
	});
    // ============== 소유자 변경용 사용자 검색 팝업 이벤트 처리 끝.============== //

    // ============== 참여자 추가용 사용자 검색 팝업 이벤트 처리 ============= //
    $("#shareEmpCompanyCd_Modal").change(function (e) {
        e.preventDefault();
        fnChangeShareEmpCompany_Modal();
    });

    $("#btnShareEmpSelect_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnSetProjectShareEmp_Modal();
    });

    $("#shareEmpDeptNm_Modal").keydown(function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            let searchString = $("#shareEmpDeptNm_Modal").val();
            $('#shareEmpTreeDeptList_Modal').jstree(true).search(searchString);
        }
    });

    $("#btnShareEmpDeptNmSearch_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        let searchString = $("#shareEmpDeptNm_Modal").val();
        $('#shareEmpTreeDeptList_Modal').jstree(true).search(searchString);
    });

    $("#shareEmpNm_Modal").keydown(function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            fnResetShareEmpDeptSearch_Modal();
            fnReselShareEmpList_Modal();
        }
    });

    $("#btnShareEmpNmSearch_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnResetShareEmpDeptSearch_Modal();
        fnReselShareEmpList_Modal();
    });
    // ============== 참여자 추가용 사용자 검색 팝업 이벤트 처리 끝.============== //
}
// **************************** SET Event 끝 ******************************//


// 최초에 세션 로그인 사용자를 소유자 항목에 셋팅
function fnSetInitProjectOwnerEmp() {
    let domainId = $("#pDomainId").val();
    let companyCd = $("#pCompanyCd").val();
    let email = $("#pEmail").val();
    let empNm = $("#pEmpNm").val();
    let buttonStyle = 'vimeo';
    let num = empHeight;
    let htmlData = '';
    htmlData += '<div class="btn-group me-2" id="empAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
    htmlData += '<button id="btnEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ empNm + '</button>';
    htmlData += '<input type="text" id="empAddEmail' + num + '" value="'+ email +'" hidden>';
    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteEmpTask(' + num + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';

    $('#empAddSpan').append(htmlData);

    empOwnerArr.push({
        email: email,
        domainId: domainId,
        companyCd: companyCd
    });

    empHeight += 1;
}


// 사용자검색 팝업에서 선택한 사용자를 소유자 항목에 셋팅
function fnSetProjectOwnerEmp() {
    $('#empAddModal').modal('hide');
    let buttonStyle = 'vimeo';
    let len = $('#empAddTable_Modal').DataTable().rows('.selected').data().length;
    $('#empAddSpan').empty();
    empOwnerArr.length = 0;

    for(let i = 0; i < len; i++) {
        let data = $('#empAddTable_Modal').DataTable().rows('.selected').data()[i];

        if(empOwnerArr.some(v => v.email === data.email)) {
            gfnFailAlert("이미 추가된 참여자가 존재합니다.", 5000);
            continue;
        }

        let num = empHeight + i;
        let htmlData = '';
        htmlData += '<div class="btn-group me-2" id="empAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
        htmlData += '<button id="btnEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ data.empNm + '</button>';
        htmlData += '<input type="text" id="empAddEmail' + num + '" value="'+ data.email +'" hidden>';
        htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteEmpTask(' + num + ')">';
        htmlData += '<i class="fas fa-times"></i>';
        htmlData += '</button>';
        htmlData += '</div>';

        $('#empAddSpan').append(htmlData);

        empOwnerArr.push({
            email: data.email,
            domainId : data.domainId,
            companyCd: data.companyCd
        });
    }

    empHeight += len;
    fnResetEmpAdd_Modal();
}

// Project 등록
function fnAddProject() {
    if (!gfnCheckRequired($("#projectform"))) {
        return;
    }

    // 프로젝트 소유자 이메일 체크
    if (!empOwnerArr || empOwnerArr.length === 0 || !empOwnerArr[0] || !empOwnerArr[0].email) {
        gfnFailAlert("프로젝트 소유자를 지정해주세요.", gDelay_Long);
        return;
    }

    let params = new Object();
    params.projectNm = $("#projectNm").val();
    params.projectStateCd = $("#projectStateCd").val();
    params.projectDesc = $("#projectDesc").val();

    if($("#projectStartDt").val() != '') params.projectStartDt = gfnNoFormatDate($("#projectStartDt").val());
    if($("#projectEndDt").val() != '') params.projectEndDt = gfnNoFormatDate($("#projectEndDt").val());
    if($("#projectStartDt").val() != '' && $("#projectEndDt").val() != '' && $("#projectStartDt").val() > $("#projectEndDt").val()) {
        gfnFailAlert("시작일이 종료일보다 이전이어야 합니다.", 5000);
        return false;
    }

    // 프로젝트 오너 관련 정보
    params.projectOwnerMemberId = empOwnerArr[0].email;
    params.domainId = empOwnerArr[0].domainId;
    params.companyCd = empOwnerArr[0].companyCd;

    // 참여자 정보
    for(let i = 0; i < shareEmpArr.length; i++) {
        params['shareEmpList[' + i +'].email'] = shareEmpArr[i].email;
        params['shareEmpList[' + i +'].companyCd'] = shareEmpArr[i].companyCd;
        params['shareEmpList[' + i +'].projectEmpCd'] = shareEmpArr[i].projectEmpCd;
    }

    gfnShowLoadingBar();
    $.ajax({
        type:'POST',
        url:'/rest/user/projects',
        data: params,
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        if (data.resultCode == "SUCCESS") {
            gfnSuccessAlert(gCmmnProjectNm + gCmmnSM_Insert, 2000);
            location.href = "/user/projects/projectsform";
        }
        else {
            gfnFailAlert(gCmmnProjectNm + gCmmnEM_ServiceError, 5000);
        }
    }).fail(function(request, status, error) {
        gfnFailAlert(gCmmnProjectNm + gCmmnEM_ServiceError, 5000);
    }).always(function(msg) {
        gfnHideLoadingBar();
    });
}

// 소유자 삭제
function fnDeleteEmpTask(num) {
    for(let i = 0; i < empOwnerArr.length; i++) {
        let email = $('#empAddEmail'+num).val();
        if(empOwnerArr[i].email == email) {
            empOwnerArr.splice(i, 1);
        }
    }
    $("#empAddGroup" + num).remove();
}

// **************************** 소유자 변경용 사용자 검색 팝업 처리 ******************************//
// 소유자 변경을 위한 modal Open시 초기 처리
function fnOpenEmpModal_Modal() {
    $("#empCompanyCd_Modal option:eq(0)").prop("selected", true);
    fnResetEmpAdd_Modal();
    fnReselTree_Modal();
    fnLoadEmpList_Modal();
}

// 사용자 검색 팝업의 회사목록 조회
function fnSetCompany_Modal() {
	let apiUrl = '/rest/user/companies';
	$.ajax({
	    url: apiUrl,
	    type: 'get',
	    beforeSend : function(xmlHttpRequest) {
	    	xmlHttpRequest.setRequestHeader("AJAX", "true");
	    }
	}).done(function(data) {
		$.each(data, function(idx, item){
			let option = $("<option value=" + item.companyCd + ">" + item.companyNm + "</option>");
	      	$('#empCompanyCd_Modal').append(option);
	    });
        fnInitTree_Modal();
	});
}

// 사용자 검색 팝업의 사용자목록 재조회
function fnReselEmpList_Modal() {
    dtEmpList.ajax.reload();
}

// 사용자 검색 팝업의 사용자목록 조회
function fnLoadEmpList_Modal() {
	let apiUrl = '/rest/user/employees/all';

	dtEmpList = $("#empAddTable_Modal").DataTable({
		ajax: {
			url : apiUrl,
			dataSrc : "data",
			data : function (d) {
				d.companyCd = $("#empCompanyCd_Modal").val();
				d.deptCd = gDeptCd;
				d.empNm = $("#empEmpNm_Modal").val();
		    }
		},
		columns: [
            // {
            //     data: null,
            //     render: function (data, type, row, meta) {
            //         return meta.settings._iDisplayStart + meta.row + 1;
            //     },
            //     className: 'text-center',
            //     width : "3%",
            //     orderable: false
            // },
           	{data: 'companyNm', visible: false},
           	{data: 'domainId', visible: false},
           	{data: 'companyCd', visible: false},
   			{data: 'empNm', width : "18%"},
   			{data: 'posNm', width : "15%"},
   			{data: 'deptNm', width : "120px"},
   			{data: 'email'},
       	],
       	processing: true,
		serverSide: true,
		ordering : false,
       	destroy: true,
       	responsive: true,
       	info: true,
		searching: false,
		scrollY: 355,
		scrollCollapse : false,
		paging : true,
		lengthChange : true,
		lengthMenu : [10, 50, 100, 500],
		select: {
			style: 'single'
		},
		loadBeforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", "true");
		}
 	});
	gDeptCd = '';
}

// 사용자검색 팝업의 부서트리 생성
function fnInitTree_Modal() {
	let apiUrl = "/rest/user/depts";
	let params = new Object();
	params.companyCd = $("#empCompanyCd_Modal").val();

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
	        $('#treeDeptList_Modal').jstree({
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
	        .bind('load_all.jstree', function(event, data){
	        	$('#treeDeptList_Modal').jstree(true).select_node($("#pDeptCd").val());
        	})
	        // 노드 선택시 발생하는 이벤트
	        .bind('select_node.jstree', function(event, data){
	        	$("#empEmpNm_Modal").val("");
	        	gDeptCd = data.instance.get_node(data.selected).id;
                fnReselEmpList_Modal();
	        });
		},
		error:function (data) {
		}
	});
}

//부서트리 검색 초기화
function fnResetDeptSearch_Modal() {
	gDeptCd = '';
	$("#empDeptNm_Modal").val("");
	$("#treeDeptList_Modal").jstree("deselect_all");
	$("#treeDeptList_Modal").jstree(true).clear_search()
}

//회사 select box 변경
function fnChangeCompany_Modal() {
	fnResetEmpAdd_Modal();
	fnReselTree_Modal();
	fnReselEmpList_Modal();
}

//트리 재조회
function fnReselTree_Modal() {
	let apiUrl = "/rest/user/depts";
	let params = new Object();
	params.companyCd = $("#empCompanyCd_Modal").val();
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
	  		$('#treeDeptList_Modal').jstree(true).settings.core.data = deptList;
	  		$('#treeDeptList_Modal').jstree(true).refresh();
	  		$('#treeDeptList_Modal').bind("refresh.jstree", function(e,d) {
	  			$('#treeDeptList_Modal').jstree(true).select_node($("#pDeptCd").val());
	  		}.bind(this));
		}
	});
}

//사용자팝업 초기화
function fnResetEmpAdd_Modal() {
	$("#empEmpNm_Modal").val("");
	fnResetDeptSearch_Modal();
	$('#empAddTable_Modal').DataTable().rows('.selected').deselect();
}
// **************************** 소유자 변경용 사용자 검색 팝업 처리 끝 ***************************//



// 참여자 삭제
function fnDeleteShareEmpTask(num) {
    for(let i = 0; i < shareEmpArr.length; i++) {
        let email = $('#shareEmpAddEmail'+num).val();
        if(shareEmpArr[i].email == email) {
            shareEmpArr.splice(i, 1);
        }
    }
    $("#shareEmpAddGroup" + num).remove();
}

// **************************** 참여자 추가용 사용자 검색 팝업 처리 ******************************//
//참여자 추가 modal Open시 초기 처리
function fnOpenShareEmpModal_Modal() {
    $("#shareEmpCompanyCd_Modal option:eq(0)").prop("selected", true);
    fnResetShareEmpAdd_Modal();
    fnReselShareEmpTree_Modal();
    fnLoadShareEmpList_Modal();
}

//참여자 추가사용자팝업 초기화
function fnResetShareEmpAdd_Modal() {
    $("#shareEmpNm_Modal").val("");
    fnResetShareEmpDeptSearch_Modal();
    $('#shareEmpAddTable_Modal').DataTable().rows('.selected').deselect();
}

//참여자 추가부서트리 검색 초기화
function fnResetShareEmpDeptSearch_Modal() {
    gDeptCd = '';
    $("#shareEmpDeptNm_Modal").val("");
    $("#shareEmpTreeDeptList_Modal").jstree("deselect_all");
    $("#shareEmpTreeDeptList_Modal").jstree(true).clear_search()
}

// 참여자 추가트리 재조회
function fnReselShareEmpTree_Modal() {
    let apiUrl = "/rest/user/depts";
    let params = new Object();
    params.companyCd = $("#shareEmpCompanyCd_Modal").val();
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
            $('#shareEmpTreeDeptList_Modal').jstree(true).settings.core.data = deptList;
            $('#shareEmpTreeDeptList_Modal').jstree(true).refresh();
            $('#shareEmpTreeDeptList_Modal').bind("refresh.jstree", function(e,d) {
                $('#shareEmpTreeDeptList_Modal').jstree(true).select_node($("#pDeptCd").val());
            }.bind(this));
        }
    });
}

// 참여자 추가사용자검색 팝업의 부서트리 생성
function fnShareEmpInitTree_Modal() {
    let apiUrl = "/rest/user/depts";
    let params = new Object();
    params.companyCd = $("#shareEmpCompanyCd_Modal").val();

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
            $('#shareEmpTreeDeptList_Modal').jstree({
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
                .bind('load_all.jstree', function(event, data){
                    $('#shareEmpTreeDeptList_Modal').jstree(true).select_node($("#pDeptCd").val());
                })
                // 노드 선택시 발생하는 이벤트
                .bind('select_node.jstree', function(event, data){
                    $("#shareEmpNm_Modal").val("");
                    gDeptCd = data.instance.get_node(data.selected).id;
                    fnReselShareEmpList_Modal();
                });
        },
        error:function (data) {
        }
    });
}

// 참여자 추가 사용자 검색 팝업의 회사목록 조회
function fnSetShareEmpCompany_Modal() {
    let apiUrl = '/rest/user/companies';
    $.ajax({
        url: apiUrl,
        type: 'get',
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        $.each(data, function(idx, item){
            let option = $("<option value=" + item.companyCd + ">" + item.companyNm + "</option>");
            $('#shareEmpCompanyCd_Modal').append(option);
        });
        fnShareEmpInitTree_Modal();
    });
}

// 참여자 추가사용자 검색 팝업의 사용자목록 재조회
function fnReselShareEmpList_Modal() {
    dtShareEmpList.ajax.reload();
}

// 참여자 추가사용자 검색 팝업의 사용자목록 조회
function fnLoadShareEmpList_Modal() {
    let apiUrl = '/rest/user/employees';
    dtShareEmpList = $("#shareEmpAddTable_Modal").DataTable({
        ajax: {
            url : apiUrl,
            dataSrc : "data",
            data : function (d) {
                d.companyCd = $("#shareEmpCompanyCd_Modal").val();
                d.deptCd = gDeptCd;
                d.empNm = $("#shareEmpNm_Modal").val();
            }
        },
        columns: [
            {data: 'companyNm', visible: false},
            {data: 'domainId', visible: false},
            {data: 'companyCd', visible: false},
            {data: 'empNm', width : "18%"},
            {data: 'posNm', width : "15%"},
            {data: 'deptNm', width : "120px"},
            {data: 'email'},
        ],
        processing: true,
        serverSide: true,
        ordering : false,
        destroy: true,
        responsive: true,
        info: true,
        searching: false,
        scrollY: 355,
        scrollCollapse : false,
        paging : true,
        lengthChange : true,
        lengthMenu : [10, 50, 100, 500],
        select: {
            style: 'multi'
        },
        loadBeforeSend: function(jqXHR) {
            jqXHR.setRequestHeader("AJAX", "true");
        }
    });
    gDeptCd = '';
}

//참여자 추가 회사 select box 변경
function fnChangeShareEmpCompany_Modal() {
    fnResetShareEmpAdd_Modal();
    fnReselShareEmpTree_Modal();
    fnReselShareEmpList_Modal();
}

//참여자추가 팝업에서 선택한 사용자 화면에 Set
function fnSetProjectShareEmp_Modal() {
    $('#shareEmpAddModal').modal('hide');
    let buttonStyle = 'facebook';
    let len = $('#shareEmpAddTable_Modal').DataTable().rows('.selected').data().length;

    for(let i = 0; i < len; i++) {
        let data = $('#shareEmpAddTable_Modal').DataTable().rows('.selected').data()[i];

        if(shareEmpArr.some(v => v.email === data.email)) {
            gfnFailAlert("이미 추가한 사용자입니다.", gDelay_Long);
            continue;
        }

        let num = shareEmpHeight+i;
        let htmlData = '';
        htmlData += '<div class="btn-group me-2" id="shareEmpAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
        htmlData += '<button id="btnShareEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ data.empNm + '</button>';
        htmlData += '<input type="text" id="shareEmpAddEmail' + num + '" value="'+ data.email +'" hidden>';
        htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteShareEmpTask(' + num + ')">';
        htmlData += '<i class="fas fa-times"></i>';
        htmlData += '</button>';
        htmlData += '</div>';

        $('#shareEmpAddSpan').append(htmlData);
        shareEmpArr.push({
            email: data.email,
            companyCd: data.companyCd,
            projectEmpCd: "CM004CD002",
            empNm: data.empNm
        });
    }

    shareEmpHeight += len;
    fnResetShareEmpAdd_Modal();
}
// **************************** 참여자 추가용 사용자 검색 팝업 처리 끝 ***************************//
</script>

</body>

</html>
