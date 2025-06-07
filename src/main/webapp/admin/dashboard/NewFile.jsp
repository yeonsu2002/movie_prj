<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<link rel="stylesheet" href="http://localhost/movie_prj/common/css/admin.css">
<link rel="stylesheet" href="/movie_prj/admin/dashboard/dashboard.css/dashboard.css">
</head>
<body>
    <div class="content-container">
        <div class="dashboard-grid">
        <!-- 매출 차트 카드 -->
<div class="dashboard-card">
  <div class="card-title">일별 매출</div>
  <div class="chart-container">
    <canvas id="salesChart" style="width:100%; height:300px;"></canvas>
  </div>
</div>
        <!-- 성별 예매 건수 (라인 차트) -->
<div class="dashboard-card">
  <div class="card-title">성별 예매 건수</div>
  <div class="chart-container">
    <canvas id="genderChart" style="width:100%; height:300px;"></canvas>
  </div>
</div>

<!-- 장르별 예매 비율 (도넛 차트) -->
<div class="dashboard-card">
  <div class="card-title">장르별 예매 비율</div>
  <div class="chart-container">
    <canvas id="genreChart" style="width:100%; height:300px;"></canvas>
  </div>
</div>

<!-- 인기 영화 TOP 5 (수평 막대) -->
<div class="dashboard-card">
  <div class="card-title">TOP 5 예매 영화</div>
  <div class="chart-container">
    <canvas id="topMoviesChart" style="width:100%; height:300px;"></canvas>
  </div>
</div>


</div>

     

<script>
  // 임시 데이터: 날짜 (x축)
  const labels = ['2025-05-22', '2025-05-23', '2025-05-24', '2025-05-25', '2025-05-26'];

  // 임시 데이터: 매출액 (y축)
  const data = [150000, 200000, 170000, 220000, 180000];

  // 그래프 생성
  const ctx = document.getElementById('salesChart').getContext('2d');
  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: labels,
      datasets: [{
        label: '일별 매출 (원)',
        data: data,
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
              return value.toLocaleString() + '원'; // 숫자에 , 넣기
            }
          }
        }
      }
    }
  });
</script>
        <script>
            // 라인 차트 그리기 (간단한 Canvas 구현)
            document.addEventListener('DOMContentLoaded', function() {
                const canvas = document.getElementById('memberChart');
                if (!canvas) return;
                
                const ctx = canvas.getContext('2d');
                
                // Canvas 크기 설정
                canvas.width = canvas.offsetWidth;
                canvas.height = canvas.offsetHeight;
                
                // 데이터 포인트 (예시)
                const data1 = [20, 25, 30, 28, 35, 30, 32]; // 신규 회원
                const data2 = [45, 50, 55, 52, 58, 55, 60]; // 전체 회원  
                const data3 = [40, 42, 48, 45, 50, 47, 52]; // 활성 회원
                
                const maxValue = Math.max(...data1, ...data2, ...data3);
                const padding = 20;
                const chartWidth = canvas.width - padding * 2;
                const chartHeight = canvas.height - padding * 2;
                
                // 라인 그리기 함수
                function drawLine(data, color) {
                    ctx.strokeStyle = color;
                    ctx.lineWidth = 2;
                    ctx.beginPath();
                    
                    for(let i = 0; i < data.length; i++) {
                        const x = padding + (i * chartWidth / (data.length - 1));
                        const y = padding + chartHeight - (data[i] / maxValue * chartHeight);
                        
                        if(i === 0) {
                            ctx.moveTo(x, y);
                        } else {
                            ctx.lineTo(x, y);
                        }
                    }
                    ctx.stroke();
                }
                
                // 배경 격자 그리기
                ctx.strokeStyle = '#f3f4f6';
                ctx.lineWidth = 1;
                
                // 수평선
                for(let i = 0; i <= 5; i++) {
                    const y = padding + (i * chartHeight / 5);
                    ctx.beginPath();
                    ctx.moveTo(padding, y);
                    ctx.lineTo(padding + chartWidth, y);
                    ctx.stroke();
                }
                
                // 라인 그리기
                drawLine(data1, '#3b82f6');
                drawLine(data2, '#ec4899');
                drawLine(data3, '#86efac');
            });
        </script>
        <!-- Chart.js 스크립트 -->
<script>
  // 1. 성별 예매 건수 (라인 차트)
  const genderCtx = document.getElementById('genderChart').getContext('2d');
  new Chart(genderCtx, {
    type: 'line',
    data: {
      labels: ['5/22', '5/23', '5/24', '5/25', '5/26'],
      datasets: [
        {
          label: '남성',
          data: [30, 45, 40, 60, 50],
          borderColor: '#3b82f6',
          fill: false,
          tension: 0.3
        },
        {
          label: '여성',
          data: [50, 60, 55, 70, 65],
          borderColor: '#ec4899',
          fill: false,
          tension: 0.3
        }
      ]
    },
    options: {
      responsive: true,
      scales: {
        y: {
          beginAtZero: true,
          title: {
            display: true,
            text: '예매 건수'
          }
        }
      }
    }
  });

  // 2. 장르별 예매 비율 (도넛 차트)
  const genreCtx = document.getElementById('genreChart').getContext('2d');
  new Chart(genreCtx, {
    type: 'doughnut',
    data: {
      labels: ['액션', '코미디', '드라마', 'SF', '공포'],
      datasets: [{
        data: [120, 90, 60, 40, 30],
        backgroundColor: ['#f87171', '#facc15', '#4ade80', '#60a5fa', '#c084fc']
      }]
    },
    options: {
      responsive: true
    }
  });

  // 3. TOP 5 예매 영화 (수평 막대)
  const topMoviesCtx = document.getElementById('topMoviesChart').getContext('2d');
  new Chart(topMoviesCtx, {
    type: 'bar',
    data: {
      labels: ['범죄도시4', '퓨리오사', '혹성탈출', '쿵푸팬더4', '드라이브'],
      datasets: [{
        label: '예매 수',
        data: [320, 280, 250, 210, 180],
        backgroundColor: '#6366f1'
      }]
    },
    options: {
      indexAxis: 'y', // 수평 막대
      responsive: true,
      scales: {
        x: {
          beginAtZero: true
        }
      }
    }
  });
</script>
        
    </div>
</body>
</html>