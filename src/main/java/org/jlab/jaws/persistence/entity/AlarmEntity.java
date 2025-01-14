package org.jlab.jaws.persistence.entity;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import javax.persistence.*;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import org.hibernate.envers.AuditJoinTable;
import org.hibernate.envers.Audited;
import org.hibernate.envers.RelationTargetAuditMode;

@Entity
@Audited
@Table(name = "ALARM", schema = "JAWS_OWNER")
public class AlarmEntity implements Serializable {
  private static final long serialVersionUID = 1L;

  @Id
  @SequenceGenerator(name = "AlarmId", sequenceName = "ALARM_ID", allocationSize = 1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "AlarmId")
  @Basic(optional = false)
  @NotNull
  @Column(name = "ALARM_ID", nullable = false, precision = 22, scale = 0)
  private BigInteger alarmId;

  @Size(max = 64)
  @Column(length = 64, nullable = false)
  private String name;

  @Size(max = 64)
  @Column(length = 64)
  private String alias;

  @JoinColumn(name = "ACTION_ID", referencedColumnName = "ACTION_ID", nullable = false)
  @ManyToOne(optional = false)
  private Action action;

  @OneToMany(fetch = FetchType.EAGER)
  @JoinTable(
      name = "ALARM_LOCATION",
      joinColumns = @JoinColumn(name = "ALARM_ID"),
      inverseJoinColumns = @JoinColumn(name = "LOCATION_ID"))
  @AuditJoinTable(name = "ALARM_LOCATION_AUD")
  private List<Location> locationList;

  @Size(max = 64)
  @Column(name = "DEVICE", length = 64, nullable = true)
  private String device;

  @Size(max = 512)
  @Column(name = "SCREEN_COMMAND", length = 512, nullable = true)
  private String screenCommand;

  @Size(max = 64)
  @Column(name = "MANAGED_BY", length = 64, nullable = true)
  private String managedBy;

  @Size(max = 64)
  @Column(name = "MASKED_BY", length = 64, nullable = true)
  private String maskedBy;

  @Size(max = 64)
  @Column(length = 64, nullable = true)
  private String pv;

  @Size(max = 64)
  @Column(name = "SYNC_ELEMENT_NAME", length = 64, nullable = true)
  private String syncElementName;

  @Column(name = "SYNC_ELEMENT_ID", nullable = true, precision = 22, scale = 0)
  private BigInteger syncElementId;

  @JoinColumn(name = "SYNC_RULE_ID", referencedColumnName = "SYNC_RULE_ID", nullable = true)
  @ManyToOne(optional = true)
  @Audited(targetAuditMode = RelationTargetAuditMode.NOT_AUDITED)
  private SyncRule syncRule;

  @Transient // The following doesn't work in Hibernate 5.3: @OneToOne(mappedBy = "alarm")
  private Notification notification;
  @Transient private List<AlarmOverride> overrideList;

  @Transient private String joinAttributeValue;

  public BigInteger getAlarmId() {
    return alarmId;
  }

  public void setAlarmId(BigInteger alarmId) {
    this.alarmId = alarmId;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getAlias() {
    return alias;
  }

  public void setAlias(String alias) {
    this.alias = alias;
  }

  public Action getAction() {
    return action;
  }

  public void setAction(Action action) {
    this.action = action;
  }

  public List<Location> getLocationList() {
    return locationList;
  }

  public void setLocationList(List<Location> locationList) {
    this.locationList = locationList;
  }

  public String getDevice() {
    return device;
  }

  public void setDevice(String device) {
    this.device = device;
  }

  public String getScreenCommand() {
    return screenCommand;
  }

  public void setScreenCommand(String screenCommand) {
    this.screenCommand = screenCommand;
  }

  public String getManagedBy() {
    return managedBy;
  }

  public void setManagedBy(String managedBy) {
    this.managedBy = managedBy;
  }

  public String getMaskedBy() {
    return maskedBy;
  }

  public void setMaskedBy(String maskedBy) {
    this.maskedBy = maskedBy;
  }

  public String getPv() {
    return pv;
  }

  public void setPv(String pv) {
    this.pv = pv;
  }

  public String getSyncElementName() {
    return syncElementName;
  }

  public void setSyncElementName(String syncElementName) {
    this.syncElementName = syncElementName;
  }

  public BigInteger getSyncElementId() {
    return syncElementId;
  }

  public void setSyncElementId(BigInteger syncElementId) {
    this.syncElementId = syncElementId;
  }

  public SyncRule getSyncRule() {
    return syncRule;
  }

  public void setSyncRule(SyncRule syncRule) {
    this.syncRule = syncRule;
  }

  public Notification getNotification() {
    return notification;
  }

  public void setNotification(Notification notification) {
    this.notification = notification;
  }

  public List<AlarmOverride> getOverrideList() {
    return overrideList;
  }

  public void setOverrideList(List<AlarmOverride> overrideList) {
    this.overrideList = overrideList;
  }

  public String getLocationIdCsv() {
    String csv = "";

    if (locationList != null && !locationList.isEmpty()) {
      List<Location> sorted = new ArrayList<>(locationList);
      Collections.sort(sorted);

      csv = sorted.get(0).getLocationId().toString();

      for (int i = 1; i < sorted.size(); i++) {
        csv = csv + ", " + sorted.get(i).getLocationId().toString();
      }
    }

    return csv;
  }

  public String getLocationNameCsv() {
    String csv = "";

    if (locationList != null && !locationList.isEmpty()) {
      List<Location> sorted = new ArrayList<>(locationList);
      Collections.sort(sorted);

      csv = sorted.get(0).getName();

      for (int i = 1; i < sorted.size(); i++) {
        csv = csv + ", " + sorted.get(i).getName();
      }
    }

    return csv;
  }

  public List<String> getLocationNameList() {
    List<String> list = new ArrayList<>();

    if (locationList != null && !locationList.isEmpty()) {
      for (int i = 0; i < locationList.size(); i++) {
        String name = locationList.get(i).getName();
        list.add(name);
      }
    }

    Collections.sort(list);

    return list;
  }

  public String getJoinAttributeValue() {
    return joinAttributeValue;
  }

  public void setJoinAttributeValue(String joinAttributeValue) {
    this.joinAttributeValue = joinAttributeValue;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof AlarmEntity)) return false;
    AlarmEntity entity = (AlarmEntity) o;
    return Objects.equals(name, entity.name);
  }

  public boolean syncEquals(AlarmEntity remote) {
    /*System.err.println("Names match: " + Objects.equals(name, that.name));
    System.err.println("Actions match: " + Objects.equals(action, that.action));
    System.err.println("locationList match: " + Objects.equals(getLocationIdCsv(), that.getLocationIdCsv());
    System.err.println("screenCommand match: " + Objects.equals(nvl(screenCommand), nvl(that.screenCommand)));
    System.err.println("pv match: " + Objects.equals(pv, that.pv));*/

    boolean equals =
        Objects.equals(name, remote.name)
            && Objects.equals(getLocationIdCsv(), remote.getLocationIdCsv())
            && Objects.equals(syncElementName, remote.syncElementName);

    if (remote.alias != null && !remote.alias.isBlank()) {
      equals = equals && Objects.equals(alias, remote.alias);
    }

    if (remote.screenCommand != null && !remote.screenCommand.isBlank()) {
      equals = equals && Objects.equals(screenCommand, remote.screenCommand);
    }

    if (remote.pv != null && !remote.pv.isBlank()) {
      equals = equals && Objects.equals(pv, remote.pv);
    }

    return equals;
  }

  @Override
  public int hashCode() {
    return Objects.hash(name);
  }
}
