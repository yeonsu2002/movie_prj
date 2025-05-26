<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/movie_prj/common/jsp/admin_header.jsp" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>관리자 대시보드</title>
<link rel="stylesheet" href="http://localhost/movie_prj/common/css/admin.css">
<link rel="stylesheet" href="/movie_prj/admin/dashboard/dashboard.css/dashboard.css">
</head>
<body>
    <div class="content-container">
        <div class="dashboard-grid">
            <!-- 매출 차트 -->
            <div class="dashboard-card">
                <div class="card-title">매출</div>
                <div class="chart-container">
                    <div class="bar-chart">
                        <div class="bar-group">
                            <div class="bar bar-blue" style="height: 60px;"></div>
                            <div class="bar bar-pink" style="height: 120px;"></div>
                        </div>
                        <div class="bar-group">
                            <div class="bar bar-blue" style="height: 80px;"></div>
                            <div class="bar bar-pink" style="height: 130px;"></div>
                        </div>
                        <div class="bar-group">
                            <div class="bar bar-blue" style="height: 100px;"></div>
                            <div class="bar bar-pink" style="height: 140px;"></div>
                        </div>
                        <div class="bar-group">
                            <div class="bar bar-blue" style="height: 70px;"></div>
                            <div class="bar bar-pink" style="height: 135px;"></div>
                        </div>
                        <div class="bar-group">
                            <div class="bar bar-blue" style="height: 110px;"></div>
                            <div class="bar bar-pink" style="height: 125px;"></div>
                        </div>
                    </div>
                    <div class="chart-legend">
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #3b82f6;"></div>
                            <span>작년 같은 달</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #ec4899;"></div>
                            <span>올해</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 예약 차트 -->
            <div class="dashboard-card">
                <div class="card-title">예약</div>
                <div class="chart-container">
                    <div class="bar-chart">
                        <div class="bar-group">
                            <div class="bar bar-green" style="height: 40px;"></div>
                            <div class="bar bar-light-green" style="height: 180px;"></div>
                        </div>
                        <div class="bar-group">
                            <div class="bar bar-green" style="height: 35px;"></div>
                            <div class="bar bar-light-green" style="height: 175px;"></div>
                        </div>
                        <div class="bar-group">
                            <div class="bar bar-green" style="height: 50px;"></div>
                            <div class="bar bar-light-green" style="height: 170px;"></div>
                        </div>
                        <div class="bar-group">
                            <div class="bar bar-green" style="height: 30px;"></div>
                            <div class="bar bar-light-green" style="height: 165px;"></div>
                        </div>
                        <div class="bar-group">
                            <div class="bar bar-green" style="height: 60px;"></div>
                            <div class="bar bar-light-green" style="height: 160px;"></div>
                        </div>
                    </div>
                    <div class="chart-legend">
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #22c55e;"></div>
                            <span>신규 예약</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #86efac;"></div>
                            <span>전체 예약</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="dashboard-grid">
            <!-- 회원 차트 -->
            <div class="dashboard-card">
                <div class="card-title">회원</div>
                <div class="chart-container">
                    <div class="line-chart">
                        <canvas id="memberChart"></canvas>
                    </div>
                    <div class="chart-legend">
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #3b82f6;"></div>
                            <span>신규 회원</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #ec4899;"></div>
                            <span>전체 회원</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-color" style="background-color: #86efac;"></div>
                            <span>활성 회원</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 통계 테이블 -->
            <div class="dashboard-card">
                <table class="stats-table">
                    <thead>
                        <tr>
                            <th>현황</th>
                            <th>현재 상영작 수</th>
                            <th>상영 예정</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>전체</td>
                            <td>7</td>
                            <td>8</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        
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
    </div>
</body>
</html>