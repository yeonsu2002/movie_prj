<%@page import="kr.co.yeonflix.movie.common.CommonService"%>
<%@page import="kr.co.yeonflix.movie.common.CommonDTO"%>
<%@page import="kr.co.yeonflix.movie.code.MovieCommonCodeDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.yeonflix.movie.code.MovieCommonCodeService"%>
<%@page import="kr.co.yeonflix.movie.MovieDTO"%>
<%@page import="kr.co.yeonflix.movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="Main template page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<%
    int movieIdx = Integer.parseInt(request.getParameter("movieIdx"));
    MovieService ms = new MovieService();
    MovieDTO mDTO = ms.searchOneMovie(movieIdx);
    MovieCommonCodeService mccs = new MovieCommonCodeService();
    
    request.setAttribute("genre", mccs.searchOneGenre(movieIdx));
    request.setAttribute("grade", mccs.searchOneGrade(movieIdx));
    
    String reservationRate = request.getParameter("reservationRate");
    
    
    
%>    
    <meta charset="UTF-8">
    <jsp:include page="../common/jsp/external_file.jsp" />
    <title>YEONFLIX 무비차트 - <%=mDTO.getMovieName() %> </title>
    <style>
        body {
            font-family: 'Malgun Gothic', sans-serif;
            line-height: 1.6;
            color: #333;
            margin: 0;
            padding: 0;
        }

        /* 메인 컨테이너 */
        #container {
            max-width: 980px;
            margin: 0 auto;
            padding: 0;
            background-color: #ffffff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        /* 영화 정보 섹션 */
        .movie-info-section {
            background: #ffffff;
            padding: 30px;
            border-bottom: 1px solid #e5e5e5;
        }

        .movie-detail-container {
            display: flex;
            gap: 30px;
        }

        /* 포스터 이미지 */
        .movie-poster {
            flex-shrink: 0;
        }

        .movie-poster img {
            width: 185px;
            height: 260px;
            object-fit: cover;
            border: 1px solid #ddd;
        }

        /* 영화 정보 */
        .movie-info {
            flex: 1;
        }

        .movie-title-container {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 15px;
        }

        .movie-title {
            font-size: 24px;
            font-weight: bold;
            color: #222;
        }

        .age-rating {
            display: inline-block;
            width: 22px;
            height: 22px;
            color: white;
            text-align: center;
        }

        

        .movie-meta {
            margin-bottom: 20px;
        }

        .rating-container {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }

        .reservation-rate {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .reservation-rate .label {
            font-size: 12px;
            color: #666;
        }

        .reservation-rate .percent {
            font-size: 16px;
            font-weight: bold;
            color: #fb4357;
        }

        .movie-details {
            font-size: 13px;
            line-height: 1.8;
            color: #666;
        }

        .movie-details div {
            margin-bottom: 5px;
        }

        .detail-label {
            color: #333;
            font-weight: normal;
            display: inline-block;
            width: 50px;
        }

        /* 버튼 영역 */
        .action-buttons {
            display: flex;
            gap: 8px;
            margin-top: 20px;
        }

        .btn-like {
            background: #fff;
            border: 1px solid #ddd;
            color: #666;
            padding: 8px 15px;
            font-size: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }

        .btn-like:hover {
            background: #f9f9f9;
        }

        /* 하트 아이콘 애니메이션 */
        .btn-like .heart-icon {
            transition: transform 0.2s ease;
        }

        .btn-like.active .heart-icon {
            transform: scale(1.2);
        }

        .btn-reserve {
            background: #fb4357;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-reserve:hover {
            background: #e03a4e;
        }

        /* 탭 메뉴 */
        .tab-navigation {
            background: #fff;
            border-bottom: 1px solid #ddd;
        }

        .tab-menu {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
            max-width: 980px;
            margin: 0 auto;
        }

        .tab-menu li {
            padding: 15px 20px;
            cursor: pointer;
            color: #666;
            font-size: 14px;
            border-bottom: 3px solid transparent;
            transition: all 0.3s ease;
        }

        .tab-menu li:hover {
            color: #fb4357;
        }

        .tab-menu li.active {
            color: #fb4357;
            border-bottom-color: #fb4357;
            font-weight: bold;
        }

        /* 탭 콘텐츠 */
        .tab-content-container {
            background: #fff;
            min-height: 500px;
            position: relative;
        }

        .tab-content {
            padding: 40px 30px;
            max-width: 980px;
            margin: 0 auto;
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .tab-content h3 {
            font-size: 18px;
            color: #222;
            margin: 0 0 20px 0;
            font-weight: bold;
        }

        .movie-description {
            font-size: 14px;
            line-height: 1.7;
            color: #555;
        }

        /* 로딩 애니메이션 */
        .loading {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            color: #666;
            display: none;
        }

        .loading-spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #fb4357;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 0 auto 10px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* 트레일러 섹션 */
        .trailer-container {
            text-align: center;
        }

        .trailer-preview {
            position: relative;
            width: 100%;
            max-width: 640px;
            height: 360px;
            margin: 0 auto;
            background: #000;
            cursor: pointer;
            overflow: hidden;
        }

        .trailer-background {
            width: 100%;
            height: 100%;
            background-image: url('http://localhost/movie_prj/common/img/<%= mDTO.getPosterPath() %>');
            background-size: cover;
            background-position: center;
        }

        .trailer-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .play-button {
            width: 70px;
            height: 70px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .play-button:hover {
            background: rgba(255, 255, 255, 1);
            transform: scale(1.1);
        }

        .play-button::before {
            content: '';
            width: 0;
            height: 0;
            border-left: 20px solid #333;
            border-top: 12px solid transparent;
            border-bottom: 12px solid transparent;
            margin-left: 4px;
        }

        .trailer-iframe {
            display: none;
            width: 100%;
            max-width: 640px;
            height: 360px;
            border: none;
            margin: 0 auto;
        }

        /* 리뷰 섹션 */
        .review-placeholder {
            text-align: center;
            padding: 60px 20px;
            color: #999;
            font-size: 14px;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            #container {
                margin: 0 10px;
            }

            .movie-detail-container {
                flex-direction: column;
                text-align: center;
            }

            .movie-poster img {
                width: 150px;
                height: 210px;
                margin: 0 auto;
            }

            .tab-menu {
                flex-wrap: wrap;
            }

            .tab-menu li {
                flex: 1;
                text-align: center;
                min-width: 80px;
                padding: 12px 10px;
                font-size: 13px;
            }

            .tab-content {
                padding: 30px 20px;
            }
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // 탭 콘텐츠 캐시 (한 번만 로드)
        const tabContentCache = {};
        let isInitialized = false;

        $(document).ready(function () {
            // 페이지 로드 시 초기화
            initializePage();
            
            // DOM이 완전히 준비된 후 위시리스트 상태 확인
            setTimeout(function() {
                checkWishlistStatus(<%= movieIdx %>);
            }, 200); // 약간의 지연을 주어 DOM 로딩 완료 보장
            
            // 탭 클릭 이벤트
            $('.tab-menu li').click(function (e) {
                e.preventDefault();
                const $this = $(this);
                const tabId = $this.data('tab');

                // 이미 활성화된 탭이면 return
                if ($this.hasClass('active')) {
                    return;
                }

                // 탭 전환
                switchTab(tabId);
            });

            // 브라우저 뒤로가기/앞으로가기 처리
            $(window).on('hashchange', function() {
                const hash = window.location.hash.substring(1);
                if (hash && hash !== getCurrentActiveTab()) {
                    switchTab(hash, false); // 히스토리 업데이트 안함
                }
            });
        });

        function initializePage() {
            // 초기 해시 확인
            let initialTab = 'main-info'; // 기본 탭
            
            if (window.location.hash) {
                const hash = window.location.hash.substring(1);
                const $targetTab = $('[data-tab="' + hash + '"]');
                if ($targetTab.length) {
                    initialTab = hash;
                }
            }
            
            // 초기 탭 로드
            switchTab(initialTab, false);
            isInitialized = true;
        }

        function switchTab(tabId, updateHistory = true) {
            const movieIdx = <%= movieIdx %>;
            
            // 탭 메뉴 활성화 상태 변경
            $('.tab-menu li').removeClass('active');
            $('[data-tab="' + tabId + '"]').addClass('active');

            // 히스토리 업데이트 (중복 방지)
            if (updateHistory && isInitialized && window.location.hash.substring(1) !== tabId) {
                history.replaceState(null, null, '#' + tabId);
            }

            // 캐시된 콘텐츠가 있으면 바로 표시
            if (tabContentCache[tabId]) {
                showTabContent(tabId, tabContentCache[tabId]);
                return;
            }

            // 로딩 표시
            showLoading();

            // AJAX로 콘텐츠 로드
            $.ajax({
                url: "getMovieTabContent.jsp",
                type: "GET",
                data: {
                    movieIdx: movieIdx,
                    tabType: tabId
                },
                dataType: "html",
                timeout: 10000,
                beforeSend: function() {
                    console.log("Loading tab:", tabId, "for movie:", movieIdx); // 디버깅용
                },
                error: function(xhr, status, error) {
                    console.error("AJAX Error:", xhr.status, xhr.statusText, error);
                    console.error("Response Text:", xhr.responseText); // 에러 상세 확인
                    
                    hideLoading();
                    const errorContent = '<div class="tab-content active" style="text-align: center; padding: 60px 20px; color: #e74c3c;">' +
                        '<div style="font-size: 18px; margin-bottom: 10px;">⚠️</div>' +
                        '<div>콘텐츠를 불러오는 중 오류가 발생했습니다.</div>' +
                        '<div style="font-size: 12px; color: #666; margin-top: 10px;">Error: ' + xhr.status + ' - ' + error + '</div>' +
                        '<button onclick="retryLoadTab(\'' + tabId + '\')" style="margin-top: 20px; padding: 10px 20px; background: #3498db; color: white; border: none; cursor: pointer; border-radius: 4px;">다시 시도</button>' +
                        '</div>';
                    showTabContent(tabId, errorContent);
                },
                success: function(response) {
                    console.log("Tab loaded successfully:", tabId); // 디버깅용
                    console.log("Response length:", response.length); // 응답 길이 확인
                    
                    hideLoading();
                    
                    // 응답이 비어있는지 확인
                    if (!response || response.trim() === '') {
                        const emptyContent = '<div class="tab-content active" style="text-align: center; padding: 60px 20px; color: #999;">' +
                            '<div>콘텐츠가 없습니다.</div>' +
                            '</div>';
                        showTabContent(tabId, emptyContent);
                        return;
                    }
                    
                    // 캐시에 저장
                    tabContentCache[tabId] = response;
                    showTabContent(tabId, response);
                    
                    // 트레일러 탭이면 이벤트 바인딩
                    if (tabId === 'trailer') {
                        bindTrailerEvents();
                    }
                }
            });
        }

        function showTabContent(tabId, content) {
            // 모든 기존 탭 콘텐츠 숨기기
            $('.tab-content').removeClass('active').hide();
            
            // 새 콘텐츠 삽입
            $('.tab-content-container').html(content);
            
            // 새 콘텐츠 활성화
            $('.tab-content').addClass('active').show();
        }

        function getCurrentActiveTab() {
            return $('.tab-menu li.active').data('tab');
        }

        function retryLoadTab(tabId) {
            // 캐시 삭제 후 다시 로드
            delete tabContentCache[tabId];
            switchTab(tabId, false);
        }

        // 로딩 표시
        function showLoading() {
            $('.tab-content-container').html(
                '<div class="loading" style="display: block;">' +
                '<div class="loading-spinner"></div>' +
                '<div>로딩 중...</div>' +
                '</div>'
            );
        }

        // 로딩 숨김
        function hideLoading() {
            $('.loading').hide();
        }

        // 트레일러 이벤트 바인딩
        function bindTrailerEvents() {
            $('.trailer-preview').off('click').on('click', function() {
                playTrailer();
            });
        }

        // 트레일러 재생
        function playTrailer() {
            $('.trailer-preview').hide();
            $('.trailer-iframe').show();
        }
        
        // 위시리스트 상태 확인 함수 (수정된 버전)
        function checkWishlistStatus(movieIdx) {
            console.log('위시리스트 상태 확인 시작:', movieIdx); // 디버깅용
            
            $.ajax({
                url: 'check_wish_list_status.jsp',
                type: 'GET',
                data: { movieIdx: movieIdx },
                dataType: 'json',
                timeout: 5000, // 5초 타임아웃 추가
                success: function(response) {
                    console.log('위시리스트 상태 응답:', response);
                    
                    // 응답 데이터 검증
                    if (response && typeof response.isWishlisted !== 'undefined') {
                        const $btnLike = $('.btn-like');
                        const $heartIcon = $btnLike.find('.heart-icon');
                        const $btnText = $btnLike.find('.btn-text');
                        
                        if (response.isWishlisted === true || response.isWishlisted === 'true') {
                            // 위시리스트에 있는 경우
                            $btnLike.addClass('active');
                            $heartIcon.text('❤️');
                            $btnText.text('보고싶어요');
                            console.log('위시리스트 상태: 활성화됨');
                        } else {
                            // 위시리스트에 없는 경우
                            $btnLike.removeClass('active');
                            $heartIcon.text('🤍');
                            $btnText.text('보고싶어요');
                            console.log('위시리스트 상태: 비활성화됨');
                        }
                    } else {
                        console.log('유효하지 않은 응답:', response);
                    }
                },
                error: function(xhr, status, error) {
                    console.log('위시리스트 상태 확인 실패:', {
                        status: xhr.status,
                        statusText: xhr.statusText,
                        error: error,
                        responseText: xhr.responseText
                    });
                    
                    // 에러 발생 시 기본값으로 설정
                    $('.btn-like')
                        .removeClass('active')
                        .find('.heart-icon').text('🤍')
                        .end()
                        .find('.btn-text').text('보고싶어요');
                }
            });
        }

        // 보고싶어요 버튼 토글 함수 (수정된 버전)
        function toggleWishlist(button) {
            const $button = $(button);
            const $heartIcon = $button.find('.heart-icon');
            const $btnText = $button.find('.btn-text');
            
            // 이미 처리 중인지 확인
            if ($button.prop('disabled')) {
                console.log('이미 처리 중입니다.');
                return;
            }
            
            // 현재 상태 확인
            const isActive = $button.hasClass('active');
            const movieIdx = <%= movieIdx %>;
            
            console.log('toggleWishlist 시작:', {
                movieIdx: movieIdx,
                isActive: isActive,
                currentHeartIcon: $heartIcon.text()
            });
            
            // 버튼 비활성화 (중복 클릭 방지)
            $button.prop('disabled', true);
            
            if (isActive) {
                // 활성화 상태 -> 비활성화 (위시리스트에서 제거)
                removeFromWishlist(movieIdx, function(success) {
                    if (success) {
                        $button.removeClass('active');
                        $heartIcon.text('🤍');
                        $btnText.text('보고싶어요');
                        console.log('보고싶어요 취소 완료');
                    } else {
                        console.log('보고싶어요 취소 실패');
                    }
                    $button.prop('disabled', false);
                });
            } else {
                // 비활성화 상태 -> 활성화 (위시리스트에 추가)
                addToWishlist(movieIdx, function(success) {
                    if (success) {
                        $button.addClass('active');
                        $heartIcon.text('❤️');
                        $btnText.text('보고싶어요');
                        
                        // 애니메이션 효과
                        $heartIcon.css('transform', 'scale(1.4)');
                        setTimeout(() => {
                            $heartIcon.css('transform', 'scale(1.2)');
                        });
                        
                        console.log('보고싶어요 추가 완료');
                    } else {
                        console.log('보고싶어요 추가 실패');
                    }
                    $button.prop('disabled', false);
                });
            }
        }

        // 위시리스트에 추가하는 함수 (수정된 버전)
        function addToWishlist(movieIdx, callback) {
            $.ajax({
                url: 'add_wish_list.jsp',
                type: 'POST',
                data: { movieIdx: movieIdx },
                dataType: 'json',
                success: function(response) {
                    console.log('서버 응답:', response);
                    if (response.result === 'success') {
                        console.log('서버에 보고싶어요 추가 완료');
                        callback(true);
                    } else {
                        console.log('서버 에러:', response.message);
                        callback(false);
                    }
                },
                error: function(xhr, status, error) {
                    console.log('AJAX 에러:', xhr.status, xhr.responseText);
                    
                    // 401 Unauthorized (로그인 필요)
                    if (xhr.status === 401) {
                        alert('로그인이 필요합니다.');
                    } else {
                        console.log('보고싶어요 추가 실패');
                    }
                    callback(false);
                }
            });
        }

        // 위시리스트에서 제거하는 함수 (수정된 버전)
        function removeFromWishlist(movieIdx, callback) {
            $.ajax({
                url: 'remove_wish_list.jsp',
                type: 'POST',
                data: { movieIdx: movieIdx },
                dataType: 'json',
                success: function(response) {
                    console.log('서버 응답:', response);
                    if (response.result === 'success') {
                        console.log('서버에서 보고싶어요 제거 완료');
                        callback(true);
                    } else {
                        console.log('서버 에러:', response.message);
                        callback(false);
                    }
                },
                error: function(xhr, status, error) {
                    console.log('AJAX 에러:', xhr.status, xhr.responseText);
                    
                    if (xhr.status === 401) {
                        alert('로그인이 필요합니다.');
                    } else {
                        console.log('보고싶어요 제거 실패');
                    }
                    callback(false);
                }
            });
        }
    </script>
</head>
<body>
    <header>
        <jsp:include page="../common/jsp/header.jsp" />
    </header>
    
    <main>
        <div id="container">
            <div class="movie-info-section">
                <div class="movie-detail-container">
                    <div class="movie-poster">
                        <img src="/movie_prj/common/img/<%=mDTO.getPosterPath() %>" alt="<%=mDTO.getMovieName() %>"/>
                    </div>
                    <div class="movie-info">
                        <div class="movie-title-container">
                            <span class="age-rating all"><img src="http://localhost/movie_prj/common/img/icon_${grade}.svg" /></span>
                            <h1 class="movie-title"><%=mDTO.getMovieName() %></h1>
                        </div>
                        
                        <div class="rating-container">
                            <div class="reservation-rate">
                                <span class="label">예매율</span>
                                <span class="percent"><%=reservationRate%>%</span>
                            </div>
                        </div>
                        
                        <div class="movie-details">
                            <div><span class="detail-label">감독</span>: <%= mDTO.getDirectors()%></div>
                            <div><span class="detail-label">배우</span>: <%= mDTO.getActors()%></div>
                            <div><span class="detail-label">장르</span>: ${genre}</div>
                            <c:choose>
                            <c:when test="''">
                            <div><span class="detail-label">기본</span>: ${grade}세이상관람가, <%= mDTO.getRunningTime() %>분, <%=mDTO.getCountry() %></div>
                            </c:when>
                            </c:choose>
                            <div><span class="detail-label">개봉</span>: <%= mDTO.getReleaseDate() %></div>
                        </div>
                        
                        <div class="action-buttons">
                             <button class="btn-like" onclick="toggleWishlist(this)">
                                <span class="heart-icon">🤍</span>
                                <span class="btn-text">보고싶어요</span>
                            </button>
                            <a href="../reservation/reservation.jsp"><button class="btn-reserve">예매하기</button></a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tab-navigation">
                <ul class="tab-menu">
                    <li data-tab="main-info">주요정보</li>
                    <li data-tab="trailer">트레일러</li>
                    <li data-tab="review">실관람평</li>
                </ul>
            </div>

            <div class="tab-content-container">
                <!-- 동적 로딩되는 콘텐츠 영역 -->
            </div>
        </div>
    </main>
    
    <footer>
        <jsp:include page="../common/jsp/footer.jsp" />
    </footer>
</body>
</html>