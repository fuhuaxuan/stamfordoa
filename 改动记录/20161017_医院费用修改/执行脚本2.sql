---Ȩ��ִ�нű�
declare
  v_EntGid  varchar2(32);
begin
select Gid into v_EntGid from Ent where Lower(code) = Lower('prlintra'); 
--����ģ��Ȩ��
delete from rt where id in ('prl_feedtl','prl_feedtldown');

insert into rt(id,name,atype,alevel,url,aorder,memo) values('prl_feedtl','������ϸ�б�','DOA����','30','/bin/hdnet.dll/__explainmodule?url=prl_feedtl','800421','������ϸ�б�');
insert into rt(id,name,atype,alevel,url,aorder,memo) values('prl_feedtldown','������ϸ�б�','DOA����','30','/bin/hdnet.dll/__explainmodule?url=prl_feedtldown','800422','������ϸ����');

--��Ȩ��Ĭ�ϸ�����Ա��
--������ҵȨ��
delete from ent_rt where entgid = v_EntGid and rtid in ('prl_feedtl','prl_feedtldown');
insert into ent_rt select v_EntGid , id from rt where id in ('prl_feedtl','prl_feedtldown');

--�������ԱȨ��
delete from org_rt where entgid = v_EntGid and rtid in ('prl_feedtl','prl_feedtldown');
insert into org_rt select v_EntGid ,org.gid , rt.id,'10' from org, rt where org.entgid = v_EntGid and lower(org.code) = lower('admin_grp') and rt.id in ('prl_feedtl','prl_feedtldown');

--������֯����Ȩ�ޱ�
delete from org_rt_all where entgid = v_EntGid and rtid in ('prl_feedtl','prl_feedtldown');
insert into org_rt_all select v_EntGid ,org.gid , rt.id,'10' from org, rt where org.entgid = v_EntGid and lower(org.code) = lower('admin_grp') and rt.id in ('prl_feedtl','prl_feedtldown');

end;
/
commit;