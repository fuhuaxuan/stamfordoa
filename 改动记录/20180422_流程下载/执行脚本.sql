---Ȩ��ִ�нű�
declare
  v_EntGid  varchar2(32);
begin
select Gid into v_EntGid from Ent where Lower(code) = Lower('prlintra'); 
--����ģ��Ȩ��
delete from rt where id in ('wfflowdown','wftodotaskdown');

insert into rt(id,name,atype,alevel,url,aorder,memo) values('wftodotaskdown','����Ӧ��','�������̹���','30','/bin/hdnet.dll/__explainmodule?url=wftodotaskdown','210025','����Ӧ��');
insert into rt(id,name,atype,alevel,url,aorder,memo) values('wfflowdown','����ʵ������','�������̹���','30','/bin/hdnet.dll/__explainmodule?url=wfflowdown','210014','����ʵ������');

--��Ȩ��Ĭ�ϸ�����Ա��
--������ҵȨ��
delete from ent_rt where entgid = v_EntGid and rtid in ('wfflowdown','wftodotaskdown');
insert into ent_rt select v_EntGid , id from rt where id in ('wfflowdown','wftodotaskdown');

--�������ԱȨ��
delete from org_rt where entgid = v_EntGid and rtid in ('wfflowdown','wftodotaskdown');
insert into org_rt select v_EntGid ,org.gid , rt.id,'10' from org, rt where org.entgid = v_EntGid and lower(org.code) = lower('admin_grp') and rt.id in ('wfflowdown','wftodotaskdown');

--������֯����Ȩ�ޱ�
delete from org_rt_all where entgid = v_EntGid and rtid in ('wfflowdown','wftodotaskdown');
insert into org_rt_all select v_EntGid ,org.gid , rt.id,'10' from org, rt where org.entgid = v_EntGid and lower(org.code) = lower('admin_grp') and rt.id in ('wfflowdown','wftodotaskdown');

end;
/
commit;

-- ��������Ȩ���û����Ȩ��
delete Org_RT
 where EntGid = getEntGid
   and RTID in ('wftodotaskdown');
insert into Org_rt
  select getEntGid, o.OrgGid, r.id, o.ATYPE
    from Org_rt o, rt r
   where o.EntGid = getEntGid
     and o.RTID = 'wftodotask'
     and r.id in ('wftodotaskdown');

delete Org_RT_All
 where EntGid = getEntGid
   and RTID in ('wftodotaskdown');

insert into Org_RT_All
  select getEntGid, o.OrgGid, r.id, o.ATYPE
    from Org_RT_All o, rt r
   where o.EntGid = getEntGid
     and o.RTID = 'wftodotask'
     and r.id in ('wftodotaskdown');
commit;


-- ��������Ȩ���û����Ȩ��
delete Org_RT
 where EntGid = getEntGid
   and RTID in ('wfflowdown');
insert into Org_rt
  select getEntGid, o.OrgGid, r.id, o.ATYPE
    from Org_rt o, rt r
   where o.EntGid = getEntGid
     and o.RTID = 'wfflowlist'
     and r.id in ('wfflowdown');

delete Org_RT_All
 where EntGid = getEntGid
   and RTID in ('wfflowdown');

insert into Org_RT_All
  select getEntGid, o.OrgGid, r.id, o.ATYPE
    from Org_RT_All o, rt r
   where o.EntGid = getEntGid
     and o.RTID = 'wfflowlist'
     and r.id in ('wfflowdown');
commit;