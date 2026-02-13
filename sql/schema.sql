-- ============================================================
-- 가계부 데이터베이스 스키마  (MySQL 8.0+)
-- ============================================================

CREATE DATABASE IF NOT EXISTS household_budget
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE household_budget;

-- 카테고리
CREATE TABLE IF NOT EXISTS category (
    category_id   INT          NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(50)  NOT NULL,
    category_type CHAR(1)      NOT NULL COMMENT 'I:수입 E:지출',
    icon          VARCHAR(60)  NOT NULL DEFAULT 'bi-tag',
    color         VARCHAR(20)  NOT NULL DEFAULT '#6c757d',
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 거래 내역
CREATE TABLE IF NOT EXISTS transaction_history (
    tx_id            INT           NOT NULL AUTO_INCREMENT,
    category_id      INT           NOT NULL,
    title            VARCHAR(100)  NOT NULL,
    amount           BIGINT        NOT NULL,
    tx_type          CHAR(1)       NOT NULL COMMENT 'I:수입 E:지출',
    tx_date          DATE          NOT NULL,
    memo             VARCHAR(500)  DEFAULT NULL,
    created_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (tx_id),
    KEY idx_tx_date (tx_date),
    KEY idx_category (category_id),
    CONSTRAINT fk_tx_category FOREIGN KEY (category_id) REFERENCES category(category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 월별 예산 (확장용)
CREATE TABLE IF NOT EXISTS monthly_budget (
    budget_id     INT    NOT NULL AUTO_INCREMENT,
    budget_year   INT    NOT NULL,
    budget_month  INT    NOT NULL,
    category_id   INT    NOT NULL,
    budget_amount BIGINT NOT NULL DEFAULT 0,
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (budget_id),
    UNIQUE KEY uq_budget (budget_year, budget_month, category_id),
    CONSTRAINT fk_budget_cat FOREIGN KEY (category_id) REFERENCES category(category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 기본 카테고리
-- ============================================================
INSERT INTO category (category_name, category_type, icon, color) VALUES
-- 수입
('급여',       'I', 'bi-cash-stack',       '#198754'),
('부수입',     'I', 'bi-piggy-bank',        '#20c997'),
('용돈',       'I', 'bi-wallet2',           '#0dcaf0'),
('투자수익',   'I', 'bi-graph-up-arrow',    '#0d6efd'),
('기타수입',   'I', 'bi-plus-circle',       '#6f42c1'),
-- 지출
('식비',       'E', 'bi-cup-hot',           '#dc3545'),
('교통비',     'E', 'bi-bus-front',         '#fd7e14'),
('쇼핑',       'E', 'bi-bag-heart',         '#e83e8c'),
('의료/건강',  'E', 'bi-heart-pulse',       '#d63384'),
('문화/여가',  'E', 'bi-film',              '#6610f2'),
('교육',       'E', 'bi-book',              '#0d6efd'),
('통신비',     'E', 'bi-phone',             '#0dcaf0'),
('주거/관리비','E', 'bi-house',             '#198754'),
('저축/보험',  'E', 'bi-safe2',             '#20c997'),
('기타지출',   'E', 'bi-three-dots',        '#6c757d');

-- ============================================================
-- 샘플 거래 데이터
-- ============================================================
INSERT INTO transaction_history (category_id, title, amount, tx_type, tx_date, memo) VALUES
(1,  '2월 급여',       3200000, 'I', DATE_FORMAT(NOW(),'%Y-%m-01'), '정기 급여'),
(2,  '프리랜서 작업',   500000, 'I', DATE_FORMAT(NOW(),'%Y-%m-05'), '웹 디자인 외주'),
(6,  '마트 장보기',      85000, 'E', DATE_FORMAT(NOW(),'%Y-%m-03'), '주간 식료품'),
(7,  '교통카드 충전',    52000, 'E', DATE_FORMAT(NOW(),'%Y-%m-04'), '버스/지하철'),
(8,  '겨울 코트',       149000, 'E', DATE_FORMAT(NOW(),'%Y-%m-06'), '세일 구매'),
(6,  '가족 외식',        65000, 'E', DATE_FORMAT(NOW(),'%Y-%m-08'), '주말 외식'),
(11, '온라인 강의',      49000, 'E', DATE_FORMAT(NOW(),'%Y-%m-09'), 'Udemy'),
(12, '핸드폰 요금',      55000, 'E', DATE_FORMAT(NOW(),'%Y-%m-10'), '월정액'),
(13, '월세',            600000, 'E', DATE_FORMAT(NOW(),'%Y-%m-01'), '2월 월세'),
(14, '적금',            300000, 'E', DATE_FORMAT(NOW(),'%Y-%m-02'), '정기 적금');
