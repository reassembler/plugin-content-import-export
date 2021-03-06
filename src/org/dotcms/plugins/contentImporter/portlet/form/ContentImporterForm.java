package org.dotcms.plugins.contentImporter.portlet.form;

import com.dotmarketing.portlets.scheduler.struts.SchedulerForm;

public class ContentImporterForm extends SchedulerForm {

    private static final long serialVersionUID = 1L;

	/** identifier field */    
	
	private String structure = "";
	private long language = 0;
	private String[] fields = new String[0];
	private String filePath;
	private String reportEmail;
	private String csvSeparatorDelimiter;
	private String csvTextDelimiter;
	private boolean publishContent;
	private boolean newForm;
	private String cronExpression;
	private boolean haveCronExpression;
	
	public boolean isHaveCronExpression() {
		return haveCronExpression;
	}

	public void setHaveCronExpression(boolean haveCronExpression) {
		this.haveCronExpression = haveCronExpression;
	}

	public String getCronExpression() {
		return cronExpression;
	}

	public void setCronExpression(String cronExpression) {
		this.cronExpression = cronExpression;
	}
	
	public ContentImporterForm() {
		super();
		this.newForm = true;
	}
	
	/**
	 * @return the newForm
	 */
	public boolean isNewForm() {
		return newForm;
	}

	/**
	 * @param newForm the newForm to set
	 */
	public void setNewForm(boolean newForm) {
		this.newForm = newForm;
	}

	/**
	 * @return the filePath
	 */
	public String getFilePath() {
		return filePath;
	}

	/**
	 * @param filePath the filePath to set
	 */
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	/**
	 * @return the reportEmail
	 */
	public String getReportEmail() {
		return reportEmail;
	}

	/**
	 * @param reportEmail the reportEmail to set
	 */
	public void setReportEmail(String reportEmail) {
		this.reportEmail = reportEmail;
	}

	/**
	 * @return the csvSeparatorDelimiter
	 */
	public String getCsvSeparatorDelimiter() {
		return csvSeparatorDelimiter;
	}

	/**
	 * @param csvSeparatorDelimiter the csvSeparatorDelimiter to set
	 */
	public void setCsvSeparatorDelimiter(String csvSeparatorDelimiter) {
		this.csvSeparatorDelimiter = csvSeparatorDelimiter;
	}

	/**
	 * @return the csvTextDelimiter
	 */
	public String getCsvTextDelimiter() {
		return csvTextDelimiter;
	}

	/**
	 * @param csvTextDelimiter the csvTextDelimiter to set
	 */
	public void setCsvTextDelimiter(String csvTextDelimiter) {
		this.csvTextDelimiter = csvTextDelimiter;
	}

	/**
	 * @return the publishContent
	 */
	public boolean isPublishContent() {
		return publishContent;
	}

	/**
	 * @param publishContent the publishContent to set
	 */
	public void setPublishContent(boolean publishContent) {
		this.publishContent = publishContent;
	}

    public String[] getFields() {
        return fields;
    }

    public void setFields(String[] fields) {
        this.fields = fields;
    }

    public String getStructure() {
        return structure;
    }

    public void setStructure(String structure) {
        this.structure = structure;
    }
    
    public long getLanguage() {
        return language;
    }

    public void setLanguage(long language) {
        this.language = language;
    }
}