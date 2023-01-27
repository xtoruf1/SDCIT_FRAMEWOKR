package egovframework.common.dao;

import java.lang.reflect.Method;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.transaction.annotation.Transactional;

import egovframework.common.login.vo.LoginUserVO;
import egovframework.common.util.HttpUtil;
import egovframework.common.util.StringUtil;
import egovframework.common.vo.CommonVO;

public class CommonDAO extends EgovAbstractMapper {
	private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());

	@Override
	public int insert(String queryId, Object paramObject) {
		return super.insert(queryId, this.setDefaultParam(paramObject));
	}

	@Override
	public int update(String queryId, Object paramObject) {
		return super.update(queryId, this.setDefaultParam(paramObject));
	}

	@Override
	public int delete(String queryId, Object paramObject) {
		return super.delete(queryId, this.setDefaultParam(paramObject));
	}

	@Override
	public <T> T selectOne(String queryId, Object paramObject) {
		return super.selectOne(queryId, this.setDefaultParam(paramObject));
	}

	@Override
	public <K, V> Map<K, V> selectMap(String queryId, Object paramObject, String mapKey) {
		return super.selectMap(queryId, this.setDefaultParam(paramObject), mapKey);
	}

	@Override
	public <K, V> Map<K, V> selectMap(String queryId, Object paramObject, String mapKey, RowBounds rowBounds) {
		return super.selectMap(queryId, this.setDefaultParam(paramObject), mapKey, rowBounds);
	}

	@Override
	public <E> List<E> selectList(String queryId, Object paramObject) {
		return super.selectList(queryId, this.setDefaultParam(paramObject));
	}

	@Override
	public <E> List<E> selectList(String queryId, Object paramObject, RowBounds rowBounds) {
		return super.selectList(queryId, this.setDefaultParam(paramObject), rowBounds);
	}

	@Override
	public List<?> listWithPaging(String queryId, Object paramObject, int pageIndex, int pageSize) {
		return super.listWithPaging(queryId, this.setDefaultParam(paramObject), pageIndex, pageSize);
	}

	@Transactional
	public int batchInsert(String statement, List<?> paramList) {
		int result = 0;
		SqlSession batchSqlSession = null;

		try {
			batchSqlSession = ((SqlSessionTemplate)super.getSqlSession()).getSqlSessionFactory().openSession(ExecutorType.BATCH);

			int i = 1;
			for (Object param : paramList) {
				if (i % 1000 == 0) {
					batchSqlSession.flushStatements();
				}

				result += batchSqlSession.insert(statement, param);

				i++;
			}

			batchSqlSession.flushStatements();
		} finally {
			if (batchSqlSession != null) {
				batchSqlSession.close();
			}
		}

		return result;
	}

	@Transactional
	public int batchUpdate(String statement, List<?> paramList) {
		int result = 0;
		SqlSession batchSqlSession = null;

		try {
			batchSqlSession = ((SqlSessionTemplate)super.getSqlSession()).getSqlSessionFactory().openSession(ExecutorType.BATCH);

			int i = 1;
			for (Object param : paramList) {
				if (i % 1000 == 0) {
					batchSqlSession.flushStatements();
				}

				result += batchSqlSession.update(statement, param);

				i++;
			}

			batchSqlSession.flushStatements();
		} finally {
			if (batchSqlSession != null) {
				batchSqlSession.close();
			}
		}

		return result;
	}

	/**
	 * setDefaultParam
	 * 파라미터에 정보 주입
	 *
	 * @param paramObject
	 * @return
	 */
	private Object setDefaultParam(Object paramObject) {
		// 원시타입클래스이거나 수퍼클래스가 없는 경우
		if (paramObject == null || paramObject.getClass().isPrimitive() || paramObject.getClass().getSuperclass() == null) {
			return paramObject;
		}

		// 세션정보를 가져온다.
		LoginUserVO user = new LoginUserVO();

		String loginId = "";
		String memberNm = "";
		String infoCheckYn = "N";

		try {
			user = HttpUtil.getSessionInfo();
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
		}

		if (user != null) {
			if (!StringUtil.isEmpty(user.getLoginId())) {
				loginId = user.getLoginId();
			} else {
				loginId = "admin";
			}

			if (!StringUtil.isEmpty(user.getMemberNm())) {
				memberNm = user.getMemberNm();
			} else {
				memberNm = "슈퍼관리자";
			}

			if (!StringUtil.isEmpty(user.getInfoCheckYn())) {
				infoCheckYn = user.getInfoCheckYn();
			} else {
				infoCheckYn = "N";
			}
		}

		if (paramObject instanceof CommonVO) {
			try {
				// 등록자 아이디
				Method setRegId = paramObject.getClass().getMethod("setRegId", String.class);

				if (setRegId != null) {
					Method getRegId =  paramObject.getClass().getMethod("getRegId");

					if (StringUtil.isEmpty(StringUtil.nvl(getRegId.invoke(paramObject)))) {
						setRegId.invoke(paramObject, loginId);
					}
				}

				// 등록자 이름
				Method setRegNm = paramObject.getClass().getMethod("setRegNm", String.class);

				if (setRegNm != null) {
					Method getRegNm =  paramObject.getClass().getMethod("getRegNm");

					if (StringUtil.isEmpty(StringUtil.nvl(getRegNm.invoke(paramObject)))) {
						setRegNm.invoke(paramObject, memberNm);
					}
				}

				// 수정자 아이디
				Method setUpdId =  paramObject.getClass().getMethod("setUpdId", String.class);

				if (setUpdId != null) {
					Method getUpdId =  paramObject.getClass().getMethod("getUpdId");

					if (StringUtil.isEmpty(StringUtil.nvl(getUpdId.invoke(paramObject)))) {
						setUpdId.invoke(paramObject, loginId);
					}
				}

				// 수정자 이름
				Method setUpdNm = paramObject.getClass().getMethod("setUpdNm", String.class);

				if (setUpdNm != null) {
					Method getUpdNm =  paramObject.getClass().getMethod("getUpdNm");

					if (StringUtil.isEmpty(StringUtil.nvl(getUpdNm.invoke(paramObject)))) {
						setUpdNm.invoke(paramObject, memberNm);
					}
				}

				// 서버 프로파일
				String activeProfile = StringUtil.nvl(System.getProperty("spring.profiles.active"), "local");
				Method setActiveProfile =  paramObject.getClass().getMethod("setActiveProfile", String.class);

				if (setActiveProfile != null) {
					Method getActiveProfile =  paramObject.getClass().getMethod("getActiveProfile");

					if (StringUtil.isEmpty(StringUtil.nvl(getActiveProfile.invoke(paramObject)))) {
						setActiveProfile.invoke(paramObject, activeProfile);
					}
				}

				// 개인정보 조회권한
				Method setInfoCheckYn = paramObject.getClass().getMethod("setInfoCheckYn", String.class);

				if (setInfoCheckYn != null) {
					Method getInfoCheckYn =  paramObject.getClass().getMethod("getInfoCheckYn");

					if (StringUtil.isEmpty(StringUtil.nvl(getInfoCheckYn.invoke(paramObject)))) {
						setInfoCheckYn.invoke(paramObject, infoCheckYn);
					}
				}
			} catch (Exception e) {
				LOGGER.debug("SQL 파라미터에 등록자/수정자 주입 실패");
			}
		}

		return paramObject;
	}
}