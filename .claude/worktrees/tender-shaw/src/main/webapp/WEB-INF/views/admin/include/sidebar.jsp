<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav id="sidebar" class="sidebar js-sidebar">
	<div class="sidebar-content js-simplebar">
		<a class="sidebar-brand" href="/admin/emps/usermngform">
			<span class="sidebar-brand-text align-middle">
				C.O. Task Manager
<!-- 				<sup><small class="badge bg-primary text-uppercase">Pro</small></sup> -->
			</span>
			<svg class="sidebar-brand-icon align-middle" width="32px" height="32px" viewBox="0 0 24 24" fill="none" stroke="#FFFFFF" stroke-width="1.5"
				stroke-linecap="square" stroke-linejoin="miter" color="#FFFFFF" style="margin-left: -3px">
				<path d="M12 4L20 8.00004L12 12L4 8.00004L12 4Z"></path>
				<path d="M20 12L12 16L4 12"></path>
				<path d="M20 16L12 20L4 16"></path>
			</svg>
		</a>

		<div class="sidebar-user">
			<div class="d-flex justify-content-center">
				<div class="flex-shrink-0">
					<img src="/adminkit/img/avatars/user.png" class="avatar img-fluid rounded me-1" alt="Charles Hall" />
				</div>
				<div class="flex-grow-1 ps-2">
					<div class="sidebar-user-title"><c:out value="${empNm}"/></div>
<!--					<a class="sidebar-user-title dropdown-toggle" href="#" data-bs-toggle="dropdown"><c:out value="${empNm}"/></a> -->
<!--					<div class="dropdown-menu dropdown-menu-start"> -->
<!-- 						<a class="dropdown-item" href="pages-profile.html"><i class="align-middle me-1" data-feather="user"></i> Profile</a> -->
<!-- 						<a class="dropdown-item" href="#"><i class="align-middle me-1" data-feather="pie-chart"></i> Analytics</a> -->
<!-- 						<div class="dropdown-divider"></div> -->
<!-- 						<a class="dropdown-item" href="pages-settings.html"><i class="align-middle me-1" data-feather="settings"></i> Settings & Privacy</a> -->
<!--						<a class="dropdown-item" href="https://docs.google.com/document/d/e/2PACX-1vQ6WGf5MAOEhZDA1-z6accOQvSO2IBKup4MP1PkCGTgzbuBUHUEajj88OGGtBDFgB_j5XziPnHQjnMy/pub" target="_blank"><i class="align-middle me-1" data-feather="help-circle"></i> Help Center</a> -->
<!--						<div class="dropdown-divider"></div> -->
<!--						<a class="dropdown-item" href="/page/taskmng/dashboardform"><i class="align-middle me-1" data-feather="user"></i> User</a> -->
<!--						<a class="dropdown-item" href="/auth/taskmng/ssologout"><i class="align-middle me-1" data-feather="log-out"></i> Log out</a> -->
<!--					</div> -->

					<div class="sidebar-user-subtitle"><c:out value="${deptNm}"/></div>
				</div>
			</div>
		</div>

		<ul class="sidebar-nav">
			<li class="sidebar-header">
				Task Manager Menus
			</li>
			
			
			<li class="sidebar-item" id="userManage">
				<a data-bs-target="#userSide" data-bs-toggle="collapse" class="sidebar-link collapsed">
					<i class="align-middle" data-feather="user"></i> <span class="align-middle">사용자관리</span>
				</a>
				<ul id="userSide" class="sidebar-dropdown list-unstyled collapse " data-bs-parent="#sidebar">
					<li class="sidebar-item" id="usermngform"><a class="sidebar-link" href="/admin/emps/usermngform">사용자관리</a></li>
					<li class="sidebar-item" id="authmngform"><a class="sidebar-link" href="/admin/emps/authmngform">사용자권한관리</a></li>
				</ul>
			</li>
			
			<li class="sidebar-item" id="deptmngform">
				<a class="sidebar-link" href="/admin/depts/deptmngform">
					<i class="align-middle" data-feather="copy"></i> <span class="align-middle">부서관리</span>
				</a>
			</li>
			<li class="sidebar-item" id="taskmngform">
				<a class="sidebar-link" href="/admin/tasks/taskmngform">
					<i class="align-middle" data-feather="file"></i> <span class="align-middle">태스크관리</span>
				</a>
			</li>
			<li class="sidebar-item" id="epsyncform">
				<a class="sidebar-link" href="/admin/syncs/epsyncform">
					<i class="align-middle" data-feather="refresh-cw"></i> <span class="align-middle">EP연동</span>
				</a>
			</li>
		</ul>
	</div>
</nav>