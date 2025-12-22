-- 租户mtfac的默认用户角色
INSERT INTO "role" ("id", "name", "remark", "is_admin", "route_ids", "params", "update_time") VALUES ('1', 'Admin', 'This is a built-in role with full menu access permissions.', 't', NULL, NULL, now());

-- 默认用户mtfac与角色关联关系
INSERT INTO "user_role_relation" ("id", "role_id", "user_id") VALUES ('1', '1', '1');
-- INSERT INTO "user_role_relation" ("id", "role_id", "user_id") VALUES ('2', '1', '2');
