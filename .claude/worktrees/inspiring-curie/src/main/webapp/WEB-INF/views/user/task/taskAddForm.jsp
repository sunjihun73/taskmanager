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
						<button class="btn btn-primary mt-n1" id="btnSaveTask"><i class="fas fa-save"></i> 저장</button>
						<button class="btn btn-warning mt-n1" id="btnGoList"><i class="fas fa-list"></i> 목록</button>
					</div>
					<div class="mb-3">
						<h1 class="h3 d-inline align-middle"><i class="align-middle" data-feather="edit"></i> <b>에픽 / 태스크 등록</b></h1>
					</div>

					<div class="row">

						<div class="col-md-12">
							<div class="card">
<%--								<div class="card-header">--%>
<%--									<h5 class="card-title" style="font-size:17px;"><i class="fas fa-fw fa-folder"></i> 태스크 등록</h5>--%>
<%--								</div>--%>
								<div class="card-body">
									<div class="row">
										<div class="col-12 col-xl-6">
											<form id ="taskform">
												<div class="mb-3 row">
													<label for="taskTypeCd" class="col-form-label col-sm-2 text-sm-end"><b>유형</b></label>
													<div class="col-sm-4">
														<select id="taskTypeCd" class="form-select is-valid" required>
                                                            <c:forEach var="item" items="${TASK_TYPE_CD_LIST}">
                                                                <option value="${item.code}">${item.codeNm}</option>
                                                            </c:forEach>
														</select>
													</div>
												</div>

                                                <div class="mb-3 row">
													<label for="taskNm" class="col-form-label col-sm-2 text-sm-end"><b>업무명</b></label>
													<div class="col-sm-9">
														<input type="text" id="taskNm" class="form-control is-valid" required autocomplete="off">
													</div>
												</div>

												<div class="mb-3 row">
													<label for="taskStateCd" class="col-form-label col-sm-2 text-sm-end"><b>상태</b></label>
													<div class="col-sm-4">
														<select id="taskStateCd" class="form-select is-valid" required>
															<option selected value="">-선택-</option>
                                                            <c:forEach var="item" items="${TASK_STATE_CD_LIST}">
                                                                <option value="${item.code}">${item.codeNm}</option>
                                                            </c:forEach>
														</select>
													</div>
												</div>
                                                <div class="mb-3 row">
                                                    <label class="col-form-label col-sm-2 text-sm-end"><b>소유자</b></label>
                                                    <div id ="empOwnerAdd" class="col-sm-9">
                                                        <span id="ownerEmpAddSpan"></span>
                                                        <button id="btnOwnerEmpAdd_Modal" type="button" class="btn btn-secondary" onclick="setTimeout(fnOpenOwnerEmp_Modal, 500)" data-bs-toggle="modal" data-bs-target="#ownerEmpAdd_Modal" style="margin-top:4px;"><i class="far fa-fw fa-user"></i> 변경</button>
                                                    </div>
                                                </div>

                                                <div class="mb-3 row">
                                                    <label class="col-form-label col-sm-2 text-sm-end"><b>보고대상자</b></label>
                                                    <div id ="reportObjEmpAdd" class="col-sm-9">
                                                        <span id="reportObjEmpAddSpan"></span>
                                                        <button id="btnReportObjEmpAdd_Modal" type="button" class="btn btn-secondary" onclick="setTimeout(fnOpenReportObjEmp_Modal, 500)" data-bs-toggle="modal" data-bs-target="#reportObjEmpAdd_Modal" style="margin-top:4px;"><i class="far fa-fw fa-user"></i> 변경</button>
                                                    </div>
                                                </div>

												<div class="mb-3 row">
													<label for="taskImportanceCd" class="col-form-label col-sm-2 text-sm-end"><b>중요도</b></label>
													<div class="col-sm-4">
														<select id="taskImportanceCd" class="form-select">
															<option selected value="">-선택-</option>
                                                            <c:forEach var="item" items="${TASK_IMPORTANCE_CD_LIST}">
                                                                <option value="${item.code}">${item.codeNm}</option>
                                                            </c:forEach>
														</select>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskDetail" class="col-form-label col-sm-2 text-sm-end"><b>내용</b></label>
													<div class="col-sm-9">
														<textarea id="taskDetail" class="form-control" style="min-height: 17rem;"></textarea>
													</div>
												</div>
											</form>
										</div>
										
										<div class="col-12 col-xl-6">
											<form>
												<div class="mb-3 row">
													<label for="taskStartDt" class="col-form-label col-sm-2 text-sm-end"><b>시작일</b></label>
													<div class="col-sm-4">
														<input id="taskStartDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" autocomplete="off"/>
													</div>
												</div>
												<div class="mb-3 row">
													<label for="taskEndDt" class="col-form-label col-sm-2 text-sm-end"><b>종료일</b></label>
													<div class="col-sm-4">
														<input id="taskEndDt" type="text" class="form-control flatpickr-minimum" placeholder="Select date" autocomplete="off"/>
													</div>
												</div>
												
												<div class="mb-3 row">
													<label for="taskProgress" class="col-form-label col-sm-2 text-sm-end"><b>진행도</b></label>
													<div class="col-sm-4">
														<div class="input-group">
															<select id="taskProgress" class="form-select">
																<option selected value="0">0</option>
																<option value="10">10</option>
																<option value="20">20</option>
																<option value="30">30</option>
																<option value="40">40</option>
																<option value="50">50</option>
																<option value="60">60</option>
																<option value="70">70</option>
																<option value="80">80</option>
																<option value="90">90</option>
																<option value="100">100</option>
															</select>
															<!-- <input id="taskProgress" type="number" class="form-control" value="0" min="0" max="100" > --> 
															<span class="input-group-text">%</span> 
														</div>
													</div>
												</div>
												<div class="mb-3 row">
													<label class="col-form-label col-sm-2 text-sm-end"><b>체크리스트</b></label>
													<div class="col-sm-9">
														<button class="btn btn-secondary" type="button" id="btnAddCheckList"><i class="far fa-fw fa-list-alt"></i> 추가</button>
													</div>
												</div>
												<div class="row" id="checkList">
												</div>
												
												<div class="mb-3 row">
													<label class="col-form-label col-sm-2 text-sm-end"><b>파일</b></label>
													<div class="col-sm-9">
														<label class="btn btn-secondary" for="input-file"><i class="far fa-fw fa-file"></i> 파일첨부</label>
														<form method="POST" onsubmit="return false;" enctype="multipart/form-data" >
													        <input type="file" id="input-file" onchange="fnUploadFile(this);" multiple hidden/>
													    </form>
													</div>
													
												</div>
												<div class="row" id="fileList">
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

    <%-- 소유자 선택 모달 --%>
    <div class="modal fade" id="ownerEmpAdd_Modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" style=" --bs-modal-width:1100px">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 프로젝트 사용자 검색</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body m-3">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-12 col-xl-4">
                                            <div class="row">
                                                <label for="ownerEmpNm_Modal" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <input type="text" id="ownerEmpNm_Modal" class="form-control">
                                                        <button class="btn btn-secondary" id="btnOwnerEmpNmSearch_Modal"><i class="fas fa-search"></i></button>
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
                        <div class="col-12 col-xl-12">
                            <div class="col-md-12">
                                <div class="card" style="margin-bottom: 0 !important;">
                                    <div class="card-body">
                                        <table id="ownerEmpAddTable_Modal" class="table table-striped" style="width:100%">
                                            <thead>
                                                <tr>
                                                    <th>도메인</th>
                                                    <th>회사</th>
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
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnEmpAssign_Modal" class="btn btn-vimeo">선택</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <%-- 보고 대상자 선택 모달 --%>
    <div class="modal fade" id="reportObjEmpAdd_Modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document" style=" --bs-modal-width:1100px">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title"><i class="fas fa-angle-double-right"></i> 프로젝트 사용자 검색</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body m-3">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-12 col-xl-4">
                                            <div class="row">
                                                <label for="reportObjEmpNm_Modal" class="col-form-label col-sm-3 text-sm-end"><b>성명</b></label>
                                                <div class="col-sm-8">
                                                    <div class="input-group">
                                                        <input type="text" id="reportObjEmpNm_Modal" class="form-control">
                                                        <button class="btn btn-secondary" id="btnReportObjEmpNmSearch_Modal"><i class="fas fa-search"></i></button>
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
                        <div class="col-12 col-xl-12">
                            <div class="col-md-12">
                                <div class="card" style="margin-bottom: 0 !important;">
                                    <div class="card-body">
                                        <table id="reportObjEmpAddTable_Modal" class="table table-striped" style="width:100%">
                                            <thead>
                                            <tr>
                                                <th>도메인</th>
                                                <th>회사</th>
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
                </div>
                <div class="modal-footer">
                    <button type="button" id="btnReportObjEmpAssign_Modal" class="btn btn-vimeo">선택</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <form id="frmHiddenParam">
        <input type="hidden" id="pProjectId" name="pProjectId" value="<c:out value="${PROJECT_ID}"/>"/>
        <input type="hidden" id="pParentTaskId" name="pParentTaskId" value=""/>
        <input type="hidden" id="pEmail" name="pEmail" value="<c:out value="${email}"/>"/>
        <input type="hidden" id="pDeptCd" name="pDeptCd" value="<c:out value="${deptCd}"/>"/>
        <input type="hidden" id="pDomainId" name="pDomainId" value="<c:out value="${DOMAIN_ID}"/>"/>
        <input type="hidden" id="pCompanyCd" name="pCompanyCd" value="<c:out value="${COMPANY_CD}"/>"/>
        <input type="hidden" id="pEmpNm" name="pEmpNm" value="<c:out value="${empNm}"/>"/>
    </form>

<%@ include file="/WEB-INF/views/user/include/script.jsp" %>

<script>
let fileHeight = 0;
let checkHeight = 0;
let labelHeight = 0;
let selFile;
let labelArr = new Array();
let filesArr = new Array();
let dtOwnerEmpGrid;
let dtReportObjEmpGrid;
let gDeptCd = "";
let empOwnerArr = new Array();
let empOwnerHeight = 0;
let reportObjEmpArr = new Array();
let reportObjEmpHeight = 0;
let referrer = document.referrer; //이전 페이지

$(function() {
	fnSetMenuSelection();
	fnSetEvent();
	fnSetComponent();
})

// ************************* 좌측 메뉴 선택 ******************************* //
function fnSetMenuSelection() {
    gfnSelectMenu("projectManage", "projectSide", "projectsform");
}
// ************************* 좌측 메뉴 선택 끝 **************************** //

// ************************* Component 초기화 ******************************* //
function fnSetComponent() {
    flatpickr.localize(flatpickr.l10ns.ko);

	flatpickr(".flatpickr-minimum", {
		dateFormat: "Y-m-d"
	});
	flatpickr(".flatpickr-datetime", {
		enableTime: true,
		dateFormat: "Y-m-d H:i",
	});
	
	let drake = dragula([
		document.querySelector("#checkList")
	]);
	
	drake.on('drop', (el, target, source, sibling) => {
	  // el: 드래그하고 있는 요소
	  // target: el이 드래그 후 놓아진 리스트 요소
	  // sibling: 자리에 놓았을 때, 바로 그 다음 요소
	  // source: 원래 el이 있던 리스트 요소
	});
	
	// fnInitTree();
	selFile = document.querySelector("input[type=file]");

    // 태스크 상태 중에 서브태스크는 삭제
    $("#taskTypeCd option:eq(2)").remove();

	// 최초에 로그인 사용자를 태스크 오너로 셋팅
	fnSetInitTaskOwnerEmp();

	// 최초에 로그인 사용자를 보고자로 셋팅
	fnSetInitReporterEmp();
}
// ************************* Component 초기화 끝 *************************** //

// ************************* Event 초기화  ******************************** //
function fnSetEvent() {
    // 태스크 추가 (저장)
	$("#btnSaveTask").off("click").on("click", function (e) {
		e.preventDefault();
        fnSaveTask();
	});

    // 목록 (프로젝트 상세 화면 (태스크 목록화면) 으로 이동
	$("#btnGoList").off("click").on("click", function (e) {
		e.preventDefault();
        fnGoProjectDetail();
	});

    // 내용 (Textarea) 항목 자동 높이 조절
    $("#taskDetail").on("keydown keyup", function(event) {
        gfnTextAreaResize(this);
    });

	$("#btnAddCheckList").off("click").on("click", function (e) {
		e.preventDefault();
		fnAddCheckList();
	});
	
	$("#taskProgress").on("change", function(){
	    let progress = $("#taskProgress").val();
	    let stateCd = $("#taskStateCd").val();
	    if(stateCd != "CM001CD003" && progress == 100) $("#taskStateCd").val("CM001CD004");
	    else if(stateCd != "CM001CD003" && progress > 0) $("#taskStateCd").val("CM001CD002");
	    else if(stateCd != "CM001CD003" && progress == 0) $("#taskStateCd").val("CM001CD001");
	});

    ///////////////////// 소유자 선택 팝업 이벤트 ///////////////////////
    $("#btnEmpAssign_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnSetTaskOwnerEmp_Modal();
    });

    $("#ownerEmpNm_Modal").keydown(function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            fnReselOwnerEmpGrid_Modal();
        }
    });

    $("#btnOwnerEmpNmSearch_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnReselOwnerEmpGrid_Modal();
    });
    ///////////////////// 소유자 선택 팝업 이벤트 끝 ///////////////////////

    ///////////////////// 보고 대상자 선택 팝업 이벤트 ///////////////////////
    $("#btnReportObjEmpAssign_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnSetTaskReportObjEmp_Modal();
    });

    $("#reportObjEmpNm_Modal").keydown(function(e) {
        if (e.keyCode == 13) {
            e.preventDefault();
            fnReselReportObjEmpGrid_Modal();
        }
    });

    $("#btnReportObjEmpNmSearch_Modal").off("click").on("click", function (e) {
        e.preventDefault();
        fnReselReportObjEmpGrid_Modal();
    });
    ///////////////////// 소유자 선택 팝업 이벤트 끝 ///////////////////////
}
// ************************* Event 초기화 끝 **************************** //

// Task 등록
function fnSaveTask() {
    if (!gfnCheckRequired($("#taskform"))) {
        return;
    }

    if(!empOwnerArr || empOwnerArr.length === 0) {
        gfnFailAlert("소유자를 선택해주세요.", gDelay_Medium);
        $("#btnOwnerEmpAdd_Modal").focus();
        return false;
    }

    let params = new Object();
    params.projectId = $("#pProjectId").val();
    params.taskTypeCd = $("#taskTypeCd").val();
    params.taskOwnerMemberId = empOwnerArr[0].email;    // 소유자 이메일
    params.taskNm = $("#taskNm").val();
    params.taskStateCd = $("#taskStateCd").val();
    params.taskImportanceCd = $("#taskImportanceCd").val();
    params.taskDetail = $("#taskDetail").val();
    if($("#taskStartDt").val() != '') params.taskStartDt = gfnNoFormatDate($("#taskStartDt").val());
    if($("#taskEndDt").val() != '') params.taskEndDt = gfnNoFormatDate($("#taskEndDt").val());
    if($("#taskStartDt").val() != '' && $("#taskEndDt").val() != '' && $("#taskStartDt").val() > $("#taskEndDt").val()) {
        gfnFailAlert("시작일이 종료일보다 이전이어야 합니다.", 5000);
        return false;
    }
    params.taskProgress = $("#taskProgress").val();

    // 보고대상자 추가 - reportObjEmpArr에서 이메일만 추출하여 설정
    if(reportObjEmpArr && reportObjEmpArr.length > 0) {
        params.reportMemberId = reportObjEmpArr[0].email;
    }

    //체크리스트
    let checkLen = $('#checkList').children().length;
    for(let i = 0; i < checkLen; i++) {
        let checkHeight = $('#checkList').children().eq(i).prop("id").substr(8);
        let checkYn = $("#taskCheckYn" + checkHeight).is(":checked");
        if(checkYn) params['checkList[' + i +'].checkYn'] = 'Y';
        else params['checkList[' + i +'].checkYn'] = 'N';
        params['checkList[' + i +'].checkNm'] = $("#taskCheck" + checkHeight).val();
        params['checkList[' + i +'].checkOrd'] = i;
    }

    //파일
    for(let i = 0; i < filesArr.length; i++) {
        params['fileList[' + i +'].fileNm'] = filesArr[i].fileNm;
        params['fileList[' + i +'].fileDispNm'] = filesArr[i].fileDispNm;
    }

    gfnShowLoadingBar();
    $.ajax({
        url:'/rest/user/tasks',
        type:'POST',
        data: params,
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        gfnSuccessAlert(gCmmnTaskNm + gCmmnSM_Insert, gDelay_Short);
        fnGoProjectDetail();
    }).fail(function(request, status, error) {
        gfnFailAlert(gCmmnTaskNm + gCmmnEM_ServiceError, gDelay_Medium);
    }).always(function(msg) {
        gfnHideLoadingBar();
    });
}

//체크리스트 추가
function fnAddCheckList(){
    let checkLen = $('#checkList').children().length;
    if(checkLen+1 > 20) {
        gfnFailAlert("체크리스트는 20개까지만 첨부할 수 있습니다.", 5000);
        return;
    }
    let htmlData = '';
    htmlData += '<div class="row" id="checkRow'+ checkHeight + '">';
    htmlData += '<label id="checkLabel' + checkHeight + '" class="form-label col-sm-2 text-sm-end"></label>';
    htmlData += '<div id="checkDiv' + checkHeight + '" class="col-sm-9">'
    htmlData += '<div class="input-group mb-3">';
    htmlData += '<div class="input-group-text">';
    htmlData += '<input type="checkbox" id="taskCheckYn' + checkHeight + '" ">';
    htmlData += '</div>';
    htmlData += '<input type="text" id="taskCheck' + checkHeight + '" class="form-control" placeholder="To do" onkeypress="fnCheckEnter(event)">';
    htmlData += '<button class="btn btn-secondary" type="button" onclick="fnDeleteCheckList(' + checkHeight + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';
    htmlData += '</div>';
    htmlData += '</div>';
    $('#checkList').append(htmlData);
    $('#taskCheck'+checkHeight).focus();

    checkHeight += 1;
}

//체크리스트 삭제
function fnDeleteCheckList(num) {
    $("#checkRow" + num).remove();
}

//체크리스트에서 엔터누르면 자동 추가
function fnCheckEnter(event) {
    if(event.keyCode == 13){
        fnAddCheckList();
    }
}

//첨부파일 추가
function fnUploadFile(obj){
    var files = obj.files;

    //아무것도 선택 안하면 그냥 return
    if(files.length < 1) {
        return;
    }

    let formData = new FormData();
    for (var i = 0; i < files.length; i++) {
        //파일 추가
        const file = files[i];
        if(validation(file)) {
            formData.append('file', file);
        } else {
            continue;
        }
    }

    if(!formData.get('file')) {
        return;
    }

    gfnShowLoadingBar();
    $.ajax({
        type:'post',
        url:'/rest/files/azure',
        // url:'/rest/files/disk',
        cache : false,
        contentType : false,
        processData : false,
        data : formData,
        beforeSend : function(xmlHttpRequest) {
            xmlHttpRequest.setRequestHeader("AJAX", "true");
        }
    }).done(function(data) {
        $.each(data, function(idx, item){
            filesArr.push(item);
            fnSetFile(fileHeight, item);
        });
        gfnSuccessAlert(gCmmnSM_FileUp, 2000);
    }).fail(function(request, status, error) {
        gfnFailAlert(error, 5000);
    }).always(function(msg) {
        gfnHideLoadingBar();
    });
}

//화면에 파일 추가
function fnSetFile(height, file) {
    let htmlData = '';
    htmlData += '<label id="fileLabel' + height + '" class="form-label col-sm-2 text-sm-end"></label>';
    htmlData += '<div id="fileDiv' + height + '" class="col-sm-9">'
    htmlData += '<div class="input-group mb-3">';
    htmlData += '<input type="text" class="form-control" id="fileNm' + height + '" value="' + file.fileNm + '" hidden>';
    htmlData += '<input type="text" class="form-control" id="fileDispNm' + height + '" value="' + file.fileDispNm + '" disabled>';
    htmlData += '<button class="btn btn-success" type="button" onclick="fnDownloadFile(' + height + ')">';
    htmlData += '<i class="fas fa-download"></i> ';
    htmlData += '</button>';
    htmlData += '<button class="btn btn-secondary" type="button" onclick="fnDeleteFile(' + height + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';
    htmlData += '</div>';
    $('#fileList').append(htmlData);

    fileHeight += 1;
}

//첨부파일 삭제
function fnDeleteFile(num) {
    var dt = new DataTransfer()
    var { files } = selFile;
    for (var i = 0; i < files.length; i++) {
        var file = files[i];
        if (num !== i) dt.items.add(file);
        selFile.files = dt.files;
    }
    for(let i = 0; i < filesArr.length; i++) {
        let fileNm = $('#fileNm'+num).val();
        if(filesArr[i].fileNm == fileNm) {
            filesArr.splice(i, 1);
        }
    }

    $("#fileDiv" + num).remove();
    $("#fileLabel" + num).remove();
}

//첨부파일 검증
function validation(obj){
    const fileTypes =  ['bmp' , 'hwp', 'jpg', 'pdf', 'png', 'xls', 'zip', 'pptx', 'xlsx', 'jpeg', 'doc', 'gif', 'csv', 'tif', 'txt', 'docx'];
    let fileType =  obj.name.split('.').pop().toLowerCase();

    let msg = '';
    if (obj.name.length > 100) {
        msg = "파일명이 100자 이상인 파일은 제외되었습니다.";
        gfnFailAlert(msg, 5000);
        return false;
    } else if (obj.size > (50 * 1024 * 1024)) {
        msg = "최대 파일 용량인 50MB를 초과한 파일은 제외되었습니다.";
        gfnFailAlert(msg, 5000);
        return false;
    } else if (obj.name.lastIndexOf('.') == -1) {
        msg = "확장자가 없는 파일은 제외되었습니다.";
        gfnFailAlert(msg, 5000);
        return false;
    } else if (!fileTypes.includes(fileType)) {
        msg = "첨부가 불가능한 파일은 제외되었습니다.";
        gfnFailAlert(msg, 5000);
        return false;
    } else {
        return true;
    }
}

//파일 다운로드
function fnDownloadFile(num) {
    let fileDispNm = $('#fileDispNm'+num).val();
    let fileNm = $('#fileNm'+num).val();
    if (typeof fileDispNm == "undefiled" || typeof fileNm == "undefined") {
        let msg = "다운로드 할 수 없는 파일입니다.";
        gfnFailAlert(msg, 5000);
    }
    else {
        let downUrl = "/rest/files/azure";
        downUrl = downUrl + "?fileDispNm=" + fileDispNm;
        downUrl = downUrl + "&fileNm=" + fileNm;

        const encFileName = encodeURI(downUrl);
        window.open(encFileName);
    }
}

// 목록 클릭시 이동
function fnGoProjectDetail() {
    let projectId = $("#pProjectId").val();
    let apiUrl = '/user/projects/projectdetailform';
    let params = new Object();
    params.projectId = projectId;
    fnPostMove(apiUrl, params);
}

// 최초에 세션 로그인 사용자를 소유자 항목에 셋팅
function fnSetInitTaskOwnerEmp() {
    let domainId = $("#pDomainId").val();
    let companyCd = $("#pCompanyCd").val();
    let email = $("#pEmail").val();
    let empNm = $("#pEmpNm").val();
    let buttonStyle = 'vimeo';
    let num = empOwnerHeight;
    let htmlData = '';
    htmlData += '<div class="btn-group me-2" id="empOwnerAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
    htmlData += '<button id="btnEmpOwner' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ empNm + '</button>';
    htmlData += '<input type="text" id="empOwnerEmail' + num + '" value="'+ email +'" hidden>';
    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteTaskOwner(' + num + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';

    $('#ownerEmpAddSpan').append(htmlData);

    empOwnerArr.push({
        email: email,
        domainId: domainId,
        companyCd: companyCd
    });

    empOwnerHeight += 1;
}

// 소유자 삭제
function fnDeleteTaskOwner(num) {
    for(let i = 0; i < empOwnerArr.length; i++) {
        let email = $('#empOwnerEmail'+num).val();
        if(empOwnerArr[i].email == email) {
            empOwnerArr.splice(i, 1);
        }
    }
    $("#empOwnerAddGroup" + num).remove();
}

// 최초에 세션 로그인 사용자를 보고자 항목에 셋팅
function fnSetInitReporterEmp() {
    let companyCd = $("#pCompanyCd").val();
    let email = $("#pEmail").val();
    let empNm = $("#pEmpNm").val();
    let buttonStyle = 'facebook';
    let num = reportObjEmpHeight;
    let htmlData = '';
    htmlData += '<div class="btn-group me-2" id="reportObjEmpAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
    htmlData += '<button id="btnReportObjEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ empNm + '</button>';
    htmlData += '<input type="text" id="reportObjEmpAddEmail' + num + '" value="'+ email +'" hidden>';
    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteReportObjEmpTask(' + num + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';

    $('#reportObjEmpAddSpan').append(htmlData);

    reportObjEmpArr.push({
        email: email,
        companyCd: companyCd,
        taskEmpCd: "CM004CD002"
    });

    reportObjEmpHeight += 1;
}

// 보고자 삭제
function fnDeleteReportObjEmpTask(num) {
    for(let i = 0; i < reportObjEmpHeight.length; i++) {
        let email = $('#reportObjEmpAddEmail'+num).val();
        if(reportObjEmpHeight[i].email == email) {
            reportObjEmpHeight.splice(i, 1);
        }
    }
    $("#reportObjEmpAddGroup" + num).remove();
}

// ************************* 소유자 팝업 처리 **************************** //
// 소유자 변경 모달 오픈 버튼 클릭
function fnOpenOwnerEmp_Modal() {
    fnResetOwnerEmpAdd_Modal();
    fnInitOwnerEmpGrid_Modal();
}

// 소유자 변경용 사용자팝업 초기화
function fnResetOwnerEmpAdd_Modal() {
    $("#ownerEmpNm_Modal").val("");
    $('#ownerEmpAddTable_Modal').DataTable().rows('.selected').deselect();
}

//소유자 변경 모달의사용자목록 그리드 생성
function fnInitOwnerEmpGrid_Modal() {
    let projectId = $("#pProjectId").val();
	let apiUrl = '/rest/user/projects/emps/' + projectId;

	dtOwnerEmpGrid = $("#ownerEmpAddTable_Modal").DataTable({
		ajax: {
			url : apiUrl,
            type : "POST",
			dataSrc : "data",
			data : function (d) {
				d.empNm = $("#ownerEmpNm_Modal").val();
		    }
		},
        autoWidth: false,
        columnDefs: [
            // targets: 컬럼 인덱스를 지정한다 (0부터 시작).
            // width: 원하는 너비를 픽셀(px) 또는 백분율(%)로 지정한다.
            { targets: 0, width: "100px" },    // companyNm
            { targets: 1, width: "100px" },    // companyNm
            // { targets: 2, width: "0px" },   // companyCd (hidden)
            { targets: 3, width: "120px" },    // empNm
            { targets: 4, width: "100px" },    // posNm
            { targets: 5, width: "150px" },    // deptNm (기존 width 재사용)
            { targets: 6, width: "200px" }     // email
        ],
		columns: [
           	{data: 'domainId'},
           	{data: 'companyNm'},
           	{data: 'companyCd', visible: false},
   			{data: 'empNm'},
   			{data: 'posNm'},
   			{data: 'deptNm', width : "150px"},
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

//사용자목록 재조회
function fnReselOwnerEmpGrid_Modal() {
	dtOwnerEmpGrid.ajax.reload();
}

// 모달에서 선택한 사용자를 소유자 항목에 셋팅
function fnSetTaskOwnerEmp_Modal() {
    let buttonStyle = 'vimeo';
    let len = $('#ownerEmpAddTable_Modal').DataTable().rows('.selected').data().length;
    if(len === 0) {
        gfnFailAlert("소유자를 선택해주세요.", gDelay_Medium);
        return;
    }

    $('#ownerEmpAddSpan').empty();
    empOwnerArr.length = 0;
    $('#ownerEmpAdd_Modal').modal('hide');

    let data = $('#ownerEmpAddTable_Modal').DataTable().rows('.selected').data()[0];
    let num = empOwnerHeight;
    let htmlData = '';
    htmlData += '<div class="btn-group me-2" id="empOwnerAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
    htmlData += '<button id="btnEmpOwner' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ data.empNm + '</button>';
    htmlData += '<input type="text" id="empOwnerEmail' + num + '" value="'+ data.email +'" hidden>';
    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteTaskOwner(' + num + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';

    $('#ownerEmpAddSpan').append(htmlData);

    empOwnerArr.push({
        email: data.email,
        domainId : data.domainId,
        companyCd: data.companyCd
    });

    empOwnerHeight += 1;
    fnResetOwnerEmpAdd_Modal();
}
// ************************* 소유자 팝업 처리 끝 ************************** //


// ************************* 보고자 팝업 처리 **************************** //
// 보고자 변경 모달 오픈 버튼 클릭
function fnOpenReportObjEmp_Modal() {
    fnResetReportObjEmpAdd_Modal();
    fnInitReportObjEmpGrid_Modal();
}

// 보고자 변경용 사용자팝업 초기화
function fnResetReportObjEmpAdd_Modal() {
    $("#reportObjEmpNm_Modal").val("");
    $('#reportObjEmpAddTable_Modal').DataTable().rows('.selected').deselect();
}

//소유자 변경 모달의사용자목록 그리드 생성
function fnInitReportObjEmpGrid_Modal() {
    let projectId = $("#pProjectId").val();
    let apiUrl = '/rest/user/projects/emps/' + projectId;

    dtReportObjEmpGrid = $("#reportObjEmpAddTable_Modal").DataTable({
        ajax: {
            url : apiUrl,
            type : "POST",
            dataSrc : "data",
            data : function (d) {
                d.empNm = $("#reportObjEmpNm_Modal").val();
            }
        },
        autoWidth: false,
        columnDefs: [
            // targets: 컬럼 인덱스를 지정한다 (0부터 시작).
            // width: 원하는 너비를 픽셀(px) 또는 백분율(%)로 지정한다.
            { targets: 0, width: "100px" },    // companyNm
            { targets: 1, width: "100px" },    // companyNm
            // { targets: 2, width: "0px" },   // companyCd (hidden)
            { targets: 3, width: "120px" },    // empNm
            { targets: 4, width: "100px" },    // posNm
            { targets: 5, width: "150px" },    // deptNm (기존 width 재사용)
            { targets: 6, width: "200px" }     // email
        ],
        columns: [
            {data: 'domainId'},
            {data: 'companyNm'},
            {data: 'companyCd', visible: false},
            {data: 'empNm'},
            {data: 'posNm'},
            {data: 'deptNm', width : "150px"},
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

//사용자목록 재조회
function fnReselReportObjEmpGrid_Modal() {
    dtReportObjEmpGrid.ajax.reload();
}

// 모달에서 선택한 사용자를 보고자 항목에 셋팅
function fnSetTaskReportObjEmp_Modal() {
    let buttonStyle = 'facebook';
    let len = $('#reportObjEmpAddTable_Modal').DataTable().rows('.selected').data().length;
    if(len === 0) {
        gfnFailAlert("보고대상자를 선택해주세요.", gDelay_Medium);
        return;
    }

    $('#reportObjEmpAddSpan').empty();
    reportObjEmpArr.length = 0;
    $('#reportObjEmpAdd_Modal').modal('hide');

    let data = $('#reportObjEmpAddTable_Modal').DataTable().rows('.selected').data()[0];
    let num = reportObjEmpHeight;
    let htmlData = '';
    htmlData += '<div class="btn-group me-2" id="reportObjEmpAddGroup' + num + '" aria-label="First group" role="group" style="margin-top:4px;">';
    htmlData += '<button id="btnReportObjEmpAdd' + num + '" type="button" class="btn btn-'+ buttonStyle + '">'+ data.empNm + '</button>';
    htmlData += '<input type="text" id="reportObjEmpAddEmail' + num + '" value="'+ data.email +'" hidden>';
    htmlData += '<button class="btn btn-'+ buttonStyle + '" type="button" onclick="fnDeleteReportObjEmpTask(' + num + ')">';
    htmlData += '<i class="fas fa-times"></i>';
    htmlData += '</button>';
    htmlData += '</div>';

    $('#reportObjEmpAddSpan').append(htmlData);

    reportObjEmpArr.push({
        email: data.email,
        domainId : data.domainId,
        companyCd: data.companyCd
    });

    reportObjEmpHeight += 1;
    fnResetOwnerEmpAdd_Modal();
}
// ************************* 보고자 팝업 처리 끝 ************************** //

</script>

</body>

</html>
