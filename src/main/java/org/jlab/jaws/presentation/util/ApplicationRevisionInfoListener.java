package org.jlab.jaws.presentation.util;

import java.io.Serializable;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.hibernate.envers.EntityTrackingRevisionListener;
import org.hibernate.envers.RevisionType;
import org.jlab.jaws.business.session.AlarmFacade;
import org.jlab.jaws.persistence.entity.AlarmEntity;
import org.jlab.jaws.persistence.entity.ApplicationRevisionInfo;
import org.jlab.smoothness.presentation.filter.AuditContext;

/**
 * @author ryans
 */
public class ApplicationRevisionInfoListener implements EntityTrackingRevisionListener {

  private AlarmFacade lookupAlarmFacade() {
    try {
      InitialContext ic = new InitialContext();
      return (AlarmFacade) ic.lookup("java:global/jaws/AlarmFacade");
    } catch (NamingException e) {
      throw new RuntimeException("Unable to obtain EJB", e);
    }
  }

  @Override
  public void newRevision(Object o) {
    ApplicationRevisionInfo revisionInfo = (ApplicationRevisionInfo) o;

    AuditContext context = AuditContext.getCurrentInstance();

    String ip = null;
    String username = null;

    if (context == null || "jaws-admin".equals(context.getExtra("effectiveRole"))) {
      ip = "localhost";
      username = "jaws-admin";
    } else {
      ip = context.getIp();
      username = context.getUsername();
    }

    revisionInfo.setAddress(ip);
    revisionInfo.setUsername(username);
  }

  @Override
  public void entityChanged(
      Class aClass, String s, Serializable serializable, RevisionType revisionType, Object o) {
    if (AlarmEntity.class.equals(aClass)) {
      System.err.println("Alarm class modified!");
    }

    AlarmFacade alarmFacade = lookupAlarmFacade();

    AlarmEntity alarmEntity = alarmFacade.find(serializable);

    if (alarmEntity != null) {
      System.err.println("Locations: " + alarmEntity.getLocationIdCsv());
    } else {
      System.err.println("entity is null.  Prob was deleted");
    }

    ApplicationRevisionInfo revisionInfo = (ApplicationRevisionInfo) o;

    System.err.println("ID: " + revisionInfo.getId());
  }
}
