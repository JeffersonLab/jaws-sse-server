package org.jlab.jaws.persistence.entity;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.List;
import java.util.Objects;
import javax.persistence.*;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import org.hibernate.envers.Audited;
import org.hibernate.envers.NotAudited;
import org.hibernate.envers.RelationTargetAuditMode;
import org.jlab.jaws.persistence.model.Node;
import org.jlab.smoothness.persistence.util.YnStringToBoolean;

@Entity
@Table(name = "LOCATION", schema = "JAWS_OWNER")
@Audited
public class Location implements Serializable, Node, Comparable<Location> {
  private static final long serialVersionUID = 1L;

  public static final BigInteger TREE_ROOT = BigInteger.ZERO;

  @Id
  @SequenceGenerator(name = "LocationId", sequenceName = "LOCATION_ID", allocationSize = 1)
  @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "LocationId")
  @Basic(optional = false)
  @NotNull
  @Column(name = "LOCATION_ID", nullable = false, precision = 22, scale = 0)
  private BigInteger locationId;

  @Size(max = 64)
  @Column(length = 64)
  private String name;

  private BigInteger weight;

  @Size(max = 128)
  @Column(length = 128, nullable = true)
  private String segmask;

  @Basic
  @Column(name = "SUB_LOCATION_YN", nullable = false, length = 1)
  @Convert(converter = YnStringToBoolean.class)
  private boolean subLocation;

  @JoinColumn(name = "PARENT_ID", referencedColumnName = "LOCATION_ID", nullable = true)
  @ManyToOne(optional = true)
  @Audited(targetAuditMode = RelationTargetAuditMode.NOT_AUDITED)
  private Location parent;

  @OneToMany(mappedBy = "parent")
  @OrderBy("weight ASC, name ASC")
  @NotAudited
  private List<Location> childList;

  @JoinTable(
      name = "ALARM_LOCATION",
      joinColumns = {
        @JoinColumn(name = "LOCATION_ID", referencedColumnName = "LOCATION_ID", nullable = false)
      },
      inverseJoinColumns = {
        @JoinColumn(name = "ALARM_ID", referencedColumnName = "ALARM_ID", nullable = false)
      })
  @ManyToMany
  @NotAudited
  private List<AlarmEntity> alarmList;

  public BigInteger getLocationId() {
    return locationId;
  }

  public void setLocationId(BigInteger locationId) {
    this.locationId = locationId;
  }

  public String getName() {
    return name;
  }

  @Override
  public BigInteger getId() {
    return getLocationId();
  }

  @Override
  public List<? extends Node> getChildren() {
    return childList;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Location getParent() {
    return parent;
  }

  public void setParent(Location parent) {
    this.parent = parent;
  }

  public BigInteger getWeight() {
    return weight;
  }

  public String getSegmask() {
    return segmask;
  }

  public void setSegmask(String segmask) {
    this.segmask = segmask;
  }

  public boolean isSubLocation() {
    return subLocation;
  }

  public void setSubLocation(boolean subLocation) {
    this.subLocation = subLocation;
  }

  public void setWeight(BigInteger weight) {
    this.weight = weight;
  }

  public List<Location> getChildList() {
    return childList;
  }

  public void setChildList(List<Location> childList) {
    this.childList = childList;
  }

  public List<AlarmEntity> getAlarmList() {
    return alarmList;
  }

  public void setAlarmList(List<AlarmEntity> alarmList) {
    this.alarmList = alarmList;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof Location)) return false;
    Location entity = (Location) o;
    return Objects.equals(name, entity.name);
  }

  @Override
  public int hashCode() {
    return Objects.hash(name);
  }

  public String toTreeString() {
    StringBuilder builder = new StringBuilder();

    toTreeString(builder, 0);

    return builder.toString();
  }

  public void toTreeString(StringBuilder builder, int indent) {

    String indentStr = "";

    if (indent > 0 && indent < 50) {
      for (int i = 0; i < indent; i++) {
        indentStr = indentStr + " ";
      }
    }

    builder.append(indentStr);
    builder.append(name);
    builder.append("\n");

    for (Location child : childList) {
      child.toTreeString(builder, indent + 1);
    }
  }

  @Override
  public int compareTo(Location o) {
    return this.getName().compareTo(o.getName());
  }
}
