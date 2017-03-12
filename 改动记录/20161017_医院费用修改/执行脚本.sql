---Ȩ��ִ�нű�
declare
  v_EntGid  varchar2(32);
begin
select Gid into v_EntGid from Ent where Lower(code) = Lower('prlintra'); 
--����ģ��Ȩ��
delete from rt where id in ('prl_acgset','prl_acgsetsave');

insert into rt(id,name,atype,alevel,url,aorder,memo) values('prl_acgset','��Ŀ����������','DOA����','30','/bin/hdnet.dll/__explainmodule?url=prl_acgset','800419','��Ŀ����������');
insert into rt(id,name,atype,alevel,url,aorder,memo) values('prl_acgsetsave','��Ŀ����������','DOA����','30','/bin/hdnet.dll/__explainmodule?url=prl_acgsetsave','800420','��Ŀ���������ñ���');

--��Ȩ��Ĭ�ϸ�����Ա��
--������ҵȨ��
delete from ent_rt where entgid = v_EntGid and rtid in ('prl_acgset','prl_acgsetsave');
insert into ent_rt select v_EntGid , id from rt where id in ('prl_acgset','prl_acgsetsave');

--�������ԱȨ��
delete from org_rt where entgid = v_EntGid and rtid in ('prl_acgset','prl_acgsetsave');
insert into org_rt select v_EntGid ,org.gid , rt.id,'10' from org, rt where org.entgid = v_EntGid and lower(org.code) = lower('admin_grp') and rt.id in ('prl_acgset','prl_acgsetsave');

--������֯����Ȩ�ޱ�
delete from org_rt_all where entgid = v_EntGid and rtid in ('prl_acgset','prl_acgsetsave');
insert into org_rt_all select v_EntGid ,org.gid , rt.id,'10' from org, rt where org.entgid = v_EntGid and lower(org.code) = lower('admin_grp') and rt.id in ('prl_acgset','prl_acgsetsave');

end;
/
commit;

drop table PRL_AcgSet;			
create table PRL_AcgSet (			
	EntGid 	varchar2(32)	not null,
	Gid	varchar2(32)	not null,
	--		
	ComGid	varchar2(32)	null,
	ComName	varchar2(64)	null,
	AcgGid	varchar2(32)	null,
	AcgCode	varchar2(64)	null,
	AcgName	varchar2(128)	null,
	AUsrGid	varchar2(32)	null,
	AUsrCode	varchar2(64)	null,
	AUsrName	varchar2(128)	null,
	constraint PK_AcgSet primary key(EntGid, Gid)		
	);		
