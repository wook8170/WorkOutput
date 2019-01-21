-- config
service_configCREATE DATABASE config DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE config;

CREATE TABLE service_config (
	seq 								BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '순서',
	limit_log							SMALLINT		DEFAULT	100					COMMENT '로그 임계치, 단위 (GB)',						
	limit_doc							SMALLINT		DEFAULT	80					COMMENT '문서 임계치, 단위 (GB)',
	service_admin_email					VARCHAR(128)								COMMENT '서비스 어드민 이메일',
	service_admin_telno					VARCHAR(128)								COMMENT '서비스 어드민 전화번호'
	PRIMARY KEY (seq)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;
	
-- share_status

CREATE TABLE share_status (
	seq									BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '공유 상태 코드 (공유요청:0001, 공유진행중:0002, 공유결재: 0003, 공유반려:0004)',
	share_status_code					TINYINT			NOT NULL					COMMENT '공유 상태 명 (공유요청:0001, 공유진행중:0002, 공유결재: 0003, 공유반려:0004)',
	share_status_name					VARCHAR(128)	NOT NULL					COMMENT '설명',
	share_status_description			TEXT,
		
	PRIMARY KEY (seq)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;
	
-- tenant_info

CREATE TABLE tenant_info (
	tenant_id						   	BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '순서',
	tenant_admin_email					VARCHAR(128)	NOT NULL					COMMENT '고객사 어드민 이메일',
	tenant_admin_telno					VARCHAR(128)	NOT NULL					COMMENT '고객사 어드민 전화번호',
	tenant_name                        	vARCHAR(128)	NOT NULL					COMMENT '고객사 이름',
	tenant_admin_ip					   	VARCHAR(15)		DEFAULT "0.0.0.0"			COMMENT '고객사 어드민 접근 허용 아이피',
	tenant_admin_password			   	VARCHAR(128) 	NOT NULL					COMMENT '고객사 어드민 암호',							
	tenant_admin_password_reset_cycle	SMALLINT		DEFAULT 0					COMMENT '고객사 어드민 암호 재설정 주기. 단위 (일)',
	tenant_storage_size					SMALLINT		DEFAULT 5 					COMMENT '고객사 전체 스토리지 용량. 단위 (GB)',			
	tenant_encrypted_datakey			VARCHAR(128) 	NOT NULL					COMMENT '고객사 암호화 키 (via KMS)',
    
	PRIMARY KEY (tenant_id)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;


-- -------------------------------------------------------------------------------------------------
-- tentnt table 
-- -------------------------------------------------------------------------------------------------
CREATE DATABASE tenant_XXX DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE tenant_XXX;

CREATE TABLE config_info (
	seq 								BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '순서',
	password_reset_cycle				SMALLINT		DEFAULT 30					COMMENT '사용자 암호 재설정 주기. 단위 (일)',
	share_period						SMALLINT		DEFAULT 7					COMMENT '공유 기간 단위 (일)',
	sesstion_timeout					SMALLINT		DEFAULT 15000				COMMENT '사용사 세션 타임아웃',
	
	PRIMARY KEY (seq)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;

CREATE TABLE user_info (
	user_id								BIGINT 			NOT NULL AUTO_INCREMENT 	COMMENT '사용자 아이디',
	user_email							VARCHAR(128)	NOT NULL 					COMMENT '사용자 이메일',							
	user_password						VARCHAR(128) 								COMMENT '사용자 암호',
	user_name							VARCHAR(128) 								COMMENT '사용자 이름',config_info
	user_profile_image					VARCHAR(1024) 								COMMENT '사용자 프로필 이미지',
	user_nick							VARCHAR(128) 								COMMENT '사용자 별칭',
	user_telno							VARCHAR(16) 								COMMENT '사용자 전화번호',	
	dept_code							SMALLINT 									COMMENT '부서 코드',
	group_codes							SMALLINT 									COMMENT '그룹 코드들',
	position_code						TINYINT 									COMMENT '직급 코드',
	policy_code							TINYINT 									COMMENT '정책 코드',	
	user_is_active						BOOL			DEFAULT TRUE 				COMMENT '사용자 활성화 상태',
	user_is_approver					BOOL			DEFAULT FALSE 				COMMENT '결재 권환 유무',
	user_join_time						DATETIME 									COMMENT '사용자 활성화 시작 시간',
	user_last_password_change_time		DATETIME 									COMMENT '마지막 암호 변경 날짜',
	
	PRIMARY KEY (user_id)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;

CREATE TABLE external_user_info (
	external_user_id					BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '외부 사용자 아이디',
	external_user_email					VARCHAR(128)	NOT NULL 					COMMENT '외부 사용자 이메일',	
	external_user_name					VARCHAR(128)	NOT NULL 					COMMENT '외부 사용자 이름',
	user_id								BIGINT			NOT NULL 					COMMENT '관계된 내부 사용자 아디디',						
	
	PRIMARY KEY (external_user_id)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;

CREATE TABLE dept_group_info (
	dept_code							BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '부서 코드',
	dept_name							VARCHAR(128)	NOT NULL 					COMMENT '부서 이름',
	dept_description					VARCHAR(512)	NOT NULL 					COMMENT '부서 설명',
	dept_level							TINYINT										COMMENT '부서 레벨',	
	dept_is_group						BOOL			DEFAULT FALSE 				COMMENT '부서/그룹 구분',
	dept_is_active						BOOL			DEFAULT TRUE 				COMMENT '부서/그룹 활성화 상태',
	policy_code							TINYINT			NOT NULL 					COMMENT '정책 코드',						
	
	PRIMARY KEY (dept_code)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;

CREATE TABLE position_info (
	seq									BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '순서',
	position_code						TINYINT			NOT NULL 					COMMENT '직급 코드',
	position_name						VARCHAR(128)	NOT NULL 					COMMENT '직급 이름',
	position_description				TEXT 										COMMENT '직급 설명',					
	
	PRIMARY KEY (seq)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;


CREATE TABLE policy_info (
	policy_code							BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '정책 코드',
	policy_type							TINYINT			NOT NULL 					COMMENT '정책 타입 (개인:0001, 부서:0002, 그룹:0003)',						
	policy_description					TEXT										COMMENT '정책 설명',
	allow_read							BOOL			DEFAULT FALSE 				COMMENT '읽기 허용',
	allow_write							BOOL			DEFAULT FALSE 				COMMENT '쓰기/편집 허용(추후 사용)',
	allow_extenal						BOOL			DEFAULT FALSE 				COMMENT '외부 반출 허용',
	allow_download						BOOL			DEFAULT FALSE 				COMMENT '다운로드 허용',
		
	PRIMARY KEY (policy_code)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;


CREATE TABLE approval_line_info (
	approval_line_code					BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '결재 라인 코드',
	approval_line_persons				TEXT			NOT NULL 					COMMENT '결재 라인에 포함된 사람들 (결재자 순서)',						
	approval_lien_description			TEXT										COMMENT '결재 라인 설명서',

	PRIMARY KEY (approval_line_code)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;

CREATE TABLE user_dept_list (
	seq									BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '순서',
	user_id								BIGINT			NOT NULL 					COMMENT '사용자 아이디',	
	dept_code							BIGINT			NOT NULL 					COMMENT '부서 코드',
	is_boss								BOOL			DEFAULT FALSE 				COMMENT '최상위 그룹/부서장',
	
	PRIMARY KEY (seq)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;
	
CREATE TABLE docs (
	doc_code							BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '문서 코드',
	doc_box_name						VARCHAR(128)	NOT NULL 					COMMENT '문서 카테고리',
	doc_url								VARCHAR(1024)	NOT NULL 					COMMENT '문서 URL (S3)',
	user_id								BIGINT			NOT NULL 					COMMENT '문서 소유자',
	doc_create_time						DATETIME		NOT NULL 					COMMENT '문서 생성 시간',
	doc_modify_time						DATETIME		NOT NULL 					COMMENT '문서 수정 시간',
	doc_size							BIGINT			NOT NULL 					COMMENT '문서 크기',
	doc_security_result					BOOL			DEFAULT FALSE 				COMMENT '문서 보안 체크 결과 (DLP)',
	doc_is_delete						BOOL			DEFAULT FALSE 				COMMENT '문서 삭제 상태 (휴지통)',
	doc_delete_time						DATETIME		NOT NULL 					COMMENT '문서 삭제 시간 (휴지통 보관 한계일)',
	doc_share_count						SMALLINT		NOT NULL 					COMMENT '문서 공유 횟수',
	doc_download_count					SMALLINT		NOT NULL 					COMMENT '문서 다운로드 횟수',
	doc_hash_tag						TEXT 										COMMENT '해시 태크',
	is_favorite							BOOL			DEFAULT FALSE 				COMMENT '즐겨 찾기',						
	
	PRIMARY KEY (doc_code)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;

CREATE TABLE share_list (
	share_code							BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '공유 코드',
	doc_code							BIGINT			NOT NULL 					COMMENT '문서 코드',	
	approval_line_code					SMALLINT 									COMMENT '결재 라인 코드',
	current_approver					BIGINT										COMMENT '현재 결재자 아이디',
	send_user_id						BIGINT			NOT NULL 					COMMENT '공유한 사람 아이디',
	recv_user_ids						TEXT			NOT NULL 					COMMENT '공유 받은 사람 아이디들',
	dept_groups_codes					TEXT 										COMMENT '부서/그룹 코드(부서 공유시)',
	policy_code							SMALLINT		NOT NULL 					COMMENT '적용된 정책 코드',
	share_status_code					TINYINT			NOT NULL 					COMMENT '공유 상태 코드',
	share_expire_time					DATETIME 									COMMENT '공유 만료 날짜',
	share_cancel_time					DATETIME 									COMMENT '공유 취소(해지) 시간',
	share_cancel_reason					TEXT 										COMMENT '공유 취소(해지) 사유',
	share_reject_time					DATETIME 									COMMENT '공유 반려 시간',
	share_reject_reason					TEXT 										COMMENT '공유 반려 사유',	
	share_is_approved					BOOL			DEFAULT FALSE 				COMMENT '공유 완료 상태',	
	share_alarm_status					VARCHAR(128) 								COMMENT '알람 확인 상태 ( "TRUE:결재 요청" or "FALSE:결재 진행중",... )',	
	is_favorite							BOOL			DEFAULT FALSE 				COMMENT '즐겨 찾기',
	
	PRIMARY KEY (share_code)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;

CREATE TABLE external_share_list (
	share_code							BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '공유 코드',
	doc_code							BIGINT			NOT NULL 					COMMENT '문서 코드',
	approval_line_code					SMALLINT 									COMMENT '결재 라인 코드',
	current_approver					BIGINT										COMMENT '현재 결재자 아이디',
	send_user_id						BIGINT			NOT NULL 					COMMENT '공유한 사람 아이디',
	external_user_id					VARCHAR(128)	NOT NULL 					COMMENT '공유 받는 외부인 아이디 ???????',
	policy_code							SMALLINT 									COMMENT '적용된 정책 코드',
	share_status_code					TINYINT			NOT NULL 					COMMENT '공유 상태 코드',
	share_expire_time					DATETIME 									COMMENT '공유 만료 날짜',
	sharE_cancel_time					DATETIME 									COMMENT '공유 취소(해지) 시간',
	share_cnacel_reason					TEXT 										COMMENT '공유 취소(해지) 사유',
	share_reject_time					DATETIME 									COMMENT '공유 반려 시간',
	share_reject_reason					TEXT 										COMMENT '공유 반려 사유',
	share_is_approved					BOOL			DEFAULT FALSE 				COMMENT '공유 완료 상태',
	share_alarm_status					VARCHAR(128) 								COMMENT '알람 확인 상태 ( "TRUE:결재 요청" or "FALSE:결재 진행중",... )',
	is_favorite							BOOL			DEFAULT FALSE 				COMMENT '즐겨 찾기',						
	
	PRIMARY KEY (share_code)	
);

CREATE TABLE transactiopn_status (
	seq									BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '순서',
	transaction_code					BIGINT			NOT NULL 					COMMENT '트랜잭션 코드',
	transaction_name					VARCHAR(128)	NOT NULL 					COMMENT '트랜잭션 이름',					
	
	PRIMARY KEY (seq)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;

CREATE TABLE last_transaction_list (
	transaction_id						BIGINT 			NOT NULL AUTO_INCREMENT		COMMENT '트랜잭션 아이디',					
	user_id								BIGINT			NOT NULL 					COMMENT '트랜잭션이 적용된 사용자 아이디',
	transaction_code					TINYINT			NOT NULL 					COMMENT '트랜잭션 코드(종류)',
	trnasaction_time					DATETIME		NOT NULL 					COMMENT '트랜잭션 발생 시간',						
	
	PRIMARY KEY (transaction_id)
) DEFAULT CHARACTER SET utf8 collate utf8_general_ci;


ALTER DATABASE config CHARACTER SET = 'utf8' COLLATE = 'utf8_general_ci';
ALTER DATABASE tenant_XXX CHARACTER SET = 'utf8' COLLATE = 'utf8_general_ci';
