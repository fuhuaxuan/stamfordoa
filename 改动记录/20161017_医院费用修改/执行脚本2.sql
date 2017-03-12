---权限执行脚本
declare
  v_EntGid  varchar2(32);
begin
select Gid into v_EntGid from Ent where Lower(code) = Lower('prlintra'); 
--新增模块权限
delete from rt where id in ('prl_feedtl','prl_feedtldown');

insert into rt(id,name,atype,alevel,url,aorder,memo) values('prl_feedtl','费用明细列表','DOA管理','30','/bin/hdnet.dll/__explainmodule?url=prl_feedtl','800421','费用明细列表');
insert into rt(id,name,atype,alevel,url,aorder,memo) values('prl_feedtldown','费用明细列表','DOA管理','30','/bin/hdnet.dll/__explainmodule?url=prl_feedtldown','800422','费用明细下载');

--将权限默认给管理员组
--插入企业权限
delete from ent_rt where entgid = v_EntGid and rtid in ('prl_feedtl','prl_feedtldown');
insert into ent_rt select v_EntGid , id from rt where id in ('prl_feedtl','prl_feedtldown');

--插入管理员权限
delete from org_rt where entgid = v_EntGid and rtid in ('prl_feedtl','prl_feedtldown');
insert into org_rt select v_EntGid ,org.gid , rt.id,'10' from org, rt where org.entgid = v_EntGid and lower(org.code) = lower('admin_grp') and rt.id in ('prl_feedtl','prl_feedtldown');

--插入组织所有权限表
delete from org_rt_all where entgid = v_EntGid and rtid in ('prl_feedtl','prl_feedtldown');
insert into org_rt_all select v_EntGid ,org.gid , rt.id,'10' from org, rt where org.entgid = v_EntGid and lower(org.code) = lower('admin_grp') and rt.id in ('prl_feedtl','prl_feedtldown');

end;
/
commit;