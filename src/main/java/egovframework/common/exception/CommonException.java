package egovframework.common.exception;

@SuppressWarnings("serial")
public class CommonException extends RuntimeException {
    /** 
     * The Business error code. 
     */
    public String commonErrCode;
    
    /**
     * The Business message.
     */
    public String commonMessage;
    
    /**
     * The Message.
     */
    public String message;

    public String getCommonErrCode() {
		return commonErrCode;
	}

	public void setCommonErrCode(String commonErrCode) {
		this.commonErrCode = commonErrCode;
	}

	public String getCommonMessage() {
		return commonMessage;
	}

	public void setCommonMessage(String commonMessage) {
		this.commonMessage = commonMessage;
		this.message = commonMessage;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	/**
     * Instantiates a new Business exception.
     *
     * @param cause the cause
     */
    public CommonException(Throwable cause) {
        super(cause);
    }

    /**
     * Instantiates a new Business exception.
     *
     * @param commonMessage the Business message
     */
    public CommonException(String commonMessage) {
    	this("error", commonMessage);
    }

    /**
     * Instantiates a new Business exception.
     *
     * @param commonErrCode the Business error code
     * @param commonMessage the Business message
     */
    public CommonException(String commonErrCode, String commonMessage) {
        super(commonMessage);
        this.setCommonErrCode(commonErrCode);
        this.setCommonMessage(commonMessage);
    }

    /**
     * Instantiates a new Business exception.
     *
     * @param commonErrCode the Business error code
     * @param commonMessage the Business message
     * @param cause      the cause
     */
    public CommonException(String commonErrCode, String commonMessage, Throwable cause) {
        super(cause);
        this.setCommonErrCode(commonErrCode);
        this.setCommonMessage(commonMessage);
    }
}