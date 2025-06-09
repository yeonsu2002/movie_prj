<%@page import="kr.co.yeonflix.dashboard.DashboardDTO"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.dashboard.DashboardService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    DashboardService dashboardService = new DashboardService();

	List<DashboardDTO> salesList = dashboardService.getDailySales();
    List<DashboardDTO> theaterList = dashboardService.getReservationByTheaterType();
    List<DashboardDTO> topMoviesList = dashboardService.getTop5Movies();
    List<DashboardDTO> memberDailyList = dashboardService.getMemberReservationCount();

    request.setAttribute("theaterList", theaterList); 
    request.setAttribute("topMoviesList", topMoviesList);
    request.setAttribute("memberDailyList", memberDailyList);
%>

<jsp:include page="/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드</title>
    <style> 
        #chart-container {
            width: 80%;
            max-width: 800px;
            margin: 50px auto;
        }
    </style>
    <link rel="stylesheet" href="/movie_prj/common/css/admin.css">
    <link rel="stylesheet" href="/movie_prj/admin/dashboard/dashboard.css/dashboard.css">
</head>
<body>
    <div class="content-container">
        <div class="dashboard-grid">
        
            <!-- 매출 차트 카드 -->
            <div class="dashboard-card">
                <div class="card-title">일별 매출</div>
                <div class="chart-container">
                    <canvas id="salesChart" style="width:100%; height:400px;"></canvas>
                </div>
            </div>
            <!-- 상영중 인기 영화 TOP 5 (수평 막대) -->
            <div class="dashboard-card">
                <div class="card-title">상영중 TOP 5 예매 영화</div>
                <div class="chart-container">
                    <canvas id="topMoviesChart" style="width:100%; height:400px;"></canvas>
                </div>
            </div>
            <!-- 회원 비회원 예매 건수 차트 -->
            <div class="dashboard-card">
                <div class="card-title">회원/비회원 예매 건수</div>
                <div class="chart-container">
                    <canvas id="memberChart" style="width:100%; height:400px;"></canvas>
                </div>
            </div>
            <!-- 특별관 예매 비율 (도넛 차트) -->
            <div class="dashboard-card">
                <div class="card-title">특별관 예매 비율</div>
                <div class="chart-container">
                    <canvas id="theaterChart" style="width:100%; height:400px;"></canvas>
                </div>
            </div>
        </div>
    </div>
    
 <script>
document.addEventListener('DOMContentLoaded', function() {
	// 1. 일별 매출 차트
    const salesData = [
        <% for (DashboardDTO sales : salesList) { %>
            {
                date: '<%= sales.getDate() %>',
                totalSales: <%= sales.getTotalSales() %>
            },
        <% } %>
    ];
    const salesLabels  = salesData.map(item => item.date);
    const sales = salesData.map(item => item.totalSales);

    const salesCtx  = document.getElementById('salesChart').getContext('2d');
    new Chart(salesCtx, {
        type: 'bar',
        data: {
            labels: salesLabels,
            datasets: [{
                label: '일별 매출 (원)',
                data: sales,
                backgroundColor: '#3b82f6'
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return value.toLocaleString() + '원'; // 매출 금액을 원 단위로 표시
                        }
                    }
                }
            }
        }
    });
 // 2. 회원/비회원 예매 건수 차트 (라인 차트)
    const memberDailyDataRaw = [
        <% for (DashboardDTO dto : (List<DashboardDTO>)request.getAttribute("memberDailyList")) { %>
            {
                date: '<%= dto.getDate() %>',
                memberType: '<%= dto.getMemberType() %>',
                count: <%= dto.getReservationCount() %>
            },
        <% } %>
    ];

    const memberLabels = [...new Set(memberDailyDataRaw.map(item => item.date))].sort();
    const memberCounts = {}, nonMemberCounts = {};
    memberLabels.forEach(date => {
        memberCounts[date] = 0;
        nonMemberCounts[date] = 0;
    });

    memberDailyDataRaw.forEach(item => {
        if (item.memberType === '회원') {
            memberCounts[item.date] = item.count;
        } else {
            nonMemberCounts[item.date] = item.count;
        }
    });

    const memberData = memberLabels.map(date => memberCounts[date]);
    const nonMemberData = memberLabels.map(date => nonMemberCounts[date]);

    const memberCtx = document.getElementById('memberChart').getContext('2d');
    new Chart(memberCtx, {
        type: 'line',
        data: {
            labels: memberLabels,
            datasets: [
                {
                    label: '회원',
                    data: memberData,
                    borderColor: '#3b82f6',
                    backgroundColor: 'rgba(59,130,246,0.2)',
                    tension: 0.3,
                    pointRadius: 5
                },
                {
                    label: '비회원',
                    data: nonMemberData,
                    borderColor: '#ec4899',
                    backgroundColor: 'rgba(236,72,153,0.2)',
                    tension: 0.3,
                    pointRadius: 5
                }
            ]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0
                    }
                }
            },
            plugins: {
                legend: {
                    position: 'top'
                },
                title: {
                    display: true,
                    text: ''
                }
            }
        }
    });
      
    // 3. 특별관 예매 비율
    const theaterCtx = document.getElementById('theaterChart').getContext('2d');
    const theaterData = {
        labels: [
            <c:forEach var="dto" items="${theaterList}" varStatus="loop">
                "${dto.theaterType}"<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ],
        datasets: [{
            label: '예매 수',
            data: [
                <c:forEach var="dto" items="${theaterList}" varStatus="loop">
                    ${dto.reservationCount}<c:if test="${!loop.last}">,</c:if>
                </c:forEach>
            ],
            backgroundColor: [
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)'
            ],
            borderWidth: 1
        }]
    };
    new Chart(theaterCtx, {
        type: 'doughnut',
        data: theaterData,
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'right',
                },
                title: {
                    display: true,
                    text: ''
                }
            }
        }
    });
 // 4. 상영중 인기 영화 TOP 5 차트 (수평 막대)
    const topMoviesCtx = document.getElementById('topMoviesChart').getContext('2d');
    const topMoviesData = {
        labels: [
            <c:forEach var="dto" items="${topMoviesList}" varStatus="loop">
             "${dto.movie_name}"<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ],
        datasets: [{
            label: '예매 건수',
            data: [
                <c:forEach var="dto" items="${topMoviesList}" varStatus="loop">
                    ${dto.reservationCount}<c:if test="${!loop.last}">,</c:if>
                </c:forEach>
            ],
            backgroundColor: 'rgba(75, 192, 192, 0.7)'
        }]
    };
    new Chart(topMoviesCtx, {
        type: 'bar',
        data: topMoviesData,
        options: {
            indexAxis: 'y',
            responsive: true,
            scales: {
                x: {
                    beginAtZero: true,
                    ticks: {
                        precision: 0
                    }
                }
            },
            plugins: {
                legend: { display: false },
                title: { display: true, text: '' }
            }
        }
    });
});
    </script>
</body>
</html>