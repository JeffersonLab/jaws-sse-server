package org.jlab.jaws.business.session;

import java.io.IOException;
import java.io.StringReader;
import java.math.BigInteger;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.annotation.security.PermitAll;
import javax.annotation.security.RolesAllowed;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonValue;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.*;
import org.jlab.jaws.persistence.entity.*;
import org.jlab.jaws.persistence.model.RuleSet;
import org.jlab.smoothness.business.exception.UserFriendlyException;

/**
 * @author ryans
 */
@Stateless
public class SyncRuleFacade extends AbstractFacade<SyncRule> {
  private static final Logger logger = Logger.getLogger(SyncRuleFacade.class.getName());

  @EJB ActionFacade actionFacade;
  @EJB LocationFacade locationFacade;
  @EJB SyncServerFacade serverFacade;
  @EJB SystemFacade systemFacade;

  @PersistenceContext(unitName = "webappPU")
  private EntityManager em;

  @Override
  protected EntityManager getEntityManager() {
    return em;
  }

  public SyncRuleFacade() {
    super(SyncRule.class);
  }

  private List<Predicate> getFilters(
      CriteriaBuilder cb,
      Root<SyncRule> root,
      BigInteger syncId,
      String actionName,
      String systemName) {
    List<Predicate> filters = new ArrayList<>();

    Join<AlarmEntity, Action> actionJoin = root.join("action");
    Join<Action, SystemEntity> systemJoin = actionJoin.join("system");

    if (syncId != null) {
      filters.add(cb.equal(root.get("syncRuleId"), syncId));
    }

    if (actionName != null && !actionName.isEmpty()) {
      filters.add(cb.like(cb.lower(actionJoin.get("name")), actionName.toLowerCase()));
    }

    if (systemName != null && !systemName.isEmpty()) {
      filters.add(cb.like(cb.lower(systemJoin.get("name")), systemName.toLowerCase()));
    }

    return filters;
  }

  @PermitAll
  public List<SyncRule> filterList(
      BigInteger syncId, String actionName, String systemName, int offset, int max) {
    CriteriaBuilder cb = getEntityManager().getCriteriaBuilder();
    CriteriaQuery<SyncRule> cq = cb.createQuery(SyncRule.class);
    Root<SyncRule> root = cq.from(SyncRule.class);
    cq.select(root);

    List<Predicate> filters = getFilters(cb, root, syncId, actionName, systemName);

    if (!filters.isEmpty()) {
      cq.where(cb.and(filters.toArray(new Predicate[] {})));
    }

    List<Order> orders = new ArrayList<>();
    Path p0 = root.get("action").get("name");
    Order o0 = cb.asc(p0);
    orders.add(o0);
    Path p1 = root.get("server").get("syncServerId");
    Order o1 = cb.asc(p1);
    orders.add(o1);
    Path p2 = root.get("description");
    Order o2 = cb.asc(p2);
    orders.add(o2);
    Path p3 = root.get("syncRuleId");
    Order o3 = cb.asc(p3);
    orders.add(o3);
    cq.orderBy(orders);
    return getEntityManager()
        .createQuery(cq)
        .setFirstResult(offset)
        .setMaxResults(max)
        .getResultList();
  }

  @PermitAll
  public long countList(BigInteger syncId, String actionName, String systemName) {
    CriteriaBuilder cb = getEntityManager().getCriteriaBuilder();
    CriteriaQuery<Long> cq = cb.createQuery(Long.class);
    Root<SyncRule> root = cq.from(SyncRule.class);

    List<Predicate> filters = getFilters(cb, root, syncId, actionName, systemName);

    if (!filters.isEmpty()) {
      cq.where(cb.and(filters.toArray(new Predicate[] {})));
    }

    cq.select(cb.count(root));
    TypedQuery<Long> q = getEntityManager().createQuery(cq);
    return q.getSingleResult();
  }

  @RolesAllowed("jaws-admin")
  public BigInteger addSync(
      BigInteger actionId,
      String syncServerName,
      String description,
      String query,
      String expression,
      String primaryAttribute,
      String foreignAttribute,
      String foreignQuery,
      String foreignExpression,
      String name,
      String screencommand,
      String pv,
      boolean subLocations)
      throws UserFriendlyException {
    if (actionId == null) {
      throw new UserFriendlyException("Action is required");
    }

    Action action = actionFacade.find(actionId);

    if (action == null) {
      throw new UserFriendlyException("Action not found with ID: " + actionId);
    }

    if (syncServerName == null || syncServerName.isEmpty()) {
      throw new UserFriendlyException("Sync server name is required");
    }

    SyncServer server = serverFacade.findByName(syncServerName);

    if (server == null) {
      throw new UserFriendlyException("Sync server not found with name: " + syncServerName);
    }

    if (query == null || query.isBlank()) {
      throw new UserFriendlyException("Query is required");
    }

    int count = 0;

    if (primaryAttribute != null && !primaryAttribute.isBlank()) {
      count++;
    }

    if (foreignAttribute != null && !foreignAttribute.isBlank()) {
      count++;
    }

    if (foreignQuery != null && !foreignQuery.isBlank()) {
      count++;
    }

    if (count > 0 && count < 3) {
      throw new UserFriendlyException(
          "Primary Attribute, Foreign Attribute, and Foreign Query are all required to join");
    }

    if (name == null || name.isBlank()) {
      throw new UserFriendlyException("Name field in the Template is required");
    }

    SyncRule rule = new SyncRule();
    rule.setAction(action);

    rule.setSyncServer(server);
    rule.setDescription(description);
    rule.setQuery(query);
    rule.setPropertyExpression(expression);
    rule.setPrimaryAttribute(primaryAttribute);
    rule.setForeignAttribute(foreignAttribute);
    rule.setForeignQuery(foreignQuery);
    rule.setForeignExpression(foreignExpression);
    rule.setAlarmName(name);
    rule.setScreenCommand(screencommand);
    rule.setPv(pv);
    rule.setSubLocations(subLocations);

    create(rule);

    return rule.getSyncRuleId();
  }

  @RolesAllowed("jaws-admin")
  public void removeSync(BigInteger id) throws UserFriendlyException {
    if (id == null) {
      throw new UserFriendlyException("Sync Rule ID is required");
    }

    SyncRule rule = find(id);

    if (rule == null) {
      throw new UserFriendlyException("Sync Rule not found with ID: " + id);
    }

    // We must manually unlink any linked alarms
    List<AlarmEntity> alarmList = rule.getAlarmList();

    if (alarmList != null) {
      for (AlarmEntity alarm : alarmList) {
        alarm.setSyncRule(null);
        alarm.setSyncElementId(null);
        em.merge(alarm);
      }
    }

    remove(rule);
  }

  @RolesAllowed("jaws-admin")
  public void editSync(
      BigInteger id,
      BigInteger actionId,
      String syncServerName,
      String description,
      String query,
      String expression,
      String primaryAttribute,
      String foreignAttribute,
      String foreignQuery,
      String foreignExpression,
      String name,
      String screencommand,
      String pv,
      boolean subLocations)
      throws UserFriendlyException {
    if (id == null) {
      throw new UserFriendlyException("Sync Rule ID is required");
    }

    SyncRule rule = find(id);

    if (rule == null) {
      throw new UserFriendlyException("Sync Rule not found with ID: " + id);
    }

    if (actionId == null) {
      throw new UserFriendlyException("Action is required");
    }

    Action action = actionFacade.find(actionId);

    if (action == null) {
      throw new UserFriendlyException("Action not found with ID: " + actionId);
    }

    if (syncServerName == null || syncServerName.isEmpty()) {
      throw new UserFriendlyException("Sync server name is required");
    }

    SyncServer server = serverFacade.findByName(syncServerName);

    if (server == null) {
      throw new UserFriendlyException("Sync server not found with name: " + syncServerName);
    }

    int count = 0;

    if (primaryAttribute != null && !primaryAttribute.isBlank()) {
      count++;
    }

    if (foreignAttribute != null && !foreignAttribute.isBlank()) {
      count++;
    }

    if (foreignQuery != null && !foreignQuery.isBlank()) {
      count++;
    }

    if (count > 0 && count < 3) {
      throw new UserFriendlyException(
          "Primary Attribute, Foreign Attribute, and Foreign Query are all required to join");
    }

    if (name == null || name.isBlank()) {
      throw new UserFriendlyException("Name field in the Template is required");
    }

    rule.setAction(action);
    rule.setSyncServer(server);
    rule.setDescription(description);
    rule.setQuery(query);
    rule.setPropertyExpression(expression);
    rule.setPrimaryAttribute(primaryAttribute);
    rule.setForeignAttribute(foreignAttribute);
    rule.setForeignQuery(foreignQuery);
    rule.setForeignExpression(foreignExpression);
    rule.setAlarmName(name);
    rule.setScreenCommand(screencommand);
    rule.setPv(pv);
    rule.setSubLocations(subLocations);

    edit(rule);
  }

  private String fetchAndParse(SyncRule rule, String url) throws UserFriendlyException {
    String body = null;

    HttpClient client = HttpClient.newHttpClient();

    HttpRequest request = HttpRequest.newBuilder().uri(URI.create(url)).build();

    HttpResponse<String> response = null;
    try {
      response = client.send(request, HttpResponse.BodyHandlers.ofString());
    } catch (IOException | InterruptedException e) {
      logger.log(Level.SEVERE, "Unable to query URL: " + url, e);
      throw new UserFriendlyException("Unable to execute request for url " + url, e);
    }

    if (200 == response.statusCode()) {
      body = response.body();
    } else {
      throw new UserFriendlyException("Response code " + response.statusCode());
    }

    return body;
  }

  private LinkedHashMap<BigInteger, AlarmEntity> fetchAndParseWithIdMap(
      SyncRule rule, Map<String, Location> locationMap, String url) throws UserFriendlyException {
    LinkedHashMap<BigInteger, AlarmEntity> alarmList = null;

    String body = fetchAndParse(rule, url);

    if (body != null) {
      alarmList = convertResponseWithIdMap(body, rule, locationMap);
    }

    return alarmList;
  }

  private LinkedHashMap<String, AlarmEntity> fetchAndParseWithAttributeMap(
      SyncRule rule, Map<String, Location> locationMap, String url) throws UserFriendlyException {
    LinkedHashMap<String, AlarmEntity> alarmList = null;

    String body = fetchAndParse(rule, url);

    if (body != null) {
      alarmList = convertResponseWithAttributeMap(body, rule, locationMap);
    }

    return alarmList;
  }

  @RolesAllowed("jaws-admin")
  public LinkedHashMap<BigInteger, AlarmEntity> executeRule(SyncRule rule)
      throws UserFriendlyException {

    Map<String, Location> locationMap = loadSegmaskToLocationMap();

    String url = rule.getSearchURL();

    LinkedHashMap<BigInteger, AlarmEntity> primaryMap =
        fetchAndParseWithIdMap(rule, locationMap, url);

    LinkedHashMap<BigInteger, AlarmEntity> joinMap = primaryMap;

    url = rule.getJoinSearchURL();

    if (url != null && !url.isBlank()) {
      LinkedHashMap<String, AlarmEntity> foreignMap =
          fetchAndParseWithAttributeMap(rule, locationMap, url);

      joinMap = new LinkedHashMap<>();

      for (AlarmEntity alarm : primaryMap.values()) {
        AlarmEntity foreign = foreignMap.get(alarm.getJoinAttributeValue());

        if (foreign != null) {
          String foreignName = foreign.getSyncElementName();
          String name = alarm.getName();
          String screenCommand = alarm.getScreenCommand();
          String pv = alarm.getPv();

          name = applyForeignExpressionVars(name, foreignName);
          screenCommand = applyForeignExpressionVars(screenCommand, foreignName);
          pv = applyForeignExpressionVars(pv, foreignName);

          alarm.setName(name);
          alarm.setScreenCommand(screenCommand);
          alarm.setPv(pv);

          joinMap.put(alarm.getSyncElementId(), alarm);
        }
      }
    }

    return joinMap;
  }

  private AlarmEntity convertEntity(
      SyncRule rule, Map<String, Location> locationMap, boolean primary, JsonObject o) {
    BigInteger elementId = o.getJsonNumber("id").bigIntegerValue();
    String elementName = o.getString("name");
    String alias = "";

    List<Location> locationList = null;
    String joinAttributeValue = null;
    JsonObject properties = null;
    String joinAttribute = rule.getPrimaryAttribute();
    String alarmName = "";
    String screenCommand = "";
    String pv = "";

    Map<String, String> variableMap = new HashMap<>();
    variableMap.put("ElementName", elementName);

    if (o.containsKey("properties")) {
      properties = o.getJsonObject("properties");

      if (primary) {
        if (properties.containsKey("NameAlias") && !properties.isNull("NameAlias")) {
          alias = properties.getString("NameAlias");
          variableMap.put("NameAlias", alias);
        }

        if (properties.containsKey("SegMask") && !properties.isNull("SegMask")) {
          String segMask = properties.getString("SegMask");
          variableMap.put("SegMask", segMask);

          locationList = locationsFromSegMask(locationMap, segMask, rule.getSyncServer());

          if (!locationList.isEmpty()) {
            String area = locationList.get(0).getSegmask();

            if (area == null) {
              area = "";
            }

            area = area.split(",")[0];
            variableMap.put("Area", area);
          }
        }

        List<String> nameTokens = getTemplateVars(rule.getAlarmName());
        List<String> commandTokens = getTemplateVars(rule.getScreenCommand());
        List<String> pvTokens = getTemplateVars(rule.getPv());

        Set<String> tokenSet = new HashSet<>(nameTokens);
        tokenSet.addAll(commandTokens);
        tokenSet.addAll(pvTokens);

        for (String token : tokenSet) {

          if (!variableMap.containsKey(token)
              && properties.containsKey(token)
              && !properties.isNull(token)) {
            String tokenValue = properties.getString(token);

            // System.err.println("Adding token: " + token + "=" + tokenValue);

            variableMap.put(token, tokenValue);
          }
        }
      }
    }

    if (primary) {
      variableMap.put("ActionName", rule.getAction().getName());

      alarmName = applyExpressionVars(rule.getAlarmName(), variableMap);
      screenCommand = applyExpressionVars(rule.getScreenCommand(), variableMap);
      pv = applyExpressionVars(rule.getPv(), variableMap);
    } else {
      alarmName = elementName + rule.getAlarmName();
      joinAttribute = rule.getForeignAttribute();
    }

    if (joinAttribute != null && !joinAttribute.isBlank()) {
      switch (joinAttribute.toLowerCase()) {
        case "name":
          joinAttributeValue = elementName;
          break;
        case "controlled_by":
          if (properties != null
              && properties.containsKey("Controlled_by")
              && !properties.isNull("Controlled_by")) {
            joinAttributeValue = properties.getString("Controlled_by");
          }
          break;
        case "housed_by":
          if (properties != null
              && properties.containsKey("Housed_by")
              && !properties.isNull("Housed_by")) {
            joinAttributeValue = properties.getString("Housed_by");
          }
          break;
      }
    }

    AlarmEntity alarm = new AlarmEntity();
    alarm.setSyncElementName(elementName);
    alarm.setSyncElementId(elementId);
    alarm.setSyncRule(rule);
    alarm.setName(alarmName);
    alarm.setAlias(alias);
    alarm.setAction(rule.getAction());
    alarm.setLocationList(locationList);
    alarm.setScreenCommand(screenCommand);
    alarm.setPv(pv);
    alarm.setJoinAttributeValue(joinAttributeValue);

    return alarm;
  }

  private static final Pattern p = Pattern.compile("\\{(.*?)}");

  private List<String> getTemplateVars(String input) {
    List<String> resultList = new ArrayList<>();

    if (input != null) {
      Matcher m = p.matcher(input);
      while (m.find()) {
        resultList.add(m.group(1));
      }
    }

    return resultList;
  }

  private LinkedHashMap<BigInteger, AlarmEntity> convertResponseWithIdMap(
      String body, SyncRule rule, Map<String, Location> locationMap) {
    LinkedHashMap<BigInteger, AlarmEntity> alarmList = new LinkedHashMap<>();

    JsonObject object = Json.createReader(new StringReader(body)).readObject();

    JsonObject inventory = object.getJsonObject("Inventory");
    JsonArray elements = inventory.getJsonArray("elements");

    for (JsonValue v : elements) {
      JsonObject o = v.asJsonObject();

      AlarmEntity alarm = convertEntity(rule, locationMap, true, o);

      alarmList.put(alarm.getSyncElementId(), alarm);
    }

    return alarmList;
  }

  private LinkedHashMap<String, AlarmEntity> convertResponseWithAttributeMap(
      String body, SyncRule rule, Map<String, Location> locationMap) {
    LinkedHashMap<String, AlarmEntity> alarmList = new LinkedHashMap<>();

    JsonObject object = Json.createReader(new StringReader(body)).readObject();

    JsonObject inventory = object.getJsonObject("Inventory");
    JsonArray elements = inventory.getJsonArray("elements");

    for (JsonValue v : elements) {
      JsonObject o = v.asJsonObject();

      AlarmEntity alarm = convertEntity(rule, locationMap, false, o);

      alarmList.put(alarm.getJoinAttributeValue(), alarm);
    }

    return alarmList;
  }

  private String applyForeignExpressionVars(String input, String foreignName) {
    String result = "";

    if (input != null) {
      result = input.replaceAll("\\{ForeignName}", foreignName);
    }

    return result;
  }

  private String applyExpressionVars(String input, Map<String, String> variableMap) {
    String result = input;

    if (result == null) {
      result = "";
    } else {
      for (String key : variableMap.keySet()) {
        String value = variableMap.get(key);

        // TODO: Escape regex reserved chars in key?

        result = result.replaceAll("\\{" + key + "}", value);
      }
    }

    return result;
  }

  private Map<String, Location> loadSegmaskToLocationMap() {
    Map<String, Location> map = new HashMap<>();

    List<Location> locationList = locationFacade.findAll();

    for (Location location : locationList) {
      String segmaskCsv = location.getSegmask();

      if (segmaskCsv != null) {
        String[] masks = segmaskCsv.split(",");

        for (String mask : masks) {
          if (mask != null && !mask.isBlank()) {
            map.put(mask.trim(), location);
          }
        }
      }
    }

    return map;
  }

  private List<Location> locationsFromSegMask(
      Map<String, Location> locationMap, String segMask, SyncServer server) {
    // Use Set because some SegMasks map to same Location so we want to avoid duplicates
    Set<Location> locationList = new HashSet<>();

    if (segMask != null && !segMask.isEmpty()) {
      String[] masks = segMask.split("\\+");

      for (String mask : masks) {
        if (mask != null && !mask.isBlank()) {
          Location loc = locationMap.get(mask.trim());

          if (loc != null) {
            locationList.add(loc);
          }
        }
      }
    }

    // Often SegMask includes implicit locations (parent locations in same branch)
    List<Location> explicitOnly = new ArrayList<>();

    Location rootLocation = getRoot(locationList);

    // If There is more than 1 location then root is implied
    if (locationList.size() > 1) {
      locationList.remove(rootLocation);
    }

    for (Location location : locationList) {
      if (isLowestInBranch(location, locationList)) {
        explicitOnly.add(location);
      }
    }

    // TODO: Deployment/Sync Server area names may collide / may not be unique.  We may need to have
    // a separate map
    // per Sync Server.  In the meantime, I'm only aware of one collision: LERF Injector collides
    // with CEBAF Injector
    if ("LED".equals(server.getName())) {
      ListIterator<Location> iterator = explicitOnly.listIterator();
      while (iterator.hasNext()) {
        Location location = iterator.next();
        if ("Injector".equals(location.getName())) {
          iterator.remove();
          break;
        }
      }
    }

    return explicitOnly;
  }

  private boolean isLowestInBranch(Location location, Set<Location> locationList) {
    boolean lowest = true;

    Set<Location> descendents = getDescendents(location);

    for (Location loc : locationList) {
      if (descendents.contains(loc)) {
        lowest = false;
        break;
      }
    }

    return lowest;
  }

  private Set<Location> getDescendents(Location location) {
    Set<Location> descendents = new HashSet<>(location.getChildList());

    for (Location loc : location.getChildList()) {
      descendents.addAll(getDescendents(loc));
    }

    return descendents;
  }

  private Location getRoot(Set<Location> locationList) {
    Location root = null;
    for (Location location : locationList) {
      if (location.getLocationId().equals(Location.TREE_ROOT) && location.getParent() == null) {
        root = location;
        break;
      }
    }

    return root;
  }

  @PermitAll
  public List<RuleSet> findSystemRuleSetList(String systemName) {
    Map<String, RuleSet> ruleSetMap = new LinkedHashMap<>();

    List<SystemEntity> systemList = systemFacade.filterList(systemName, null, 0, Integer.MAX_VALUE);

    for (SystemEntity s : systemList) {
      RuleSet rs = new RuleSet(s.getName());
      ruleSetMap.put(s.getName(), rs);
    }

    List<SyncRule> ruleList = findAll();

    for (SyncRule r : ruleList) {
      SystemEntity s = r.getAction().getSystem();

      RuleSet rs = ruleSetMap.get(s.getName());

      if (rs != null) {
        rs.addSyncRule(r);
      }
    }

    return new ArrayList<>(ruleSetMap.values());
  }
}
