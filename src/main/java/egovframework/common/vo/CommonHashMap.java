package egovframework.common.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.HashMap;

import org.egovframe.rte.psl.dataaccess.util.CamelUtil;
import org.hsqldb.lib.StringUtil;

@SuppressWarnings("serial")
public class CommonHashMap<K, V> extends HashMap<K, V> implements Serializable {
	// 카멜 케이스형태의 key put 메소드를 수행할지 여부
	private boolean putCamelCaseKey = true;

	public boolean isPutCamelCaseKey() {
		return putCamelCaseKey;
	}

	public void setPutCamelCaseKey(boolean putCamelCaseKey) {
		this.putCamelCaseKey = putCamelCaseKey;
	}

	/**
	 * <PRE>
	 * key 에 대하여 Camel Case 변환하여 super.put 을 호출한다.
	 * </PRE>
	 *
	 * @param key '_' 가 포함된 변수명
	 * @param value  명시된 key 에 대한 값 (변경 없음)
	 * @return V 키와 관련한 기존 값. 없거나 null 인경우 null 반환
	 */
	@SuppressWarnings("unchecked")
	@Override
	public V put(final K key, final V value) {
		if (!putCamelCaseKey) {
			return super.put(key, value);
		}

		return super.put((K)(CamelUtil.convert2CamelCase((String) key)), value);
	}
	
	/**
	 * String type 으로 가져오기
	 * 
	 * @param key
	 * @return
	 */
	public String getString(final K key) {
		String val = "";
		
		if (super.get(key) != null) {
			if (super.get(key) instanceof String) {
				val	= (String)super.get(key);
			} else if(super.get(key) instanceof BigDecimal) {
				val	= ((BigDecimal)super.get(key)).toString();
			}
		}
		
		return val;
	}
	
	/**
	 * int type으로 가져오기
	 * 
	 * @param key
	 * @return
	 */
	public int getInt(final K key) {
		int intVal = 0;
		String stringVal = this.getString(key);
		
		if (!StringUtil.isEmpty(stringVal)) {
			intVal	= Integer.parseInt(stringVal);
		}
		
		return intVal;
	}
}